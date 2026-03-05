# 第2章：快速安装

> 本章将手把手教你安装 OpenClaw。

![OpenClaw 安装界面](https://upload.maynor1024.live/file/1771085321300_installation-interface.png)

---

## 📋 前提条件与推荐配置

### 推荐配置

为了获得最佳体验，我们推荐：

**操作系统**：

- 🍎 **Mac（强烈推荐）**：原生支持最完善，可操作日历、备忘录、截图等系统功能
- 🪟 Windows：完全可用，但部分系统集成功能受限
- 🐧 Linux：适合开发者，配置灵活

**IM工具选择**：

- 🌍 **国外用户**：推荐 **Telegram**（适配度最好，功能最完整）
- 🇨🇳 **国内用户**：推荐 **飞书**（现代化、开发友好、功能丰富）
- 备选：企业微信、钉钉、QQ

**部署方式**：

- 💻 **有Mac电脑**：推荐本地部署（体验最好，功能最全）
- ☁️ **无Mac或想24小时运行**：推荐云端部署（成本低，稳定可靠）

### 为什么推荐Mac？

OpenClaw在Mac上体验最好，因为：

- ✅ 原生支持最完善，系统集成度高
- ✅ 可以操作Mac日历、备忘录、提醒事项
- ✅ 截图功能完美支持
- ✅ 与iPhone、iPad无缝同步
- ✅ 文件管理更智能
- ✅ 开发环境配置简单

### 为什么推荐飞书（国内）？

- ✅ 现代化设计，用户体验好
- ✅ 开发者友好，API完善
- ✅ 支持富文本、文档、表格
- ✅ 消息推送稳定
- ✅ 免费版功能丰富

### 为什么推荐Telegram（国外）？

- ✅ 全球用户基础大
- ✅ API最完善，功能最强
- ✅ 支持Bot功能丰富
- ✅ 消息推送实时
- ✅ 隐私保护好

---

## 快速导航

### 推荐路径

- 🍎 **有Mac** → [Mac本地部署](#mac本地部署推荐) + [飞书配置](../03-advanced/09-multi-platform-integration.md#91-飞书bot配置)
- ☁️ **无Mac/想24小时运行** → [云端一键部署](#云端一键部署) + [飞书配置](../03-advanced/09-multi-platform-integration.md#91-飞书bot配置)

### 所有部署方式

**核心方式**（本章）：
- 🍎 [Mac本地部署（推荐）](#mac本地部署推荐)
- ☁️ [云端一键部署](#云端一键部署)
- 🇨🇳 [国内一键安装](#国内一键安装快速版)

**进阶方式**（附录O）：
- 🪟 [Windows本地部署](../../appendix/O-advanced-installation.md#windows本地部署)
- 🐧 [Linux本地部署](../../appendix/O-advanced-installation.md#linux本地部署)
- ☁️ [Cloudflare Workers部署](../../appendix/O-advanced-installation.md#cloudflare-workers部署)
- 🐳 [Docker部署](../../appendix/O-advanced-installation.md#docker部署)

**配置指南**：
- 🔑 [API配置指南](#api配置指南)
- ❓ [常见问题解决](#常见问题解决)

---

## Mac本地部署（推荐）

> 🍎 **最佳体验**：如果你有Mac电脑，强烈推荐本地部署，体验最好、功能最全！

### 为什么选择Mac本地部署？

**优势**：

- ✅ **系统集成**：可操作日历、备忘录、文件系统
- ✅ **隐私安全**：数据完全本地，不上传云端
- ✅ **响应速度快**：本地运行，无网络延迟
- ✅ **功能最全**：支持所有高级功能
- ✅ **成本低**：无需购买云服务器
- ✅ **开发友好**：方便调试和自定义

**适合人群**：

- 有Mac电脑的用户
- 注重隐私的用户
- 需要系统集成功能的用户
- 开发者和技术爱好者

### 系统要求

**硬件要求**：

- CPU：M系列芯片或Intel i5以上
- 内存：8GB以上（推荐16GB）
- 硬盘：10GB以上空闲空间

**系统版本**：

- macOS 12 Monterey 或更高版本
- 推荐 macOS 14 Sonoma 或 macOS 15 Sequoia

**前置软件**：

- Node.js 22.0.0+（会自动安装）
- Homebrew（可选，用于安装依赖）

### 安装步骤

#### 第一步：打开终端

1. 按 `Command + 空格` 打开 Spotlight
2. 输入 `Terminal` 或`终端`
3. 按回车打开终端

![Mac终端打开方式 - 通过Spotlight搜索Terminal](https://upload.maynor1024.live/file/1770742238798_07-select-quickstart.png)

#### 第二步：安装 OpenClaw

在终端中执行以下命令：

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

安装过程会自动：
- 检测系统环境
- 安装Node.js（如果未安装）
- 下载OpenClaw
- 配置环境变量

**预计时间**：2-5分钟

#### 第三步：验证安装

安装完成后，执行以下命令验证：

```bash
openclaw --version
```

如果显示版本号（如 `2026.2.9`），说明安装成功！

#### 第四步：初始化配置

运行配置向导：

```bash
openclaw onboard
```

**配置流程**：

**1. 接受风险提示**：

选择 `Yes` 继续

![安装向导 - 接受风险提示](https://upload.maynor1024.live/file/1770742238798_07-select-quickstart.png)

**2. 选择启动模式**：

推荐选择 `QuickStart` 快速启动：

![安装向导 - 选择QuickStart快速启动模式](https://upload.maynor1024.live/file/1770742238798_07-select-quickstart.png)

**3. 选择AI模型**：

选择你的AI供应商（支持国内外主流模型）：

![安装向导 - 选择AI模型供应商](https://upload.maynor1024.live/file/1770742221938_03-select-ai-provider.png)

国内推荐：
- **Kimi（Moonshot AI）**：长文本专家，200万字上下文
- **DeepSeek**：性价比之王，推理能力强
- **智谱GLM**：中文理解好，多模态支持

**4. 输入API Key**：

根据选择的模型，输入对应的API Key（参见[API配置指南](#api配置指南)）

**5. 选择聊天工具**：

- 如果要接入飞书/Telegram，选择对应选项
- 如果暂时不接入，选择 `None`（后续可配置）

![安装向导 - 选择聊天平台（飞书/企微/QQ等）](https://upload.maynor1024.live/file/1770742247561_08-select-chat-tool.png)

**6. Gateway端口设置**：

默认 `18789` 即可：

![安装向导 - Gateway端口配置（默认18789）](https://upload.maynor1024.live/file/1770742247410_09-port-setting.png)

**7. 选择Skills**：

使用空格键选择你需要的技能，也可以直接跳过：

![安装向导 - 选择需要安装的技能包](https://upload.maynor1024.live/file/1770742255849_10-select-skills.png)

**8. API Key配置**：

没有的可以选择 `no` 跳过：

![安装向导 - 配置AI模型API 密钥](https://upload.maynor1024.live/file/1770742264976_11-api-key-config.png)

**9. 启用Hooks**：

推荐启用这三个钩子（用于内容引导、日志和会话记录）：

![安装向导 - 启用自动化钩子功能](https://upload.maynor1024.live/file/1770742261487_12-enable-hooks.png)

**10. 完成配置**：

配置完成后，会自动启动Gateway服务并打开Web UI（`http://127.0.0.1:18789/chat`）

#### 第五步：验证安装

```bash
# 检查Gateway状态
openclaw channels status

# 应该显示：
# Gateway reachable.
```

---

### 日常使用

**启动OpenClaw**：

```bash
# 启动Gateway服务
openclaw gateway start

# 或使用systemd（推荐，开机自启）
openclaw gateway enable
```

**访问Web UI**：

打开浏览器访问：`http://127.0.0.1:18789/chat`

**停止服务**：

```bash
openclaw gateway stop
```

---

### 接入飞书（推荐）

Mac本地部署后，强烈推荐接入飞书，获得最佳体验：

1. 参考 [第12章：飞书Bot配置](../03-advanced/12-feishu-bot.md)
2. 配置完成后，可以在飞书中随时与OpenClaw对话
3. 支持文本、图片、文件等多种消息类型

### 常见问题

**Q1：安装时提示权限不足？**

```bash
# 使用sudo安装
curl -fsSL https://openclaw.ai/install.sh | sudo bash
```

**Q2：如何更新OpenClaw？**

```bash
openclaw update
```

**Q3：如何卸载？**

```bash
openclaw uninstall
```

---

**劣势**：

- ⚠️ 需要一定技术基础
- ⚠️ 需要保持电脑开机
- ⚠️ 网络环境要求高

### 安装步骤

#### 第一步：安装 Homebrew（如果未安装）

```bash
# 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 第二步：安装 Node.js

```bash
# 安装 Node.js 22+
brew install node@22

# 验证安装
node --version  # 应该显示 v22.x.x
```

#### 第三步：安装 OpenClaw

```bash
# 使用 npm 全局安装
npm install -g openclaw@latest

# 验证安装
openclaw --version
```

#### 第四步：运行配置向导

```bash
# 运行入门向导
openclaw onboard --install-daemon
```

配置向导会引导你完成：
- ✅ 选择网关模式（本地/远程）
- ✅ 配置 AI 模型（见下文"快速API配置"）
- ✅ 配置聊天平台（可选）
- ✅ 安装后台服务

#### 第五步：启动 Gateway

```bash
# 检查 Gateway 状态
openclaw gateway status

# 如果未运行，手动启动
openclaw gateway --port 18789
```

#### 第六步：访问 Dashboard

打开浏览器访问：`http://127.0.0.1:18789/`

![OpenClaw Dashboard](https://upload.maynor1024.live/file/1770742223389_04-test-chat.png)

#### 第七步：测试对话

在 Dashboard 中发送测试消息：

```
你好，能听到我说话吗？
```

如果收到回复，说明配置成功！

### 常见问题

**Q1: Node.js 版本不对？**

```bash
# 检查版本
node --version

# 如果低于 22，升级
brew upgrade node@22
```

**Q2: 权限错误？**

```bash
# 修复权限
sudo chown -R $USER ~/.openclaw
```

**Q3: Gateway 无法启动？**

```bash
# 查看日志
tail -f ~/.openclaw/logs/gateway.log

# 重启 Gateway
openclaw gateway restart
```

---

## 云端一键部署

> ☁️ **适合场景**：无Mac电脑、需要24小时运行、多设备访问。

### 为什么选择云端部署？

**优势**：

- ⚡ **秒级部署**：点几下鼠标就完成，无需配置环境
- 💰 **成本低**：20元/月起，比买Mac便宜太多
- 📱 **手机可用**：通过QQ、企微、飞书随时随地访问
- 🔒 **稳定可靠**：24小时运行，不用担心电脑关机
- 🎥 **视频教程**：官方视频手把手教学

### 方案对比

| 方案 | 价格 | 带宽 | 推荐场景 |
|------|------|------|----------|
| 腾讯云Lighthouse | 20元/月，99元/年 | 20M | QQ、企微用户 |
| 火山引擎 | 9.9元/月，58元/年 | 5M | 飞书用户 |
| 百度智能云 | 0.01元/月（首月） | - | 试用体验 |

### 腾讯云Lighthouse部署（推荐）

#### 第一步：购买服务器

1. **访问腾讯云官网**：搜索"腾讯云轻量应用服务器"
   > 💡 提示：腾讯云经常有新用户优惠活动，建议先查看最新活动

2. **选择配置**：
   - 配置：2核2G
   - 带宽：20M
   - 地域：建议选择**硅谷**（访问AI模型更稳定）
   - 价格：20元/月 或 99元/年

3. **完成购买**：
   - 点击"立即购买"
   - 支付费用
   - 等待服务器创建完成

4. **获取服务器信息**：
   - 点击头像 → "站内信"
   - 记录：公网IP、用户名、密码

![腾讯云Lighthouse控制台](https://upload.maynor1024.live/file/1770742212222_01-tencent-cloud-server.png)

#### 第二步：连接服务器

**方式一：使用SSH客户端（推荐）**

- 下载SSH客户端（如 Termius、FinalShell）
- 新建连接：
  - 地址：公网IP
  - 端口：22
  - 用户名：lighthouse
  - 密码：购买时设置的密码

**方式二：使用网页终端**

- 在腾讯云控制台点击"登录"
- 直接在浏览器中打开终端

#### 第三步：配置大模型

1. 进入"应用管理"标签
2. 选择模型（推荐 **Kimi k2.5**）
3. 获取API Key（见下文"快速API配置"）
4. 填入配置并保存

![选择AI供应商](https://upload.maynor1024.live/file/1770742221938_03-select-ai-provider.png)

#### 第四步：测试连接

1. 访问WebUI：`http://你的服务器IP:18789/?token=xxx`
2. 发送测试消息：`你好，能听到我说话吗？`
3. 验证成功：收到AI回复

![测试对话](https://upload.maynor1024.live/file/1770742223389_04-test-chat.png)

### 火山引擎部署（更便宜）

如果你是飞书用户，推荐使用火山引擎：

1. **访问火山引擎官网**：搜索"火山引擎云服务器"
   > 💡 提示：火山引擎经常有新用户优惠活动，价格约10元/月（2026年初）
2. **配置**：2核2G，5M带宽
4. **部署流程**：与腾讯云类似

### 官方视频教程

腾讯云提供了详细的视频教程：

1. **云上OpenClaw一键部署并接入企微和QQ**
   - 搜索"腾讯云开发者 OpenClaw"可找到视频教程
   - 时长：约10分钟

2. **云上OpenClaw一键部署并接入飞书和钉钉**
   - 搜索"腾讯云开发者 OpenClaw 飞书"可找到视频教程
   - 时长：约10分钟

---

## 国内一键安装（快速版）

> 🇨🇳 **国内用户推荐**：使用官方中文版一键安装脚本，速度快、配置简单。

### 为什么选择国内版？

**优势**：

- ⚡ **速度快**：使用国内镜像源，下载速度快
- 🇨🇳 **中文友好**：完整中文界面和提示
- 📦 **一键安装**：自动配置所有依赖
- 🎯 **开箱即用**：预配置国内常用服务
- 💰 **成本优化**：默认配置国产模型

![国内版安装界面](https://upload.maynor1024.live/file/1770956917086_image-20260213122830687.png)

### 前置要求

- Node.js 22.0.0+（必需）
- macOS / Linux / Windows（WSL2）

### 快速安装

**macOS/Linux**：

```bash
# 使用国内官方安装脚本
curl -fsSL https://clawd.org.cn/install.sh | bash
```

**Windows（WSL2推荐）**：

```powershell
# 1. 安装 WSL2
wsl --install

# 2. 重启电脑

# 3. 在 WSL2 中运行
curl -fsSL https://clawd.org.cn/install.sh | bash
```

### 运行配置向导

```bash
# 运行入门向导
openclaw-cn onboard --install-daemon
```

配置向导会引导你完成：
- ✅ 选择网关模式
- ✅ 配置 AI 模型
- ✅ 配置聊天平台（可选）
- ✅ 安装后台服务

### 启动 Gateway

```bash
# 检查状态
openclaw-cn gateway status

# 访问 Dashboard
# 打开浏览器：http://127.0.0.1:18789/
```

### 快速验证

```bash
# 检查状态
openclaw-cn status

# 健康检查
openclaw-cn health
```

---

## 快速API配置

> 只介绍最推荐的2个模型，详细配置见[第2.2章：维护升级](02-2-maintenance-upgrade.md)

### 推荐模型

#### 1. Kimi（月之暗面）⭐ 推荐

**特点**：
- 📚 超长上下文：支持200万字
- 📄 长文档处理专家
- 🎯 中文理解好
- 💰 套餐划算

**配置步骤**：

1. **访问平台**：https://www.kimi.com/code

2. **购买套餐**（可选）：
   - 推荐：Allegretto套餐
   - 适合日常使用

3. **创建API Key**：
   - 打开控制台
   - 创建API Key
   - 复制并保存（只显示一次！）

![创建Kimi API Key](https://upload.maynor1024.live/file/1770957262024__null_-20260213123418045._null_)

4. **配置到OpenClaw**：

```bash
# 运行配置向导
openclaw onboard

# 选择：
# 1. QuickStart
# 2. 模型供应商：Moonshot AI
# 3. 粘贴API Key
# 4. 选择模型：kimi-code/kimi-for-codi
```

**成本估算**：
- 轻度使用：10-20元/月
- 中度使用：30-50元/月

---

#### 2. DeepSeek（深度求索）💰 最便宜

**特点**：
- 💰 最便宜：输入0.001元/千tokens
- 🧠 推理能力强
- 💻 编程能力出色

**配置步骤**：

1. **注册并充值**：https://platform.deepseek.com/

   ⚠️ **注意**：必须充值才能使用（建议先充10元试用）

![DeepSeek充值](https://upload.maynor1024.live/file/1770961892504__null_-20260213135123663._null_)

2. **创建API Key**：
   - 点击"API keys"
   - 点击"创建API key"
   - 复制并保存（只显示一次！）

![创建DeepSeek API Key](https://upload.maynor1024.live/file/1770957195220__null_-20260213123309627._null_)

3. **配置到OpenClaw**：

```bash
# 运行配置向导
openclaw onboard

# 选择：
# 1. QuickStart
# 2. 模型供应商：DeepSeek
# 3. 粘贴API Key
# 4. 选择模型：deepseek-chat
```

**成本估算**：
- 日常使用：5-10元/月
- 中度使用：10-30元/月

---

### 其他模型

更多模型配置（GLM-4、通义千问、文心一言等）请参考：
- [第2.2章：维护升级](02-2-maintenance-upgrade.md#api配置详解)
- [附录K：API配置指南](../../appendix/K-api-key-config-guide.md)

---

## 常见问题

### 安装问题

**Q1: Node.js版本不对**

```bash
# 检查版本
node --version

# 如果低于22，升级
nvm install 22
nvm use 22
```

**Q2: 权限错误**

```bash
# macOS/Linux
sudo chown -R $USER ~/.openclaw
```

**Q3: 网络连接失败**

- 检查网络连接
- 尝试使用代理
- 或使用云端部署

### API配置问题

**Q1: API Key无效**

- 检查是否完整复制（包括sk-前缀）
- 检查是否有多余空格
- 检查账户余额是否充足

**Q2: 模型不可用**

- 检查模型ID是否正确
- 检查API服务是否正常
- 尝试切换其他模型

**Q3: Token消耗太快**

- 使用更便宜的模型（DeepSeek）
- 优化提示词
- 定期清理会话历史

### Gateway问题

**Q1: Gateway无法启动**

```bash
# 查看日志
tail -f ~/.openclaw/logs/gateway.log

# 重启Gateway
openclaw gateway restart
```

**Q2: 端口被占用**

```bash
# 查看端口占用
lsof -i :18789

# 修改端口
openclaw config set gateway.port 18790
```

---

## 本章小结

本章介绍了OpenClaw的三种主要安装方式：

1. **Mac本地部署**：体验最好，功能最全，适合有Mac的用户
2. **云端一键部署**：成本低，24小时运行，适合无Mac或需要远程访问的用户
3. **国内一键安装**：速度快，中文友好，适合国内用户

同时介绍了两个最推荐的AI模型：
- **Kimi**：长文档处理专家，适合需要处理大量文本的场景
- **DeepSeek**：性价比之王，适合日常使用和编程任务

### 下一步

- 📖 **进阶部署**：如需Windows/Linux/Docker部署，请参考[第3章：进阶部署](03-advanced-deployment.md)
- 🔧 **维护升级**：如需详细API配置和版本升级，请参考[第4章：维护升级](04-maintenance-upgrade.md)
- 🚀 **快速上手**：安装完成后，继续阅读[第5章：快速上手](05-quick-start.md)
- 🔗 **平台集成**：如需接入飞书/企微/钉钉，请参考[第11章：多平台集成](../03-advanced/11-multi-platform-integration.md)

---

**其他章节**：
- [第3章：进阶部署](03-advanced-deployment.md) - Windows、Linux、Docker、Cloudflare部署
- [第4章：维护升级](04-maintenance-upgrade.md) - 更新维护、API详解、版本升级
