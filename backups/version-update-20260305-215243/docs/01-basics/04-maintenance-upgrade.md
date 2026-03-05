# 第4章：维护升级

本章围绕 OpenClaw 的日常运维展开，依次介绍更新维护操作、API 配置的完整方法以及版本升级的规范流程。读者完成第2章安装和第3章进阶部署之后，即可将本章作为持续使用阶段的操作手册。

---

## 目录 本章导航

- [更新和维护](#更新和维护)
- [API配置详解](#api配置详解)
- [版本升级指南](#版本升级指南)

其他章节参考：快速安装内容见第2章，进阶部署内容见第3章。

---

## 4.1 更新和维护

定期维护是保证 OpenClaw 稳定运行的基础工作。本节涵盖版本更新、数据备份、运行监控以及常见故障处理，建议将其纳入日常运维流程。

### 检查更新

在执行更新操作之前，应先确认本地已安装版本与最新发布版本的差异。以下命令可分别查看当前版本和仓库最新发布标签：

```bash
//第4章/check-version.sh
# 检查当前版本
openclaw --version

# 检查最新版本
curl -s https://api.github.com/repos/openclaw/openclaw/releases/latest | grep tag_name
```

命令输出中若版本号不一致，则说明有可用更新。结合第4.3节的版本升级指南，可进一步判断是否适合立即升级。

### 本地安装更新

本地安装方式下，更新有两条路径可选。方式一使用官方安装脚本自动完成，适合希望一步到位的用户；方式二通过源码仓库手动拉取，适合需要定制构建的用户：

```bash
//第4章/update-local.sh
# 方式一：使用安装脚本
curl -fsSL https://openclaw.ai/install.sh | bash

# 方式二：手动更新
cd ~/openclaw
git pull origin main
pnpm install
pnpm build
```

更新完成后，建议立即执行 `openclaw --version` 确认版本号已变更，并运行 `openclaw gateway status` 检查服务是否正常启动。

### 备份数据

无论使用何种安装方式，备份都应在更新前完成。数据目录 `~/.openclaw` 中保存了配置文件、会话记录以及插件状态，是整个系统的核心数据来源。

**本地安装备份**

本地安装的备份操作直接对用户目录进行打包：

```bash
//第4章/backup-local.sh
# 备份配置和数据
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz ~/.openclaw

# 恢复数据
tar -xzf openclaw-backup-20260210.tar.gz -C ~/
```

**Docker 备份**

Docker 部署方式需要借助临时容器访问数据卷，以保证备份时文件处于一致状态：

```bash
//第4章/backup-docker.sh
# 备份数据卷
docker run --rm \
  -v ~/.openclaw:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/openclaw-backup-$(date +%Y%m%d).tar.gz /data

# 恢复数据
docker run --rm \
  -v ~/.openclaw:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/openclaw-backup-20260210.tar.gz -C /
```

备份文件建议保留最近三个时间点的版本，并存放到非系统盘或远程存储，以防止单点故障导致数据丢失。

### 监控和日志

OpenClaw 在运行过程中会持续写入日志，通过实时跟踪日志可以快速发现异常。下列命令分别适用于本地安装和 Docker 部署：

```bash
# 本地安装
tail -f ~/.openclaw/logs/gateway.log

# Docker
docker logs -f openclaw
```

除日志外，OpenClaw 还提供了若干状态查询命令，可用于了解服务当前的运行状况和 API 消耗情况：

```bash
# 查看系统状态
openclaw gateway status

# 查看资源使用
openclaw stats

# 查看 API 消耗
openclaw stats api
```

建议将 `openclaw gateway status` 纳入每日巡检，以便及时发现服务中断。

### 故障排查

服务运行过程中难免出现各类异常。以下列出最常见的三类问题及对应的排查命令，多数情况下按顺序执行即可恢复正常。

**Gateway 无法启动**

Gateway 启动失败通常与端口占用或配置损坏有关，首先查看日志以定位根本原因：

```bash
# 查看日志
openclaw logs

# 检查端口占用
lsof -i :18789

# 重启 Gateway
openclaw gateway restart
```

**API 连接失败**

API 连接失败一般由密钥错误或网络不通引起，可通过以下命令逐步验证：

```bash
# 测试 API 连接
openclaw test api

# 检查 API Key
openclaw config get models.providers
```

**性能问题**

当响应速度明显下降时，清理缓存并重启服务通常可以改善：

```bash
# 清理缓存
openclaw cache clear

# 重启服务
openclaw gateway restart
```

### 卸载

若需彻底移除 OpenClaw，应先停止正在运行的服务，再删除相关文件，以避免残留进程占用系统资源。

**本地安装卸载**

```bash
//第4章/uninstall-local.sh
# 停止服务
openclaw gateway stop

# 删除文件
rm -rf ~/.openclaw
rm -rf ~/openclaw

# 删除命令
npm uninstall -g openclaw
```

**Docker 卸载**

```bash
//第4章/uninstall-docker.sh
# 停止并删除容器
docker stop openclaw
docker rm openclaw

# 删除镜像
docker rmi openclaw/openclaw

# 删除数据
rm -rf ~/.openclaw
```

卸载完成后，执行 `which openclaw` 确认命令已从系统中移除。如需重新安装，参照第2章的安装步骤重新操作即可。

---

## 4.2 API配置详解

OpenClaw 本身是一个 AI 驱动的自动化平台，需要连接外部 AI 模型才能提供智能应答能力。本节从模型分类出发，分别介绍内置 API 模型和自定义 API 两种配置方式，并对主流模型的特点进行对比分析，帮助读者在不同使用场景下做出合适的选择。

### API模型分类

OpenClaw 支持两种类型的 API 模型配置，二者在配置复杂度和灵活性上各有侧重，读者可根据自身技术背景和实际需求选择合适的方式。

### 4.2.1 内置 API 模型

内置 API 模型是指 OpenClaw 已预先集成好连接逻辑的主流 AI 服务。用户只需获取对应平台的 API Key，通过配置向导粘贴填入，即可立即开始使用，无需手动编写任何配置文件。这种方式将技术细节完全封装在内部，极大地降低了上手门槛，是新手用户的首选路径。

当前支持的内置模型涵盖国内外主流服务，具体清单如下：

**国内模型（推荐优先选择）**：
- **Moonshot AI（Kimi）**：以超长上下文为核心卖点，支持 200 万字的上下文窗口，擅长长文档阅读、报告分析等场景
- **DeepSeek**：性价比极高，输入费用在国内模型中处于最低档位，推理和编程能力出色，适合高频使用
- **智谱 GLM**：多模态能力较强，中文语义理解稳定，适合需要图文混合处理的场景
- **通义千问（Qwen）**：阿里生态出品，服务稳定性高，与阿里系产品集成便利
- **MiniMax**：对话风格自然流畅，创意类任务表现较好
- **百度文心**：中文训练语料丰富，适合强调中文表达质量的场景
- **字节豆包**：整体性价比较高，适合预算敏感型用户

**国外模型**：
- **OpenAI（GPT-4/GPT-3.5）**：功能全面，生态成熟，但价格相对较高，访问需要具备相应的网络条件
- **Anthropic（Claude）**：推理和逻辑分析能力突出，在安全对齐方面投入较多，适合对输出质量要求较高的场景
- **Google（Gemini）**：多模态能力强，支持原生图文输入
- **Groq**：以推理速度著称，延迟极低，适合对响应速度敏感的实时交互场景

内置模型的主要优势在于：配置向导引导完成全程，参数已由官方优化，跟随 OpenClaw 版本自动更新，不需要用户了解底层协议细节。对于新手用户、主流模型使用者以及不希望维护配置文件的场景，内置 API 模型是最合适的起点。

### 4.2.2 自定义 API

自定义 API 是指用户手动编写配置文件，直接指定 API 服务地址、认证方式和模型参数。这种方式适用于 OpenClaw 尚未内置的模型、自行搭建的推理服务、第三方 API 代理以及企业内部的私有模型接口。

需要使用自定义 API 的典型情形包括：使用 OpenRouter 等聚合代理以统一管理多个模型的访问；使用企业内部基于开源模型自行部署的服务；使用刚刚发布而 OpenClaw 尚未更新支持的新模型；以及需要精细调整上下文窗口大小、最大输出长度等模型参数的场景。

自定义 API 的核心配置文件位于 `~/.openclaw/openclaw.json`，需要手动指定以下字段：`baseUrl` 为 API 服务地址，`apiKey` 为认证密钥，`api` 为协议类型（如 `openai-chat` 或 `anthropic-messages`），`models` 为模型列表及其参数。

自定义 API 的灵活性高，几乎可以对接任何兼容标准协议的 AI 服务，也支持同时配置多个供应商并按需切换。代价是配置过程较为繁琐，需要熟悉 JSON 格式，参数填写错误可能导致服务无法启动，且后续需要用户自行维护配置。

### 配置方式对比

两种配置方式在核心维度上的差异如下表所示，以便读者在选择时快速参考。

见表4-1。

表4-1  内置API模型与自定义API特性对比

| 特性 | 内置API模型 | 自定义API |
|------|------------|-----------|
| 配置难度 | 简单 | 复杂 |
| 适用人群 | 新手 | 进阶用户 |
| 模型选择 | 主流模型 | 任意模型 |
| 配置方式 | 向导选择 | 手动编辑 |
| 维护成本 | 低 | 高 |
| 灵活性 | 中 | 高 |

### 推荐配置路径

对于刚开始使用 OpenClaw 的读者，建议按照以下路径逐步深入，避免一开始就陷入复杂配置而影响体验：

**新手推荐路径**

新手应优先选择内置 API 模型，通过 `openclaw onboard` 配置向导完成初始设置，建议从国产模型（如 Kimi 或 DeepSeek）入手，原因是这两类模型账户注册便捷、计费透明，适合控制初期成本。待熟悉基本操作流程后，再视需求决定是否引入自定义 API。

```
1. 使用内置API模型
2. 选择国产模型（如 Kimi、DeepSeek）
3. 通过 openclaw onboard 向导配置
4. 先体验，熟悉后再考虑自定义
```

**进阶用户路径**

进阶用户同样建议从内置 API 模型起步，在熟悉配置文件的整体结构之后，再逐步添加自定义 API 节点，每次添加后应通过测试命令验证连通性，确认无误后再投入正式使用：

```
1. 先用内置API模型熟悉OpenClaw
2. 了解配置文件结构
3. 根据需求添加自定义API
4. 测试验证后投入使用
```

---

### 内置API模型配置（详细教程）

以下对使用频率最高的几个内置 API 模型给出完整配置流程，包括平台账户准备、API Key 创建和 OpenClaw 接入三个阶段。

### 4.2.3 Kimi 2.5 配置（推荐）

Kimi 是 Moonshot AI 旗下面向开发者的 AI 模型服务，其核心优势是支持 200 万字的超长上下文窗口，在论文阅读、长报告分析和多轮深度对话等场景下表现突出。与此同时，Kimi 对中文的理解质量较高，适合以中文内容为主的日常工作场景。对于重度使用用户，官方提供了套餐购买选项，综合成本低于按量计费。

由于 OpenClaw 在工作流执行中会消耗相对较多的 token，建议在开始前先评估自身使用量，再决定是否购买套餐。

**配置步骤如下。**

**第一步：访问 Kimi Code 平台**

搜索"Kimi Code"或"Moonshot AI 开放平台"即可找到官网入口，注册并登录账号后进入控制台。

**第二步：购买套餐（可选）**

如果预计每月使用量较大，建议在创建 API Key 之前先充值或选购套餐，以确保账户余额充足。推荐的 Allegretto 套餐适合日常中度使用，其他套餐可按需选择。

**第三步：创建 API Key**

在控制台的"API Keys"页面点击"创建 API Key"，名称可自由填写，创建成功后会显示完整密钥字符串。

**第四步：保存 API Key**

此步骤至关重要。API Key 仅在创建成功的页面显示一次，点击"完成"后将无法再次查看完整内容。务必在关闭页面之前将其复制并妥善保存，可存入密码管理工具或安全的文本文件中。

**第五步：配置到 OpenClaw**

打开终端，运行以下命令启动配置向导：

```bash
//第4章/onboard-kimi.sh
# 运行配置向导
openclaw onboard

# 配置流程：
# 1. 选择 QuickStart
# 2. 选择模型供应商：Moonshot AI
# 3. 粘贴刚才复制的API Key
# 4. 选择默认模型：kimi-code/kimi-for-codi
# 5. 完成其他配置
```

配置完成后，向导会自动写入 `~/.openclaw/openclaw.json` 并重启 Gateway。可通过 `openclaw channels status` 验证连接是否正常。

**成本估算**：轻度使用约 10—20 元/月，中度使用约 30—50 元/月，重度使用建议购买套餐以降低单位成本。

---

### 4.2.4 DeepSeek 配置（性价比之王）

DeepSeek 是目前国产大模型中性价比最突出的选择之一，其输入费用在主流模型中处于最低档位（约 0.001 元/千 tokens），同时在代码生成和复杂推理任务上的表现达到了较高水准。对于高频使用 OpenClaw 且希望控制成本的用户，DeepSeek 是极具竞争力的首选模型。

DeepSeek 采用按量付费模式，账户余额必须大于零才能成功调用 API。因此，在创建 API Key 之前需要先完成充值操作，建议初次使用充值 10 元用于测试，确认工作流正常后再按需追加。

**配置步骤如下。**

**第一步：注册并充值**

搜索"DeepSeek 开放平台"即可找到官网入口。注册账号后进入"充值"页面，完成首次充值。请注意，余额不足时 API 调用将直接返回错误，而非进入排队等待状态。

**第二步：创建 API Key**

在控制台的"API Keys"页面，确认账户有余额后点击"创建 API key"。

**第三步：保存 API Key**

DeepSeek 的 API Key 同样只显示一次，务必在关闭页面前完整复制并保存。

**第四步：配置到 OpenClaw**

在终端执行以下命令启动配置向导：

```bash
//第4章/onboard-deepseek.sh
# 运行配置向导
openclaw onboard

# 配置流程：
# 1. 选择 QuickStart
# 2. 选择模型供应商：DeepSeek
# 3. 粘贴API Key
# 4. 选择默认模型：deepseek-chat
# 5. 完成其他配置
```

配置完成后建议通过 `openclaw test api` 验证连通性，确认输出无报错即可正常使用。

**成本估算**：日常使用约 5—10 元/月，中度使用约 10—30 元/月，重度使用约 30—50 元/月，整体成本在主流模型中属于最低档位。

---

### 4.2.5 其他国产大模型

除 Kimi 和 DeepSeek 外，OpenClaw 还内置了多个国产模型的支持。以下对三个常用选项进行简要说明，帮助读者根据具体场景做出选择。各模型的配置流程与 Kimi 基本一致，通过 `openclaw onboard` 向导选择对应供应商并填入 API Key 即可完成接入。

**GLM-4（智谱 AI）**

GLM-4 是智谱 AI 推出的多模态大模型，在图文混合理解、中文语义解析方面表现稳定。价格处于中等水平，适合需要处理图片与文本混合输入场景的用户。搜索"智谱 AI 开放平台"即可找到官网，完成注册后按向导指引创建 API Key。

**通义千问（阿里）**

通义千问是阿里云旗下的大模型服务，凭借阿里生态的基础设施支撑，在服务稳定性和并发处理方面具有优势。如果业务已接入阿里云生态，选择通义千问可以实现统一账号管理，减少多平台维护成本。搜索"阿里云通义千问 API"或"DashScope"即可找到开放平台入口，价格处于中等水平。

**文心一言（百度）**

文心一言是百度推出的大模型服务，中文训练语料丰富，在中文内容生成和理解上积累深厚。价格处于中高水平，适合对中文表达质量有较高要求的场景。搜索"百度智能云文心大模型"或"百度云 AI"即可找到开放平台入口。

---

### 自定义API配置（进阶用户）

本节面向需要连接非内置模型、第三方代理服务或企业私有模型的进阶用户。如果当前使用内置 API 模型已满足需求，可跳过本节，待后续有需要时再回来参考。

#### 什么时候需要自定义API？

以下三类情形是引入自定义 API 的典型场景。第一类是使用非内置模型，包括 OpenClaw 尚未集成的小众模型、新发布尚在灰度阶段的模型，以及区域限定供应的模型。第二类是使用第三方代理，如 OpenRouter 等聚合代理服务、企业内部的 API 网关，或基于开源框架自行搭建的推理服务。第三类是需要精细控制模型参数，例如自定义上下文窗口大小、调整输出长度上限，或者修改默认的采样策略。

如果仅属于以上某一类情形，可优先考虑是否能通过内置模型满足需求，确认无法满足后再引入自定义配置，以减少维护负担。

#### 配置文件位置

自定义 API 的配置统一写入以下路径：

```bash
# 配置文件路径
~/.openclaw/openclaw.json

# 编辑配置文件
nano ~/.openclaw/openclaw.json
```

编辑前建议先备份原始文件，以便配置出错时快速回滚。

#### 配置文件结构

完整的配置文件采用 JSON 格式，顶层结构包含 `models` 和 `agents` 两个主要节点。`models.providers` 下按供应商名称组织各 API 的连接信息，`agents.defaults.model.primary` 指定默认使用的模型路径。以下是通用模板：

```json
//第4章/openclaw-config-template.json
{
  "models": {
    "mode": "merge",
    "providers": {
      "你的供应商名称": {
        "baseUrl": "API服务地址",
        "apiKey": "你的API 密钥",
        "auth": "认证方式",
        "api": "API协议类型",
        "models": [
          {
            "id": "模型ID",
            "name": "模型显示名称",
            "contextWindow": 上下文窗口大小,
            "maxTokens": 最大输出tokens
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "供应商名称/模型ID"
      }
    }
  }
}
```

`mode` 字段设为 `"merge"` 表示将自定义配置与内置配置合并，而非完全替换，这样可以同时保留已有的内置模型选项。

#### 示例1：配置DeepSeek（自定义方式）

以下展示以自定义方式连接 DeepSeek 服务的完整配置。相较于内置向导，自定义方式允许同时注册多个模型（如 deepseek-chat 和 deepseek-coder），并手动指定上下文窗口参数：

```json
//第4章/openclaw-deepseek.json
{
  "models": {
    "mode": "merge",
    "providers": {
      "deepseek": {
        "baseUrl": "https://api.deepseek.com",
        "apiKey": "sk-你的API 密钥",
        "auth": "api-key",
        "api": "openai-chat",
        "models": [
          {
            "id": "deepseek-chat",
            "name": "DeepSeek Chat",
            "contextWindow": 64000,
            "maxTokens": 4096
          },
          {
            "id": "deepseek-coder",
            "name": "DeepSeek Coder",
            "contextWindow": 64000,
            "maxTokens": 4096
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "deepseek/deepseek-chat"
      }
    }
  }
}
```

#### 示例2：配置第三方API代理

OpenRouter 是一类聚合代理服务，支持通过统一接口访问多个主流模型，适合需要频繁切换模型或统一管理费用的用户。搜索"OpenRouter"即可找到该平台官网，注册后获取 API Key，按以下结构填入配置文件：

```json
//第4章/openclaw-openrouter.json
{
  "models": {
    "mode": "merge",
    "providers": {
      "openrouter": {
        "baseUrl": "https://openrouter.ai/api/v1",
        "apiKey": "sk-or-v1-你的密钥",
        "auth": "api-key",
        "api": "openai-chat",
        "models": [
          {
            "id": "anthropic/claude-3.5-sonnet",
            "name": "Claude 3.5 Sonnet",
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "openai/gpt-4",
            "name": "GPT-4",
            "contextWindow": 128000,
            "maxTokens": 4096
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "openrouter/anthropic/claude-3.5-sonnet"
      }
    }
  }
}
```

通过代理服务访问模型时，`baseUrl` 填写代理平台的 API 地址，`api` 字段通常设为 `openai-chat`，因为大多数代理平台对外暴露的是 OpenAI 兼容协议。

#### 示例3：配置多个模型供应商

在同一配置文件中可以同时注册多个供应商，并通过 `fallback` 字段指定主模型不可用时的备选模型。这种配置适合需要在不同模型之间灵活切换，或对可用性有较高要求的场景：

```json
//第4章/openclaw-multi-provider.json
{
  "models": {
    "mode": "merge",
    "providers": {
      "deepseek": {
        "baseUrl": "https://api.deepseek.com",
        "apiKey": "sk-你的DeepSeek密钥",
        "auth": "api-key",
        "api": "openai-chat",
        "models": [
          {
            "id": "deepseek-chat",
            "name": "DeepSeek Chat",
            "contextWindow": 64000,
            "maxTokens": 4096
          }
        ]
      },
      "moonshot": {
        "baseUrl": "https://api.moonshot.cn/v1",
        "apiKey": "sk-你的Kimi密钥",
        "auth": "api-key",
        "api": "openai-chat",
        "models": [
          {
            "id": "moonshot-v1-128k",
            "name": "Kimi 128K",
            "contextWindow": 128000,
            "maxTokens": 4096
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "deepseek/deepseek-chat",
        "fallback": "moonshot/moonshot-v1-128k"
      }
    }
  }
}
```

上述配置将 DeepSeek 设为主模型，Kimi 作为备选。当 DeepSeek 接口不可达时，OpenClaw 会自动切换至 Kimi，保证服务连续性。

#### 配置参数说明

自定义 API 涉及的核心参数及其含义如下表所示：

见表4-2。

表4-2  自定义API配置参数说明

| 参数 | 说明 | 示例 |
|------|------|------|
| `baseUrl` | API服务地址 | `https://api.deepseek.com` |
| `apiKey` | API 密钥 | `sk-xxx` |
| `auth` | 认证方式 | `api-key` 或 `bearer` |
| `api` | API协议 | `openai-chat`、`anthropic-messages` |
| `id` | 模型ID | `deepseek-chat` |
| `name` | 显示名称 | `DeepSeek Chat` |
| `contextWindow` | 上下文窗口 | `64000` |
| `maxTokens` | 最大输出 | `4096` |

#### 常见API协议类型

`api` 字段决定了 OpenClaw 与上游服务通信时使用的协议格式。目前支持以下四种协议，其中 `openai-chat` 兼容性最广，绝大多数国内外模型服务及代理平台均支持：

- `openai-chat`：OpenAI 兼容接口，适用范围最广，推荐作为首选
- `anthropic-messages`：Anthropic Claude 原生接口，直接对接 Claude 官方服务时使用
- `google-generative-ai`：Google Gemini 原生接口，直接对接 Google AI Studio 时使用
- `azure-openai`：Azure OpenAI 服务接口，企业客户通过 Azure 托管 OpenAI 模型时使用

#### 配置后重启服务

修改配置文件后，需要重启 Gateway 使变更生效。以下三种方式均可完成重启，可根据实际部署环境选择：

```bash
//第4章/restart-gateway.sh
# 方式1：重启Gateway
openclaw gateway restart

# 方式2：停止后重新启动
systemctl --user stop openclaw-gateway.service
systemctl --user start openclaw-gateway.service

# 方式3：完全重启
systemctl --user restart openclaw-gateway.service
```

重启完成后，执行 `openclaw gateway status` 确认服务处于运行状态，再通过 `openclaw test api` 验证 API 连接是否正常。

### 各模型费用对比

在确定长期使用的主力模型之前，了解各模型的费用结构有助于合理规划预算。下表对常用模型的输入输出单价及月均估算成本进行了汇总，供参考：

见表4-3。

表4-3  常用模型费用对比（月均估算）

| 模型 | 输入费用 | 输出费用 | 月均估算 |
|------|----------|----------|----------|
| DeepSeek         | 0.001元/千tokens | 0.002元/千tokens | 5—30元     |
| Kimi             | 0.012元/千tokens | 0.012元/千tokens | 10—50元    |
| GLM-4            | 0.005元/千tokens | 0.005元/千tokens | 10—40元    |
| Claude（第三方） | 0.015元/千tokens | 0.075元/千tokens | 50—200元   |
| GPT-4（第三方）  | 0.03元/千tokens  | 0.06元/千tokens  | 100—300元  |

从成本角度来看，DeepSeek 适合作为日常高频对话的主力模型；Kimi 的长上下文特性使其在处理大文件时更具优势，单次调用的总费用并不一定比其他模型高；Claude 和 GPT-4 输出质量高但价格明显偏贵，适合作为处理高难度任务时的补充选项，而非日常主力。合理的成本控制策略是：日常对话用 DeepSeek，长文档处理用 Kimi，复杂分析任务按需调用 Claude。

---

## 4.3 版本升级指南

OpenClaw 持续迭代更新，定期升级可以获得新功能、性能优化和安全修复。本节提供从升级前准备到升级后验证的完整操作流程，同时对已知问题版本作出明确说明，帮助读者在升级过程中避开已知风险。

在阅读本节之前，建议先完成4.1节中的备份操作，确保配置数据得到保护后再继续。

目前推荐使用 **2026.2.9** 版本。2026.2.12 版本存在已知 bug（Issue #15141），会导致 heartbeat 和消息处理功能异常，暂不建议升级至该版本，详见本节末尾的"已知问题版本警告"。

### 推荐版本

**当前推荐版本**：2026.2.9

**已知问题版本**：
- 2026.2.12：Session 路径验证 bug，影响 heartbeat 和 Telegram/飞书消息处理

### 为什么要升级？

OpenClaw 的每次版本更新通常包含以下几类变化：新功能和交互改进、底层性能优化、安全漏洞修复、已知 bug 的修复，以及与外部服务或操作系统的兼容性更新。长期停留在旧版本可能导致某些新功能无法使用，或在特定平台上出现兼容性问题。建议每月检查一次版本更新，安全类修复则应尽快跟进。

### 检查当前版本

升级前应先确认本地已安装的版本号，再对照推荐版本决定是否需要操作：

```bash
# 查看当前版本
openclaw --version

# 查看配置文件版本
cat ~/.openclaw/openclaw.json | grep version
```

如果配置文件中记录的版本号高于当前安装版本，说明配置文件可能由更高版本写入，当前版本可能无法完整解析所有配置字段，此时应优先升级。

### 升级方式选择

OpenClaw 支持多种安装方式，不同安装方式对应不同的升级路径。根据自身安装方式选择对应的升级方法，参考以下对比：

见表4-4。

表4-4  各安装方式对应升级方法

| 安装方式 | 升级方法 | 难度 | 推荐度 |
|---------|---------|------|--------|
| 云端部署 | 重新部署镜像 | 低 | 高 |
| Docker | 拉取新镜像 | 较低 | 高 |
| 本地安装（npm） | npm升级 | 中 | 较高 |
| 本地安装（源码） | git pull | 较高 | 中 |

### 方式一：npm直接升级（推荐）

对于通过 npm 全局安装的用户，此方式最为可靠，可以精确控制目标版本号，避免自动升级到有问题的版本。整个流程分为七步，每步完成后应验证结果再继续。

#### 升级步骤

**第一步：备份配置**

升级前必须完成配置备份，这是出现问题时能够回滚的唯一保障：

```bash
# 备份整个配置目录
cp -r ~/.openclaw ~/.openclaw.backup-$(date +%Y%m%d)

# 验证备份
ls -la ~/.openclaw.backup-*
```

**第二步：停止Gateway服务**

在修改 npm 包之前，应先停止正在运行的 Gateway，防止文件替换过程中出现进程冲突：

```bash
# 停止Gateway
openclaw gateway stop

# 验证已停止
openclaw gateway status
```

**第三步：卸载旧版本**

卸载旧版本可以清除残留的二进制文件，为新版本安装提供干净的环境：

```bash
# 卸载旧版本
npm uninstall -g openclaw

# 验证卸载
which openclaw  # 应该没有输出
```

**第四步：安装新版本**

安装时应指定明确的版本号，避免默认安装到有问题的版本。当前推荐安装 2026.2.9，并附加 `--force` 参数以覆盖可能残留的同名文件：

```bash
# 安装推荐版本 2026.2.9（需要使用--force参数）
npm install -g openclaw@2026.2.9 --force
```

请注意：推荐安装 2026.2.9 版本（当前最稳定）；应避免安装 2026.2.12 版本，该版本存在 session 路径 bug；如果需要最新功能，建议等待 2026.2.13 及后续修复版本发布后再升级。

**第五步：修复配置**

安装完成后，运行 `doctor` 工具自动修复可能因版本变更导致的配置不兼容问题：

```bash
# 运行doctor工具自动修复配置
openclaw doctor --fix
```

`doctor` 工具会自动完成以下操作：更新 Gateway 服务入口点路径、检查配置兼容性、修复已知问题，以及在 macOS 上重新安装 LaunchAgent、在 Linux 上更新 systemd 服务文件。

**第六步：重启Gateway**

配置修复完成后，重启 Gateway 并等待数秒，确认服务进入运行状态：

```bash
# 重启Gateway
openclaw gateway restart

# 等待几秒后检查状态
sleep 5
openclaw gateway status
```

**第七步：验证升级**

最后，通过以下命令全面确认升级结果：

```bash
# 检查版本
openclaw --version

# 检查Gateway状态
openclaw gateway status

# 测试连接
openclaw channels status
```

升级成功后，`openclaw gateway status` 的输出应类似如下内容：

```
2026.2.9

Runtime: running (pid xxxxx, state active)
RPC probe: ok
Listening: *:18789
Dashboard: http://127.0.0.1:18789/
```

### 方式二：官方脚本升级

官方提供了一键升级脚本，通过搜索"OpenClaw 官方安装脚本"或查阅官方文档可以获取命令。该方式适合追求操作简便的用户，但由于脚本会自动拉取最新版本，有时可能安装到存在已知问题的版本，稳定性不如方式一：

```bash
# 运行升级脚本
curl -fsSL https://openclaw.ai/install.sh | bash
```

此方式的优点是一键完成，自动处理依赖关系；缺点是遇到 npm 错误时处理空间较少，且不易控制目标版本。如果执行过程中遇到报错，建议切换到方式一，按步骤手动完成升级。

### 方式三：Docker升级

Docker 部署方式的升级流程最为简洁，通过拉取新镜像并重新启动容器即可完成：

```bash
//第4章/upgrade-docker.sh
# 停止并删除旧容器
docker compose down

# 拉取最新镜像
docker compose pull

# 启动新容器
docker compose up -d openclaw-cn-gateway

# 查看日志
docker compose logs -f openclaw-cn-gateway
```

由于数据卷独立于容器存在，升级过程中配置和历史数据不会丢失。升级完成后，通过查看日志确认容器启动无报错即可。

### 方式四：云端部署升级

**腾讯云 Lighthouse**

云端部署升级通过控制台操作完成，无需命令行介入。进入轻量应用服务器控制台，选择 OpenClaw 实例，点击"重置应用"，选择最新的 OpenClaw 镜像，等待重置完成后重新验证 API 配置（原始配置通常会保留，建议重置后检查一遍）。

### 升级后的变化

版本升级后，系统的部分配置文件和服务管理方式可能随之更新，了解这些变化有助于在出现异常时快速定位原因。

**配置文件自动迁移**

升级后，`doctor` 工具会自动完成以下迁移操作：更新配置文件格式至新版本规范，迁移旧版本的配置字段，并创建备份文件 `~/.openclaw/openclaw.json.bak`。如果迁移后发现某些配置不符合预期，可以对照备份文件手动还原。

**服务管理改进**

在 macOS 上，LaunchAgent 配置文件会被自动重新安装，服务的可执行文件路径更新为新版本，日志文件位于 `~/.openclaw/logs/gateway.log`。在 Linux 上，systemd 服务单元文件会被自动更新，日志文件路径同为 `~/.openclaw/logs/gateway.log`。

**已知警告**

升级后可能在日志或状态输出中看到以下警告，这类警告通常不影响正常使用：

```
Config warnings:
- plugins.entries.feishu: plugin feishu: duplicate plugin id detected
```

这是一个已知的插件重复注册警告，属于轻微的配置冗余问题，不影响飞书插件的实际功能，可以暂时忽略。

### 升级故障排查

升级过程中可能遇到各类报错，以下对五类最常见的问题给出诊断说明和解决方案。

#### 问题1：npm install报错EEXIST

**症状**：

```
npm error code EEXIST
npm error path /usr/local/bin/openclaw
npm error EEXIST: file already exists
```

此报错说明旧版本的二进制文件仍然存在于系统路径中，新版本安装时无法覆盖。解决方案是添加 `--force` 参数强制覆盖：

```bash
# 使用--force参数强制覆盖
npm install -g openclaw@2026.2.9 --force
```

#### 问题2：Gateway启动失败

**症状**：

```
Gateway not running
```

Gateway 无法启动通常与配置文件不兼容或服务入口路径指向旧版本有关。按以下顺序操作可解决大多数情况：

```bash
//第4章/fix-gateway.sh
# 运行doctor修复
openclaw doctor --fix

# 重启Gateway
openclaw gateway restart

# 查看详细日志
tail -f ~/.openclaw/logs/gateway.log
```

#### 问题3：配置文件版本不匹配

**症状**：

```
Config was last written by a newer OpenClaw (2026.2.6-3);
current version is 2026.2.1-zh.3
```

此提示说明当前安装版本低于配置文件记录的版本，需要升级至匹配版本：

```bash
# 升级到推荐版本 2026.2.9
npm install -g openclaw@2026.2.9 --force
openclaw doctor --fix
```

#### 问题4：插件加载失败

**症状**：

```
plugin not found: xxx
```

插件加载失败通常发生在版本跨度较大的升级场景中，可尝试重新安装对应插件，或临时禁用问题插件后再排查：

```bash
# 重新安装插件
openclaw plugins install <plugin-name>

# 或禁用有问题的插件
openclaw config set plugins.allow []
```

#### 问题5：端口被占用

**症状**：

```
Error: listen EADDRINUSE: address already in use :::18789
```

此报错说明默认端口 18789 已被其他进程（通常是残留的旧 Gateway 进程）占用。先找到并终止占用进程，再重启 Gateway：

```bash
//第4章/fix-port.sh
# 查找占用端口的进程
lsof -i :18789

# 停止旧的Gateway进程
kill -9 <PID>

# 或修改端口
openclaw config set gateway.port 18790
openclaw gateway restart
```

### 回滚到旧版本

如果升级后遇到无法通过上述故障排查解决的问题，可以选择回滚到升级前的稳定版本。回滚有两种方式：从备份直接恢复，或通过 npm 指定旧版本重新安装。

#### 方式一：从备份恢复

此方式适合希望快速恢复到升级前完整状态的场景，需要事先完成了配置备份：

```bash
//第4章/rollback-from-backup.sh
# 停止Gateway
openclaw gateway stop

# 恢复配置
cp -r ~/.openclaw.backup-20260213/* ~/.openclaw/

# 降级到旧版本（以中文版为例）
npm uninstall -g openclaw
npm install -g @qingchencloud/openclaw-zh@2026.2.1-zh.3 --force

# 重启Gateway
openclaw gateway restart
```

#### 方式二：安装指定版本

如果没有配置备份，或者只需要降级程序包而不需要恢复配置，可以直接通过 npm 安装指定旧版本：

```bash
//第4章/install-specific-version.sh
# 查看可用版本
npm view openclaw versions

# 安装指定版本
npm install -g openclaw@2026.2.8 --force

# 修复配置
openclaw doctor --fix

# 重启Gateway
openclaw gateway restart
```

### 升级最佳实践

规范化的升级流程可以显著降低意外风险。以下将升级操作拆分为升级前、升级中和升级后三个阶段，每个阶段列出关键操作要点。

#### 升级前必做

升级前应完成四项准备工作，其中备份配置是最重要的一项，其余三项有助于在出现问题时提供参考信息。

备份配置目录：

```bash
cp -r ~/.openclaw ~/.openclaw.backup-$(date +%Y%m%d)
```

记录当前版本号，以便必要时回滚到确切版本：

```bash
openclaw --version > ~/openclaw-version-before-upgrade.txt
```

导出完整配置内容：

```bash
openclaw config get > ~/openclaw-config-backup.json
```

检查磁盘剩余空间，确保新版本安装和备份存放不受空间限制：

```bash
df -h ~
```

#### 升级时注意

升级过程中有三个关键操作，缺少任何一步都可能导致升级不完整。安装时必须附加 `--force` 参数：

```bash
npm install -g openclaw@2026.2.9 --force
```

安装完成后立即运行 `doctor` 修复配置：

```bash
openclaw doctor --fix
```

修复完成后检查 Gateway 服务状态：

```bash
openclaw gateway status
```

如果以上步骤均无报错，说明升级基本完成。如有警告信息，可对照本节的"升级后的变化"部分逐一确认是否为已知的无害警告。

#### 升级后验证

升级后应从版本号、服务连接、插件功能、频道通信和 API 消耗五个维度进行验证，确保没有遗漏的功能回退：

检查版本号是否与目标版本一致：

```bash
openclaw --version
```

测试 Gateway 与各频道的连接状态：

```bash
openclaw channels status
```

查看已安装插件列表，确认关键插件未丢失：

```bash
openclaw plugins list
```

向实际使用的聊天频道发送测试消息，验证 AI 回复和技能调用是否正常。

查看 API 消耗统计，确认账单数据记录正常：

```bash
openclaw stats api
```

### 已知问题版本警告

#### 2026.2.12 版本问题

2026.2.12 版本存在一个严重的 session 文件路径验证 bug，会导致 heartbeat 功能和 Telegram/飞书消息处理完全失效，因此明确不推荐升级到该版本。

该 bug 的具体表现为：Session 文件路径验证逻辑存在错误，导致 heartbeat 功能无法正常执行，同时 Telegram bot 无法响应消息，飞书 bot 可能出现回复异常。错误日志中会出现 `Session file path must be within sessions directory` 提示。受影响的范围包括 heartbeat 功能、Telegram bot 和飞书 bot，网页版界面不受此 bug 影响。

该问题已在官方 GitHub 的 Issue #15141 中被确认，状态为待修复。读者可搜索"OpenClaw GitHub Issues"查看最新进展。

如果已不慎升级到 2026.2.12，应立即回退到 2026.2.9，执行以下命令：

```bash
//第4章/rollback-to-stable.sh
openclaw gateway stop
npm uninstall -g openclaw
npm install -g openclaw@2026.2.9 --force
openclaw doctor --fix
openclaw gateway restart
```

回退完成后，按照"升级后验证"清单逐项检查，确认服务恢复正常。

**推荐做法**：保持 2026.2.9 版本直到 2026.2.13 或更高修复版本发布，关注官方发布渠道获取稳定版本通知，不要跟随"最新版本"盲目升级。

---

### 升级时间建议

升级操作本身存在短暂的服务中断，因此选择合适的时间窗口同样重要。以下给出推荐和不推荐的升级时机，供参考：

**推荐升级时机**：晚间或周末等使用量低峰期；每月例行检查更新时；发现影响当前功能的 bug 且官方已发布修复版本时；以及有安全更新需要及时跟进时。

**不推荐升级时机**：工作日高峰时段，升级失败影响范围大；正在执行重要自动化任务期间；网络环境不稳定时（npm 包下载可能中途失败）；以及尚未完成配置备份时。

### 升级检查清单

以下清单可作为每次升级操作的标准流程参考，逐项确认可有效降低遗漏风险：

**升级前**：
- [ ] 备份配置目录
- [ ] 记录当前版本
- [ ] 检查磁盘空间
- [ ] 选择合适的升级时间

**升级中**：
- [ ] 停止Gateway服务
- [ ] 卸载旧版本
- [ ] 安装新版本（使用--force）
- [ ] 运行doctor修复
- [ ] 重启Gateway

**升级后**：
- [ ] 验证版本号
- [ ] 测试Gateway连接
- [ ] 验证插件功能
- [ ] 测试频道连接
- [ ] 检查日志无错误

---

## 4.4 本章小结

本章系统介绍了 OpenClaw 的运维和升级体系，涵盖三个主要方面。

第一，更新和维护：包括版本检查、数据备份、日志监控、常见故障排查以及完整卸载流程，为日常运维操作提供了标准参考。

第二，API 配置详解：从内置 API 模型与自定义 API 的分类对比出发，分别给出了 Kimi、DeepSeek、GLM-4、通义千问、文心一言等主流模型的接入教程，以及多供应商配置、第三方代理接入和参数调优的进阶用法。

第三，版本升级指南：提供了 npm 直接升级、官方脚本升级、Docker 升级和云端部署升级四种完整流程，结合升级故障排查、回滚操作和最佳实践，帮助读者在各种场景下安全完成版本迭代。

下一步可参阅第5章了解 OpenClaw 的快速上手操作，或参阅第11章了解多平台集成的详细配置方法。第12章和第13章分别介绍飞书以及企微、钉钉、QQ 等平台的专项对接，可结合本章的 API 配置知识进一步拓展应用场景。
