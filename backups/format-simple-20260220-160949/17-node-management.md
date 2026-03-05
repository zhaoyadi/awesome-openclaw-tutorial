# OpenClaw Node 节点完全指南

## 目录

1. [什么是 Node 节点](#什么是-node-节点)
2. [Node 节点架构](#node-节点架构)
3. [Node 节点类型](#node-节点类型)
4. [节点配对流程](#节点配对流程)
5. [节点管理](#节点管理)
6. [节点命令系统](#节点命令系统)
7. [远程执行](#远程执行)
8. [浏览器代理](#浏览器代理)
9. [节点权限管理](#节点权限管理)
10. [实战场景](#实战场景)
11. [故障排查](#故障排查)
12. [最佳实践](#最佳实践)

---

## 什么是 Node 节点

### 概述

OpenClaw Node（节点）是一个**分布式计算单元**，允许你将 AI Agent 的工具执行能力扩展到多台设备上。通过 Node 系统，你可以：

- 🖥️ **远程执行命令**：在其他设备上运行命令和脚本
- 🌐 **浏览器代理**：通过远程设备访问网页（绕过地域限制）
- 📱 **移动设备集成**：将手机、平板作为执行节点
- 🔧 **资源分配**：将计算密集型任务分配到专用机器
- 🏢 **企业部署**：构建多节点 AI 基础设施

### 核心概念

```
┌─────────────┐
│   Gateway   │ ← 中央控制节点
└──────┬──────┘
       │
       ├─────────┐
       │         │
   ┌───▼───┐ ┌──▼────┐
   │ Node1 │ │ Node2 │ ← 执行节点
   └───────┘ └───────┘
   (Mac)     (Linux)
```

- **Gateway**：中央控制节点，负责协调和分发任务
- **Node**：执行节点，接收并执行来自 Gateway 的命令
- **WebSocket 连接**：Gateway 和 Node 之间通过 WebSocket 保持长连接
- **命令调用**：Gateway 通过 RPC 机制调用 Node 上的命令

---

## Node 节点架构

### 连接流程

```
┌──────────┐                    ┌──────────┐
│   Node   │                    │ Gateway  │
└────┬─────┘                    └────┬─────┘
     │                               │
     │  1. WebSocket Connect         │
     ├──────────────────────────────>│
     │                               │
     │  2. Device Identity           │
     ├──────────────────────────────>│
     │                               │
     │  3. Pairing Request (if new)  │
     │<──────────────────────────────┤
     │                               │
     │  4. Pairing Approval          │
     ├──────────────────────────────>│
     │                               │
     │  5. Node Registration         │
     │<──────────────────────────────┤
     │                               │
     │  6. Ready for Commands        │
     │<─────────────────────────────>│
     └───────────────────────────────┘
```

### Node Session 数据结构

每个连接的 Node 都会创建一个 Session，包含以下信息：

```typescript
{
  nodeId: string,              // 节点唯一标识
  connId: string,              // 连接 ID
  displayName: string,         // 显示名称
  platform: string,            // 平台（darwin、linux、win32、ios、android）
  version: string,             // OpenClaw 版本
  coreVersion: string,         // 核心版本
  uiVersion: string,           // UI 版本
  deviceFamily: string,        // 设备系列（iPhone、iPad、Mac）
  modelIdentifier: string,     // 设备型号
  remoteIp: string,            // 远程 IP 地址
  caps: string[],              // 能力列表
  commands: string[],          // 支持的命令列表
  permissions: object,         // 权限配置
  pathEnv: string,             // PATH 环境变量
  connectedAtMs: number        // 连接时间戳
}
```

---

## Node 节点类型

### 1. 桌面节点（Desktop Node）

**平台**：macOS、Linux、Windows

**用途**：

- 执行系统命令
- 文件操作
- 开发工具集成
- 浏览器自动化

**配置示例**：

```json
{
  "nodes": {
    "desktop-mac": {
      "displayName": "MacBook Pro",
      "platform": "darwin",
      "caps": ["exec", "browser", "file"],
      "commands": ["system.execApprovals.get", "system.execApprovals.set", "browser.proxy"]
    }
  }
}
```

### 2. 移动节点（Mobile Node）

**平台**：iOS、Android

**用途**：

- 移动端浏览器访问
- 移动网络代理
- 设备特定功能（相机、传感器）
- 移动应用自动化

**特点**：

- 自动识别为移动平台
- 支持移动网络环境
- 可用于绕过桌面端限制

**检测代码**：

```typescript
const isMobilePlatform = (platform: string): boolean => {
  return platform === "ios" || platform === "android";
};
```

### 3. 服务器节点（Server Node）

**平台**：Linux Server、Docker

**用途**：

- 后台任务执行
- 定时任务
- 数据处理
- API 服务

**配置示例**：

```json
{
  "nodes": {
    "server-prod": {
      "displayName": "
com
```

#### 2. Gateway 收到请求

Gateway 广播配对请求事件：

```json
{
  "event": "node.pair.requested",
  "payload": {
    "requestId": "req_abc123",
    "nodeId": "node_xyz789",
    "displayName": "MacBook Pro",
    "platform": "darwin",
    "publicKey": "..."
  }
}
```

#### 3. 用户批准

通过 Control UI 或命令行批准：

```bash
# 命令行批准
openclaw node pair approve req_abc123

# 或拒绝
openclaw node pair reject req_abc123
```

#### 4. 配对完成

Gateway 返回配对结果：

```json
{
  "event": "node.pair.resolved",
  "payload": {
    "requestId": "req_abc123",
    "approved": true,
    "device": {
      "deviceId": "node_xyz789",
      "displayName": "MacBook Pro",
      "token": "..."
    }
  }
}
```

### 配对数据存储

配对信息存储在 `~/.openclaw-{gateway-id}/pairing/` 目录：

```
~/.openclaw-{gateway-id}/
├── pairing/
│   ├── nodes.json          # 已配对的节点列表
│   ├── pending.json        # 待批准的配对请求
│   └── tokens/             # 节点认证 Token
│       └── node_xyz789.json
```

---

## 节点管理

### 查看节点列表

```bash
# 查看所有节点（已配对 + 在线）
openclaw nodes list

# 只查看在线节点
openclaw nodes list --online

# 查看节点详情
openclaw nodes get node_xyz789
```

**输出示例**：

```
┌─────────────┬──────────────┬──────────┬─────────┬────────────┐
│ Node ID     │ Display Name │ Platform │ Status  │ Connected  │
├─────────────┼──────────────┼──────────┼─────────┼────────────┤
│ node_xyz789 │ MacBook Pro  │ darwin   │ online  │ 2h ago     │
│ node_abc123 │ Linux Server │ linux    │ offline │ 1d ago     │
│ node_def456 │ iPhone 15    │ ios      │ online  │ 5m ago     │
└─────────────┴──────────────┴──────────┴─────────┴────────────┘
```

### 重命名节点

```bash
openclaw nodes rename node_xyz789 "Development Mac"
```

### 删除节点

```bash
# 删除配对
openclaw nodes unpair node_xyz789

# 强制删除（即使在线）
openclaw nodes unpair node_xyz789 --force
```

### 节点元数据更新

系统自动更新节点元数据：

```typescript
await updatePairedNodeMetadata(nodeId, {
  lastConnectedAtMs: Date.now(),
  displayName: "Updated Name",
  platform: "darwin",
  version: "1.2.3",
});
```

---

## 节点命令系统

### 命令注册

Node 启动时注册支持的命令：

```typescript
const commands = [
  "system.execApprovals.get",
  "system.execApprovals.set",
  "browser.proxy",
  "file.read",
  "file.write",
];
```

### 命令调用

Gateway 通过 RPC 调用 Node 命令：

```typescript
const result = await nodeRegistry.invoke({
  nodeId: "node_xyz789",
  command: "browser.proxy",
  params: {
    url: "https://example.com",
    method: "GET",
  },
  timeoutMs: 30000,
});
```

### 命令响应

```typescript
{
  ok: true,
  payload: {
    statusCode: 200,
    body: "...",
    headers: {...}
  }
}
```

### 命令超时处理

```typescript
// 默认超时 30 秒
const result = await nodeRegistry.invoke({
  nodeId: "node_xyz789",
  command: "long-running-task",
  timeoutMs: 60000, // 自定义超时
});

if (result.error?.code === "TIMEOUT") {
  console.log("命令执行超时");
}
```

---

## 远程执行

### 配置远程执行

在 `openclaw.json` 中配置：

```json
{
  "tools": {
    "exec": {
      "host": "node",
      "node": "node_xyz789",
      "security": "allowlist",
      "ask": "on-miss"
    }
  }
}
```

### 执行流程

```
┌─────────┐                ┌─────────┐                ┌──────┐
│  Agent  │                │ Gateway │                │ Node │
└────┬────┘                └────┬────┘                └───┬──┘
     │                          │                         │
     │  1. exec("ls -la")       │                         │
     ├─────────────────────────>│                         │
     │                          │                         │
     │                          │  2. node.invoke         │
     │                          ├────────────────────────>│
     │                          │                         │
     │                          │  3. execute command     │
     │                          │                         │
     │                          │  4. return result       │
     │                          │<────────────────────────┤
     │                          │                         │
     │  5. return to agent      │                         │
     │<─────────────────────────┤                         │
     └──────────────────────────┴─────────────────────────┘
```

### 执行审批

远程执行支持审批机制：

```typescript
// 获取节点的执行审批配置
const approvals = await nodeRegistry.invoke({
  nodeId: "node_xyz789",
  command: "system.execApprovals.get",
});

// 设置执行审批
await nodeRegistry.invoke({
  nodeId: "node_xyz789",
  command: "system.execApprovals.set",
  params: {
    approvals: {
      "npm install": { approved: true, expiresAt: Date.now() + 3600000 },
    },
  },
});
```

### 执行事件

系统会发送执行事件通知：

```typescript
// 执行开始
{
  event: "exec.started",
  nodeId: "node_xyz789",
  runId: "run_123",
  command: "npm install"
}

// 执行完成
{
  event: "exec.finished",
  nodeId: "node_xyz789",
  runId: "run_123",
  exitCode: 0,
  output: "...",
  timedOut: false
}

// 执行被拒绝
{
  event: "exec.denied",
  nodeId: "node_xyz789",
  runId: "run_123",
  reason: "not in allowlist"
}
```

---

## 浏览器代理

### 配置浏览器代理

```json
{
  "tools": {
    "web": {
      "fetch": {
        "browser": {
          "enabled": true,
          "node": "node_xyz789",
          "fallback": "gateway"
        }
      }
    }
  }
}
```

### 使用场景

1. **绕过地域限制**

   ```typescript
   // 使用美国节点访问美国专属内容
   const result = await fetch("https://us-only-site.com", {
     browser: { node: "us-node" },
   });
   ```

2. **移动端浏览器**

   ```typescript
   // 使用 iPhone 节点获取移动版网页
   const result = await fetch("https://mobile-site.com", {
     browser: { node: "iphone-node" },
   });
   ```

3. **分布式爬虫**
   ```typescript
   // 使用多个节点并发爬取
   const nodes = ["node1", "node2", "node3"];
   const results = await Promise.all(
     urls.map((url, i) => fetch(url, { browser: { node: nodes[i % nodes.length] } })),
   );
   ```

### 浏览器代理流程

```
┌────────┐              ┌─────────┐              ┌──────┐
│ Agent  │              │ Gateway │              │ Node │
└───┬────┘              └────┬────┘              └───┬──┘
    │                        │                       │
    │  web_fetch(url)        │                       │
    ├───────────────────────>│                       │
    │                        │                       │
    │                        │  browser.proxy        │
    │                        ├──────────────────────>│
    │                        │                       │
    │                        │  launch browser       │
    │                        │  navigate to url      │
    │                        │  extract content      │
    │                        │                       │
    │                        │  return html/text     │
    │                        │<──────────────────────┤
    │                        │                       │
    │  return content        │                       │
    │<───────────────────────┤                       │
    └────────────────────────┴───────────────────────┘
```

---

## 节点权限管理

### 命令白名单

限制节点可以执行的命令：

```json
{
  "nodes": {
    "node_xyz789": {
      "commands": {
        "allow": ["system.execApprovals.*", "browser.proxy", "file.read"],
        "deny": ["system.shutdown", "file.delete"]
      }
    }
  }
}
```

### 权限检查

```typescript
const isAllowed = isNodeCommandAllowed({
  nodeId: "node_xyz789",
  command: "browser.proxy",
  allowlist: ["browser.*", "system.execApprovals.*"],
});
```

### 能力声明

Node 声明自己的能力：

```typescript
const caps = [
  "exec", // 支持命令执行
  "browser", // 支持浏览器代理
  "file", // 支持文件操作
  "mobile", // 移动设备特有能力
];
```

### 权限配置

```typescript
const permissions = {
  "exec.elevated": false, // 禁止提权执行
  "file.write": true, // 允许写文件
  "network.external": true, // 允许外网访问
  "system.shutdown": false, // 禁止关机
};
```

---

## 实战场景

### 场景 1: 多地域网页爬取

**需求**：从不同地区爬取网页内容

**架构**：

```
Gateway (中国)
├── Node-US (美国)
├── Node-EU (欧洲)
└── Node-JP (日本)
```

**配置**：

```json
{
  "tools": {
    "web": {
      "fetch": {
        "browser": {
          "enabled": true,
          "nodes": {
            "us": "node-us",
            "eu": "node-eu",
            "jp": "node-jp"
          }
        }
      }
    }
  }
}
```

**使用**：

```typescript
// Agent 自动选择最近的节点
const usContent = await fetch("https://us-site.com");
const euContent = await fetch("https://eu-site.com");
const jpContent = await fetch("https://jp-site.com");
```

### 场景 2: 开发环境隔离

**需求**：在专用开发机上执行构建任务

**架构**：

```
Gateway (MacBook)
└── Node-DevServer (Linux 开发服务器)
```

**配置**：

```json
{
  "agents": [
    {
      "id": "build-agent",
      "tools": {
        "exec": {
          "host": "node",
          "node": "dev-server",
          "security": "allowlist",
          "safeBins": ["npm", "node", "git", "docker"]
        }
      }
    }
  ]
}
```

**使用**：

```bash
# Agent 在开发服务器上执行构建
Agent: "请在开发服务器上构建项目"
> exec: cd /project && npm run build
```

### 场景 3: 移动端测试

**需求**：使用真实移动设备测试网页

**架构**：

```
Gateway (Mac)
├── Node-iPhone (iOS)
└── Node-Android (Android)
```

**配置**：

```json
{
  "tools": {
    "web": {
      "fetch": {
        "browser": {
          "preferMobile": true,
          "mobileNodes": ["iphone-node", "android-node"]
        }
      }
    }
  }
}
```

**使用**：

```typescript
// 自动使用移动节点
const mobileView = await fetch("https://mobile-site.com");
```

### 场景 4: 分布式任务处理

**需求**：将大任务分配到多个节点并行处理

**架构**：

```
Gateway
├── Node-Worker-1
├── Node-Worker-2
├── Node-Worker-3
└── Node-Worker-4
```

**实现**：

```typescript
const workers = ["worker-1", "worker-2", "worker-3", "worker-4"];
const tasks = [...]; // 大量任务

const results = await Promise.all(
  tasks.map((task, i) =>
    nodeRegistry.invoke({
      nodeId: workers[i % workers.length],
      command: "process.task",
      params: { task }
    })
  )
);
```

---

## 故障排查

### 问题 1: 节点无法连接

**症状**：Node 无法连接到 Gateway

**排查步骤**：

1. 检查网络连接

   ```bash
   ping gateway-host
   telnet gateway-host 18789
   ```

2. 检查 Gateway 状态

   ```bash
   openclaw gateway status
   ```

3. 查看 Gateway 日志

   ```bash
   openclaw logs --filter node
   ```

4. 检查防火墙

   ```bash
   # macOS
   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

   # Linux
   sudo ufw status
   ```

### 问题 2: 配对请求未收到

**症状**：发送配对请求后没有响应

**排查步骤**：

1. 检查配对请求列表

   ```bash
   openclaw nodes pair list
   ```

2. 查看待批准的请求

   ```bash
   openclaw nodes pair pending
   ```

3. 手动批准
   ```bash
   openclaw nodes pair approve <requestId>
   ```

### 问题 3: 命令执行超时

**症状**：Node 命令执行超时

**排查步骤**：

1. 增加超时时间

   ```json
   {
     "tools": {
       "exec": {
         "timeoutSec": 60
       }
     }
   }
   ```

2. 检查 Node 负载

   ```bash
   # 在 Node 上执行
   top
   htop
   ```

3. 查看 Node 日志
   ```bash
   # 在 Node 上执行
   openclaw node logs
   ```

### 问题 4: 权限被拒绝

**症状**：命令执行被拒绝

**排查步骤**：

1. 检查命令白名单

   ```bash
   openclaw nodes get <nodeId> --show-commands
   ```

2. 更新白名单

   ```json
   {
     "nodes": {
       "node_xyz789": {
         "commands": {
           "allow": ["*"]
         }
       }
     }
   }
   ```

3. 检查执行审批
   ```bash
   openclaw exec approvals get --node <nodeId>
   ```

---

## 最佳实践

### 1. 节点命名规范

使用有意义的名称：

```
✅ 好的命名
- macbook-pro-work
- linux-server-prod
- iphone-15-test

❌ 不好的命名
- node1
- device
- test
```

### 2. 安全配置

```json
{
  "nodes": {
    "production-node": {
      "security": {
        "commands": {
          "allow": ["browser.*", "file.read"],
          "deny": ["system.*", "exec.elevated"]
        },
        "requireApproval": true,
        "maxConcurrent": 5
      }
    }
  }
}
```

### 3. 监控和日志

```bash
# 定期检查节点状态
openclaw nodes health

# 监控节点连接
openclaw logs --filter "node.connected|node.disconnected"

# 查看节点执行统计
openclaw stats nodes
```

### 4. 负载均衡

```typescript
// 自动选择负载最低的节点
const selectNode = (nodes: NodeSession[]) => {
  return nodes.reduce((best, node) => (node.load < best.load ? node : best));
};
```

### 5. 故障转移

```json
{
  "tools": {
    "exec": {
      "node": "primary-node",
      "fallback": ["backup-node-1", "backup-node-2"],
      "retryOnFailure": true
    }
  }
}
```

### 6. 定期清理

```bash
# 清理离线超过 30 天的节点
openclaw nodes cleanup --offline-days 30

# 清理未使用的配对
openclaw nodes pair cleanup
```

---

## 总结

OpenClaw Node 节点系统提供了强大的分布式计算能力：

- ✅ **灵活部署**：支持桌面、移动、服务器多种平台
- ✅ **安全可控**：完善的配对、权限和审批机制
- ✅ **高可用性**：支持故障转移和负载均衡
- ✅ **易于管理**：丰富的管理命令和监控工具
- ✅ **实用场景**：远程执行、浏览器代理、分布式任务

通过合理配置和使用 Node 节点，你可以构建一个强大、灵活、安全的分布式 AI 系统。

---

## 相关资源

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [Node API 参考](https://docs.openclaw.ai/api/nodes)
- [远程执行指南](https://docs.openclaw.ai/tools/exec)
- [浏览器代理配置](https://docs.openclaw.ai/tools/browser)

---

**最后更新**: 2024-02-16
**版本**: 1.0.0
