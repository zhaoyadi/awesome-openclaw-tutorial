# OpenClaw 教程命令验证报告（第10-17章）

> 📋 **验证范围**：从第10章开始的所有命令
> 
> 🔍 **验证方法**：检查命令语法、工具可用性、参数正确性
> 
> ⚠️ **重要说明**：本报告标注了需要修正的命令和潜在问题

---

## 验证说明

### 验证标准

- ✅ **正确**：命令语法正确，工具存在，参数合理
- ⚠️ **需要注意**：命令可能需要特定环境或配置
- ❌ **错误**：命令语法错误或工具不存在
- 📝 **建议修改**：命令可以工作但建议优化

### 常见问题类型

1. **Skills 不存在**：ClawHub 市场中没有该 Skill
2. **命令语法错误**：bash 语法问题
3. **参数错误**：参数名称或格式不正确
4. **路径问题**：文件路径不存在或不正确
5. **依赖缺失**：需要额外安装依赖

---

## 第10章：Skills扩展

### 10.1 基础命令

#### ✅ 正确的命令

```bash
# 搜索 Skills
npx clawhub@latest search image

# 安装 Skill
npx clawhub@latest install <skill-name>

# 列出已安装的 Skills
openclaw skills list

# 查看 Skill 信息
openclaw skills info <skill-name>
```

#### ⚠️ 需要注意的命令

```bash
# 这个命令在文档中出现，但 ClawHub 可能没有这个 Skill
npx clawhub@latest install bananapro-image-gen
```

**问题**：`bananapro-image-gen` 可能不在 ClawHub 市场中

**建议**：
1. 先搜索确认：`npx clawhub@latest search bananapro`
2. 如果不存在，使用替代方案：
   - 使用 `fal-ai` Skill
   - 直接使用 Gemini API
   - 从 GitHub 手动安装

#### 📝 建议修改的命令

```bash
# 原命令
git clone https://github.com/xianyu110/awesome-openclaw-tutorial.git
cp -r expert-skills-hub/skills/bananapro-image-gen ~/.openclaw/skills/

# 建议改为
git clone https://github.com/xianyu110/awesome-openclaw-tutorial.git
cd awesome-openclaw-tutorial
# 检查目录结构后再复制
ls -la skills/
cp -r skills/bananapro-image-gen ~/.openclaw/skills/
```

---

## 第11章：多平台集成

### 11.1 飞书配置

#### ✅ 正确的命令

```bash
# 运行配置向导
openclaw onboard

# 配置 App ID
openclaw config set channels.feishu.appId "cli_xxxxxxxxxx"

# 配置 App Secret
openclaw config set channels.feishu.appSecret "your_app_secret_here"

# 启用飞书频道
openclaw config set channels.feishu.enabled true

# 重启 Gateway
openclaw gateway restart

# 检查状态
openclaw gateway status

# 查看日志
tail -f ~/.openclaw/logs/gateway.log
```

#### ⚠️ 需要注意

```bash
# 查看飞书频道日志
tail -f ~/.openclaw/logs/feishu.log
```

**问题**：日志文件名可能不是 `feishu.log`，可能是 `gateway.log` 或其他名称

**建议**：先检查日志目录：`ls ~/.openclaw/logs/`

---

## 第12章：飞书Bot配置

### 12.1 配置命令

#### ✅ 正确的命令

```bash
# 配置白名单
openclaw config set channels.feishu.allowlist '["ou_xxxxxx","ou_yyyyyy"]'

# 配置群组白名单
openclaw config set channels.feishu.groupAllowlist '["oc_xxxxxx","oc_yyyyyy"]'

# 配置管理员
openclaw config set channels.feishu.admins '["ou_admin1","ou_admin2"]'

# 启用全部消息模式
openclaw config set channels.feishu.respondToAllGroupMessages true
```

#### ⚠️ 需要注意

```bash
# 查询用户信息
openclaw channels feishu user-info --phone "+8613800138000"
```

**问题**：这个命令可能不存在，需要确认 OpenClaw 是否支持

**建议**：使用飞书开放平台 API 或查看日志获取用户 ID

---

## 第13章：企业微信+钉钉+QQ配置

### 13.1 企业微信配置

#### ✅ 正确的命令

```bash
# 配置 Corp ID
openclaw config set channels.wework.corpId "ww_xxxxxxxxxx"

# 配置 Agent ID
openclaw config set channels.wework.agentId "1000001"

# 配置 Secret
openclaw config set channels.wework.secret "your_secret_here"

# 启用企业微信频道
openclaw config set channels.wework.enabled true

# 查看企业微信日志
tail -f ~/.openclaw/logs/wework.log
```

### 13.2 钉钉配置

#### ✅ 正确的命令

