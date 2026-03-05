# 第9.1章：飞书Bot配置

> 💡 **推荐指数**：⭐⭐⭐⭐⭐ 飞书是国内最推荐的IM平台，功能完整、开发友好。

> 💡 **状态**：生产就绪，支持机器人私聊和群组，使用 WebSocket 长连接模式接收消息。

![飞书Bot示意图](https://upload.maynor1024.live/file/1770742223389_04-test-chat.png)

---

## 📋 本章导航

- [9.1.1 飞书机器人介绍](#911-飞书机器人介绍)
- [9.1.2 快速开始](#912-快速开始)
- [9.1.3 创建飞书应用](#913-创建飞书应用)
- [9.1.4 配置OpenClaw](#914-配置openclaw)
- [9.1.5 启动并测试](#915-启动并测试)
- [9.1.6 访问控制](#916-访问控制)
- [9.1.7 群组配置](#917-群组配置)
- [9.1.8 获取群组/用户ID](#918-获取群组用户id)
- [9.1.9 高级配置](#919-高级配置)
- [9.1.10 多账号配置](#9110-多账号配置)
- [9.1.11 多Agent配置](#9111-多agent配置)
- [9.1.12 常见问题](#9112-常见问题)

**其他章节**：
- [← 返回多平台集成概述](11-multi-platform-integration.md)
- [→ 查看企微+钉钉+QQ配置](13-wework-dingtalk-qq.md)

---

## 飞书机器人介绍

### 为什么选择飞书？

飞书（Lark/Feishu）是字节跳动推出的企业协作平台，具有以下优势：

**技术优势**：
- ✅ **流式输出**：支持实时流式响应，体验最好
- ✅ **富文本支持**：支持Markdown、卡片消息
- ✅ **API完善**：开发文档清晰，接口稳定
- ✅ **WebSocket长连接**：消息实时推送

**功能优势**：
- ✅ **多Agent支持**：可配置多个专业助手
- ✅ **群组功能**：支持群聊、@提及
- ✅ **文件传输**：支持文件上传下载
- ✅ **访问控制**：支持白名单、权限管理

**使用优势**：
- ✅ **免费使用**：基础功能完全免费
- ✅ **跨平台**：支持Windows、Mac、iOS、Android、Web
- ✅ **现代化设计**：界面简洁，用户体验好
- ✅ **企业级**：适合个人和团队使用

### 适用场景

- 📱 **个人效率提升**：随时随地使用AI助手
- 👥 **团队协作**：多人共享AI助手
- 📊 **项目管理**：任务跟踪、进度汇报
- 📚 **知识管理**：文档整理、信息检索
- 🤖 **工作自动化**：定时任务、流程自动化

---

## 快速开始

### 前置要求

1. **飞书账号**
   - 注册飞书账号（个人或企业）
   - 下载飞书客户端

2. **OpenClaw环境**
   - 已安装OpenClaw
   - Gateway正常运行

3. **开发者权限**
   - 有权限创建飞书应用
   - 有权限配置机器人

### 配置流程概览

```
1. 创建飞书应用
   ↓
2. 获取App ID和App Secret
   ↓
3. 配置OpenClaw
   ↓
4. 启动并测试
   ↓
5. 配置访问控制（可选）
```

**预计时间**：15-30分钟

---

## 创建飞书应用

### 步骤1：访问飞书开放平台

1. 打开浏览器，访问：https://open.feishu.cn/
2. 使用飞书账号登录
3. 进入"开发者后台"

### 步骤2：创建企业自建应用

1. 点击"创建企业自建应用"
2. 填写应用信息：
   - **应用名称**：OpenClaw Bot（或自定义）
   - **应用描述**：AI助手机器人
   - **应用图标**：上传图标（可选）

3. 点击"创建"

### 步骤3：获取凭证信息

创建成功后，进入应用详情页：

1. 点击"凭证与基础信息"
2. 记录以下信息：
   - **App ID**：格式为 `cli_xxxxxxxxxx`
   - **App Secret**：点击"查看"获取

⚠️ **重要**：App Secret只显示一次，务必妥善保存！

### 步骤4：配置应用权限

1. 点击"权限管理"
2. 搜索并开通以下权限：

**必需权限**：
- `im:message` - 获取与发送单聊、群组消息
- `im:message.group_at_msg` - 获取群组中所有消息
- `im:message.group_at_msg:readonly` - 接收群聊中@机器人消息事件
- `im:message.p2p_msg` - 获取用户发给机器人的单聊消息
- `im:message.p2p_msg:readonly` - 接收用户发给机器人的单聊消息事件
- `im:message:send_as_bot` - 以应用的身份发消息

**可选权限**（推荐开通）：
- `im:chat` - 获取群组信息
- `im:chat:readonly` - 获取群组信息（只读）
- `contact:user.id:readonly` - 获取用户 user ID

3. 点击"发布版本"
   - 选择"全员可用"
   - 提交审核（通常几分钟内通过）

### 步骤5：配置事件订阅

1. 点击"事件订阅"
2. 点击"添加事件"
3. 搜索并添加以下事件：

**必需事件**：
- `im.message.receive_v1` - 接收消息

4. 配置请求地址（暂时跳过，OpenClaw会自动处理）

---

## 配置OpenClaw

### 方式一：使用配置向导（推荐）

```bash
# 运行配置向导
openclaw onboard

# 按照提示操作：
# 1. 选择 "Configure Channels"
# 2. 选择 "Feishu"
# 3. 输入 App ID
# 4. 输入 App Secret
# 5. 完成配置
```

### 方式二：手动配置

编辑配置文件 `~/.openclaw/openclaw.json`：

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "cli_xxxxxxxxxx",
      "appSecret": "your_app_secret_here",
      "verificationToken": "auto_generated",
      "encryptKey": "auto_generated"
    }
  }
}
```

### 方式三：使用命令行

```bash
# 配置App ID
openclaw config set channels.feishu.appId "cli_xxxxxxxxxx"

# 配置App Secret
openclaw config set channels.feishu.appSecret "your_app_secret_here"

# 启用飞书频道
openclaw config set channels.feishu.enabled true
```

---

## 启动并测试

### 步骤1：重启Gateway

```bash
# 重启Gateway以应用配置
openclaw gateway restart

# 等待几秒后检查状态
sleep 5
openclaw gateway status
```

成功的输出应该显示：
```
Runtime: running (pid xxxxx, state active)
RPC probe: ok
Listening: *:18789
Dashboard: http://127.0.0.1:18789/
```

### 步骤2：在飞书中找到机器人

1. 打开飞书客户端
2. 点击"工作台"
3. 找到你创建的应用（OpenClaw Bot）
4. 点击进入

### 步骤3：发送测试消息

在对话框中发送：

```
你好，能听到我说话吗？
```

### 步骤4：验证回复

如果配置成功，机器人会回复类似：

```
你好！我是OpenClaw AI助手，很高兴为你服务。
我可以帮你：
- 回答问题
- 处理任务
- 搜索信息
- 执行命令

有什么我可以帮你的吗？
```

### 步骤5：查看日志（如果有问题）

```bash
# 查看Gateway日志
tail -f ~/.openclaw/logs/gateway.log

# 查看飞书频道日志
tail -f ~/.openclaw/logs/feishu.log
```

---

## 访问控制

### 为什么需要访问控制？

- 🔒 **安全性**：防止未授权访问
- 💰 **成本控制**：避免API滥用
- 👥 **用户管理**：只允许特定用户使用

### 配置白名单

#### 方式一：配置用户白名单

```bash
# 添加允许的用户ID
openclaw config set channels.feishu.allowlist '["ou_xxxxxx","ou_yyyyyy"]'
```

#### 方式二：配置群组白名单

```bash
# 添加允许的群组ID
openclaw config set channels.feishu.groupAllowlist '["oc_xxxxxx","oc_yyyyyy"]'
```

#### 方式三：编辑配置文件

编辑 `~/.openclaw/openclaw.json`：

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "cli_xxxxxxxxxx",
      "appSecret": "your_app_secret_here",
      "allowlist": [
        "ou_user1",
        "ou_user2"
      ],
      "groupAllowlist": [
        "oc_group1",
        "oc_group2"
      ]
    }
  }
}
```

### 配置管理员

```bash
# 添加管理员用户
openclaw config set channels.feishu.admins '["ou_admin1","ou_admin2"]'
```

管理员拥有特殊权限：
- 可以执行管理命令
- 可以查看系统状态
- 可以管理其他用户

---

## 群组配置

### 将机器人添加到群组

1. **创建群组**（如果还没有）
   - 在飞书中创建新群组
   - 添加需要使用机器人的成员

2. **添加机器人到群组**
   - 打开群组
   - 点击右上角"..."
   - 选择"添加机器人"
   - 搜索并添加你的机器人

3. **测试群组功能**
   - 在群组中@机器人
   - 发送消息：`@OpenClaw Bot 你好`
   - 验证机器人回复

### 群组消息模式

OpenClaw支持两种群组消息模式：

#### 模式1：@提及模式（默认）

只有@机器人时才会响应：

```
@OpenClaw Bot 今天天气怎么样？
```

#### 模式2：全部消息模式

响应群组中的所有消息（需要配置）：

```bash
# 启用全部消息模式
openclaw config set channels.feishu.respondToAllGroupMessages true
```

⚠️ **注意**：全部消息模式会消耗更多API调用，建议谨慎使用。

---

## 获取群组/用户ID

### 获取用户ID

#### 方法1：通过日志查看

```bash
# 查看日志
tail -f ~/.openclaw/logs/gateway.log

# 发送消息后，日志会显示：
# Received message from user: ou_xxxxxx
```

#### 方法2：使用命令查询

```bash
# 查询用户信息
openclaw channels feishu user-info --phone "+8613800138000"
```

### 获取群组ID

#### 方法1：通过日志查看

```bash
# 查看日志
tail -f ~/.openclaw/logs/gateway.log

# 在群组中发送消息后，日志会显示：
# Received message from group: oc_xxxxxx
```

#### 方法2：使用飞书开放平台

1. 登录飞书开放平台
2. 进入"开发者后台"
3. 选择你的应用
4. 点击"机器人"
5. 查看"群组列表"

---

## 高级配置

### 配置消息格式

```json
{
  "channels": {
    "feishu": {
      "messageFormat": "markdown",
      "enableRichText": true,
      "enableCard": true
    }
  }
}
```

### 配置超时时间

```json
{
  "channels": {
    "feishu": {
      "timeout": 30000,
      "retryAttempts": 3
    }
  }
}
```

### 配置代理

```json
{
  "channels": {
    "feishu": {
      "proxy": {
        "enabled": true,
        "host": "127.0.0.1",
        "port": 7890
      }
    }
  }
}
```

---

## 多账号配置

OpenClaw支持同时配置多个飞书机器人。

### 配置示例

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "accounts": [
        {
          "id": "bot1",
          "appId": "cli_xxxxxxxxxx",
          "appSecret": "secret1",
          "allowlist": ["ou_user1"]
        },
        {
          "id": "bot2",
          "appId": "cli_yyyyyyyyyy",
          "appSecret": "secret2",
          "allowlist": ["ou_user2"]
        }
      ]
    }
  }
}
```

### 使用场景

- 🏢 **部门隔离**：不同部门使用不同机器人
- 🎯 **功能分离**：工作机器人 vs 生活机器人
- 👥 **用户分组**：VIP用户 vs 普通用户

---

## 多Agent配置

> ⭐ **新功能**：支持配置多个专业Agent，每个Agent有不同的专长。

### 什么是多Agent？

多Agent允许你配置多个AI助手，每个助手有不同的：
- 专业领域（编程、写作、翻译等）
- 模型配置（GPT-4、Claude、Kimi等）
- 系统提示词
- 工具和Skills

### 配置示例

详细的多Agent配置教程请参考：
- [附录：多Agent配置指南](../../appendix/multi-agent-guide.md)
- [实战案例：4个专业助手](../../appendix/multi-agent-examples.md)

### 快速开始

```bash
# 创建新Agent
openclaw agent create --name "编程助手" --model "gpt-4"

# 配置Agent
openclaw agent config --name "编程助手" --system-prompt "你是一个专业的编程助手"

# 在飞书中使用
# 发送消息：@编程助手 帮我写一个Python函数
```

---

## 常见问题

### Q1: 机器人无法收到消息

**可能原因**：
1. Gateway未运行
2. 权限未开通
3. 事件订阅未配置

**解决方案**：
```bash
# 检查Gateway状态
openclaw gateway status

# 查看日志
tail -f ~/.openclaw/logs/gateway.log

# 重启Gateway
openclaw gateway restart
```

### Q2: 机器人回复很慢

**可能原因**：
1. 网络延迟
2. API响应慢
3. 模型选择不当

**解决方案**：
- 使用国内模型（Kimi、DeepSeek）
- 优化网络连接
- 调整超时时间

### Q3: 群组中无法@机器人

**可能原因**：
1. 机器人未添加到群组
2. 权限不足
3. 群组未在白名单中

**解决方案**：
- 确认机器人已添加到群组
- 检查权限配置
- 将群组ID添加到白名单

### Q4: 如何查看API消耗？

```bash
# 查看API统计
openclaw stats api

# 查看详细日志
tail -f ~/.openclaw/logs/gateway.log | grep "API"
```

### Q5: 如何备份配置？

```bash
# 备份配置文件
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 备份整个配置目录
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz ~/.openclaw
```

---

## 本章小结

本章介绍了飞书Bot的完整配置流程：

1. **创建飞书应用**：在飞书开放平台创建企业自建应用
2. **配置OpenClaw**：通过向导或手动配置App ID和Secret
3. **启动并测试**：验证机器人功能
4. **访问控制**：配置白名单和权限
5. **群组配置**：将机器人添加到群组
6. **高级功能**：多账号、多Agent配置

飞书是OpenClaw最推荐的IM平台，功能完整、开发友好，适合个人和团队使用。

---

## 下一步

- [← 返回多平台集成概述](11-multi-platform-integration.md)
- [→ 查看企微+钉钉+QQ配置](13-wework-dingtalk-qq.md)
- [→ 查看API集成](14-api-integration.md)

---

**相关资源**：
- [飞书开放平台文档](https://open.feishu.cn/document/)
- [OpenClaw官方文档](https://docs.openclaw.ai/)
- [附录：飞书配置检查清单](../../appendix/J-feishu-checklist.md)