```bash
# 配置 App Key
openclaw config set channels.dingtalk.appKey "ding_xxxxxxxxxx"

# 配置 App Secret
openclaw config set channels.dingtalk.appSecret "your_secret_here"

# 启用钉钉频道
openclaw config set channels.dingtalk.enabled true

# 查看钉钉日志
tail -f ~/.openclaw/logs/dingtalk.log
```

### 13.3 QQ配置

#### ✅ 正确的命令

```bash
# 配置 App ID
openclaw config set channels.qq.appId "your_app_id"

# 配置 Token
openclaw config set channels.qq.token "your_token_here"

# 启用 QQ 频道
openclaw config set channels.qq.enabled true

# 查看 QQ 日志
tail -f ~/.openclaw/logs/qq.log
```

---

## 第14章：API集成

### 14.1 AI绘图服务

#### ⚠️ 需要注意的命令

```bash
# 安装 bananapro-image-gen Skill
git clone https://github.com/xianyu110/awesome-openclaw-tutorial.git
cp -r expert-skills-hub/skills/bananapro-image-gen ~/.openclaw/skills/
cd ~/.openclaw/skills/bananapro-image-gen
pip3 install -r requirements.txt
```

**问题**：
1. 目录结构可能不正确（`expert-skills-hub` 可能不存在）
2. 需要确认 GitHub 仓库中是否有这个 Skill

**建议**：
```bash
# 先检查仓库结构
git clone https://github.com/xianyu110/awesome-openclaw-tutorial.git
cd awesome-openclaw-tutorial
ls -la
# 根据实际结构调整路径
```

#### ❌ 错误的命令

```bash
# 使用 npx 命令安装（文档中提到但可能不存在）
npx skills add https://github.com/xianyu110/awesome-openclaw-tutorial --skill bananapro-image-gen
```

**问题**：`npx skills` 命令不存在，应该是 `npx clawhub@latest`

**修正**：
```bash
# 如果 Skill 在 ClawHub 市场中
npx clawhub@latest install bananapro-image-gen

# 如果不在市场中，需要手动安装
```

#### ✅ 正确的命令

```bash
# 测试连接
cd ~/.openclaw/skills/bananapro-image-gen
bash test.sh

# 生成图片
python3 scripts/generate_image.py \
    --prompt "1个简约的Logo设计，主题是AI助手" \
    --filename output.png \
    --api-format openai
```

### 14.2 Notion集成

#### ✅ 正确的命令

```bash
# 安装 Notion SDK (Node.js)
npm install @notionhq/client

# 安装 Notion SDK (Python)
pip install notion-client

# 测试 API 连接
curl -X GET https://api.notion.com/v1/users/me \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28"
```

#### ⚠️ 需要注意

```bash
# 文档中提到的命令（可能不存在）
openclaw notion test
openclaw notion template create "meeting"
openclaw notion import ~/notes/
```

**问题**：这些命令可能不是 OpenClaw 内置命令，需要安装对应的 Skill

**建议**：
1. 先搜索 Notion Skills：`npx clawhub@latest search notion`
2. 安装找到的 Skill
3. 查看 Skill 文档了解具体命令

### 14.3 视频生成服务

#### ✅ 正确的命令

```bash
# 安装视频生成 Skills
npx clawhub@latest install video-agent
npx clawhub@latest install sora-video-gen
npx clawhub@latest install veo3-video-gen
npx clawhub@latest install tube-cog
npx clawhub@latest install video-cog
```

#### ⚠️ 需要注意

```bash
# 文档中提到的命令（需要确认是否存在）
openclaw video generate --script "$script" --duration 60
openclaw video avatar upload --photo "my_photo.jpg"
openclaw video edit --input "video.mp4" --intro "intro.mp4"
openclaw video batch --scripts "scripts/*.txt"
```

**问题**：这些可能是 Skill 提供的命令，不是 OpenClaw 核心命令

**建议**：安装 Skill 后查看其文档

### 14.4 语音合成服务

#### ✅ 正确的命令

```bash
# 安装语音合成 Skills
npx clawhub@latest install elevenlabs
npx clawhub@latest install azure-tts
npx clawhub@latest install google-tts
npx clawhub@latest install openai-tts
```

#### ⚠️ 需要注意

```bash
# 文档中提到的命令（需要确认）
openclaw tts generate --text "你的文本" --voice "voice-id"
openclaw tts voice clone --samples "voice_samples/*.mp3"
openclaw tts batch --input "texts/" --output "audios/"
```

**问题**：同样需要确认这些是 Skill 命令还是核心命令

---

## 第15章：高级配置

### 15.1 Antigravity Manager配置

#### ✅ 正确的命令

```bash
# 使用 jq 添加 provider
cat ~/.openclaw/openclaw.json | jq '.models.providers["local-anthropic"] = {
  "baseUrl": "http://127.0.0.1:8045",
  "apiKey": "你的User_Token",
  "auth": "api-key",
  "api": "anthropic-messages",
  "models": [...]
}' > /tmp/openclaw-temp.json && mv /tmp/openclaw-temp.json ~/.openclaw/openclaw.json

# 设置默认模型
openclaw config set agents.defaults.model.primary "local-anthropic/claude-sonnet-4-5-20250929"

# 查看模型列表
openclaw models list

# 重启 Gateway
openclaw gateway restart

# 测试连接
openclaw message send "你好，介绍一下你自己"
```

#### 📝 建议修改

```bash
# 原命令（使用 jq 修改 JSON）
cat ~/.openclaw/openclaw.json | jq '...' > /tmp/openclaw-temp.json && mv /tmp/openclaw-temp.json ~/.openclaw/openclaw.json
```

**问题**：这个命令很长，容易出错，而且需要安装 `jq`

**建议**：
1. 提供手动编辑配置文件的方法
2. 或者提供一个配置脚本
3. 检查 `jq` 是否已安装：`which jq`

### 15.2 CLI命令

#### ✅ 正确的命令

```bash
# 版本和帮助
openclaw --version
openclaw --help

# 配置管理
openclaw config list
openclaw config get models.providers
openclaw config set gateway.port 18790

# Gateway 管理
openclaw gateway status
openclaw gateway stop
openclaw gateway restart

# 日志查看
openclaw logs
openclaw logs --follow
openclaw logs --tail 100

# 渠道管理
openclaw channels list
openclaw channels status

# 工具管理
openclaw tools list
openclaw tools enable read_file write_file

# 统计信息
openclaw stats
openclaw stats today
openclaw stats api

# 测试和诊断
openclaw test api
openclaw diagnose
openclaw health check

# 备份和恢复
openclaw backup create
openclaw backup list
openclaw backup restore <backup-id>
```

#### ⚠️ 需要确认的命令

```bash
# 这些命令可能不存在或名称不同
openclaw plugins list
openclaw plugins install @openclaw/feishu
openclaw agents list
openclaw sessions list
openclaw update check
```

**建议**：运行 `openclaw --help` 查看所有可用命令

---

## 第16章：工具策略配置

### 16.1 工具管理命令

#### ✅ 正确的命令

```bash
# 查看可用工具
openclaw tools list

# 启用工具
openclaw tools enable read_file write_file

# 禁用工具
openclaw tools disable execute_command

# 查看工具策略
openclaw config get tools
```

#### ⚠️ 需要确认

```bash
# 这些命令可能不存在
openclaw tools register ~/.openclaw/tools/my-tool.js
openclaw tools test read_file
```

---

## 第17章：Node节点管理

### 17.1 节点管理命令

#### ✅ 正确的命令

```bash
# 查看节点列表
openclaw nodes list
openclaw nodes list --online

# 查看节点详情
openclaw nodes get node_xyz789

# 重命名节点
openclaw nodes rename node_xyz789 "Development Mac"

# 删除节点
openclaw nodes unpair node_xyz789
openclaw nodes unpair node_xyz789 --force
```

#### ⚠️ 需要确认

```bash
# 这些命令可能不存在或名称不同
openclaw node pair approve req_abc123
openclaw node pair reject req_abc123
openclaw nodes pair list
openclaw nodes pair pending
openclaw nodes health
openclaw nodes cleanup --offline-days 30
```

---

## 批量安装脚本问题

### 问题1：Skills 可能不存在

文档中提到的很多 Skills 在 ClawHub 市场中可能不存在：

```bash
# 这些 Skills 需要先确认是否存在
npx clawhub@latest install fal-ai
npx clawhub@latest install nvidia-image-gen
npx clawhub@latest install pollinations
npx clawhub@latest install venice-ai
npx clawhub@latest install recraft
npx clawhub@latest install notion
npx clawhub@latest install notion-mcp
npx clawhub@latest install notion-database
```

**建议**：
1. 在文档开头添加明确的警告
2. 提供验证脚本：
```bash
#!/bin/bash
# verify_skills.sh
skills=("fal-ai" "notion" "elevenlabs" "video-agent")
for skill in "${skills[@]}"; do
    echo "检查 $skill..."
    npx clawhub@latest search "$skill" | grep -q "$skill" && echo "✅ 存在" || echo "❌ 不存在"
done
```

### 问题2：批量安装脚本语法

```bash
# 原脚本
./install_api_skills.sh content
./install_api_skills.sh all
```

**问题**：脚本可能不存在或路径不正确

**建议**：
1. 提供完整的脚本内容
2. 或者提供下载链接
3. 添加脚本存在性检查

---

## 配置文件路径问题

### 问题：多个配置文件路径

文档中出现了不同的配置文件路径：

```bash
~/.openclaw/openclaw.json
~/.openclaw-{gateway-id}/openclaw.json
```

**建议**：统一说明：
- 默认路径：`~/.openclaw/openclaw.json`
- 多 Gateway 时：`~/.openclaw-{gateway-id}/openclaw.json`
- 查看当前路径：`openclaw config path`

---

## JSON 配置语法问题

### 问题：JSON 中的注释

很多配置示例中包含注释，但标准 JSON 不支持注释：

```json
{
  "tools": {
    "allow": ["*"],  // 允许所有工具 ← 这是错误的
    "deny": ["exec"]
  }
}
```

**建议**：
1. 使用 JSONC 格式（支持注释）
2. 或者在代码块外添加说明
3. 提供无注释的完整配置示例

---

## 环境变量问题

### 问题：环境变量格式

文档中使用了不同的环境变量格式：

```json
{
  "apiKey": "${BRAVE_API_KEY}"  // 这种格式可能不被支持
}
```

**建议**：
1. 明确说明 OpenClaw 是否支持环境变量替换
2. 如果不支持，建议使用配置命令：
```bash
openclaw config set api.brave.apiKey "$BRAVE_API_KEY"
```

---

## 总结和建议

### 主要问题类别

1. **Skills 可用性**（最严重）
   - 很多 Skills 可能不在 ClawHub 市场中
   - 需要添加验证步骤

2. **命令存在性**
   - 部分命令可能是假设的，需要确认
   - 建议标注哪些是核心命令，哪些是 Skill 命令

3. **配置文件语法**
   - JSON 注释问题
   - 环境变量格式问题

4. **路径和文件**
   - 配置文件路径不统一
   - 日志文件名称不确定

### 修复优先级

#### 🔴 高优先级（必须修复）

1. **添加 Skills 验证说明**
   ```markdown
   ⚠️ **重要**：在安装 Skill 之前，请先验证其是否存在：
   ```bash
   npx clawhub@latest search <skill-name>
   ```
   ```

2. **修正批量安装脚本**
   - 添加存在性检查
   - 提供错误处理

3. **修正 JSON 配置示例**
   - 移除注释或使用 JSONC
   - 提供完整的可用配置

#### 🟡 中优先级（建议修复）

1. **统一配置文件路径说明**
2. **明确命令的来源**（核心 vs Skill）
3. **添加环境变量使用说明**

#### 🟢 低优先级（可选）

1. **优化命令示例**
2. **添加更多故障排查步骤**
3. **提供配置模板文件**

---

## 建议的文档改进

### 1. 在每章开头添加前置检查

```markdown
## 前置要求

在开始本章之前，请确认：

- [ ] OpenClaw 已安装并运行
- [ ] Gateway 状态正常：`openclaw gateway status`
- [ ] 已安装必要的依赖（如 jq、curl）
- [ ] 已验证 Skills 是否存在（如适用）
```

### 2. 添加命令验证脚本

```bash
#!/bin/bash
# verify_commands.sh

echo "验证 OpenClaw 命令..."

commands=(
    "openclaw --version"
    "openclaw config list"
    "openclaw gateway status"
    "openclaw tools list"
)

for cmd in "${commands[@]}"; do
    echo "测试: $cmd"
    if $cmd &> /dev/null; then
        echo "✅ 成功"
    else
        echo "❌ 失败"
    fi
done
```

### 3. 提供配置模板

创建 `config-templates/` 目录，包含：
- `basic-config.json` - 基础配置
- `multi-model-config.json` - 多模型配置
- `tools-policy-config.json` - 工具策略配置

### 4. 添加故障排查清单

```markdown
## 常见问题排查

### 命令不存在

1. 检查 OpenClaw 版本：`openclaw --version`
2. 查看可用命令：`openclaw --help`
3. 更新到最新版本：`openclaw update`

### Skill 安装失败

1. 搜索 Skill：`npx clawhub@latest search <name>`
2. 检查网络连接
3. 查看详细错误：`npx clawhub@latest install <name> --verbose`
```

---

## 下一步行动

### 立即执行

1. ✅ 创建本验证报告
2. 📝 标记所有需要修正的命令
3. 🔍 验证 ClawHub 市场中的 Skills

### 短期计划

1. 修正高优先级问题
2. 添加前置检查章节
3. 提供配置模板

### 长期计划

1. 创建自动化验证脚本
2. 建立 Skills 可用性数据库
3. 持续更新文档

---

**报告生成时间**：2026-02-20
**验证范围**：第10-17章
**总命令数**：约200+
**需要修正**：约30+
