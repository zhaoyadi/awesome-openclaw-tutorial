# OpenClaw 工具策略配置完全指南

## 目录

1. [概述](#概述)
2. [工具策略架构](#工具策略架构)
3. [配置文件（Profile）](#配置文件profile)
4. [基础策略配置](#基础策略配置)
5. [高级策略配置](#高级策略配置)
6. [网络工具配置](#网络工具配置)
7. [执行工具配置](#执行工具配置)
8. [沙箱策略](#沙箱策略)
9. [分组和用户级策略](#分组和用户级策略)
10. [最佳实践](#最佳实践)
11. [常见问题](#常见问题)

---

## 概述

OpenClaw 的工具策略系统是一个强大而灵活的权限管理框架，允许你精确控制 AI Agent 可以使用哪些工具。通过合理配置工具策略，你可以：

- 🔒 **增强安全性**：限制危险操作，防止意外或恶意行为
- 🎯 **优化性能**：减少不必要的工具调用，提高响应速度
- 🎨 **定制体验**：为不同场景配置不同的工具集
- 👥 **分级管理**：为不同用户或群组设置不同的权限

### 配置文件位置

工具策略配置位于 `~/.openclaw-{gateway-id}/openclaw.json` 文件的 `tools` 字段中。

---

## 工具策略架构

OpenClaw 的工具策略采用**多层级过滤**架构，按以下顺序应用：

```
全局策略 (tools)
    ↓
Provider 级策略 (tools.byProvider)
    ↓
Agent 级策略 (agents[].tools)
    ↓
群组策略 (channels.*.groups[].tools)
    ↓
用户级策略 (channels.*.groups[].toolsBySender)
    ↓
沙箱策略 (tools.sandbox.tools)
    ↓
子 Agent 策略 (tools.subagents.tools)
```

每一层都可以进一步限制（但不能放宽）上一层的权限。

---

## 配置文件（Profile）

OpenClaw 提供了 4 个预设的工具配置文件，适用于不同场景：

### 1. `minimal` - 最小化配置

**适用场景**：高安全性环境、只读操作

**包含工具**：

- `read` - 读取文件
- `list` - 列出文件
- `memory_search` - 搜索记忆

**配置示例**：

```json
{
  "tools": {
    "profile": "minimal"
  }
}
```

### 2. `messaging` - 消息配置

**适用场景**：聊天机器人、客服助手

**包含工具**：

- 基础文件操作（read、list）
- 消息工具（message_send、message_edit）
- 网络工具（web_search、web_fetch）
- 记忆搜索

**配置示例**：

```json
{
  "tools": {
    "profile": "messaging"
  }
}
```

### 3. `coding` - 编程配置

**适用场景**：代码助手、开发工具

**包含工具**：

- 完整文件操作（read、write、edit、delete）
- 代码执行（exec）
- Git 操作
- 终端工具
- 网络工具

**配置示例**：

```json
{
  "tools": {
    "profile": "coding"
  }
}
```

### 4. `full` - 完整配置

**适用场景**：个人助手、全功能 Agent

**包含工具**：所有可用工具

**配置示例**：

```json
{
  "tools": {
    "profile": "full"
  }
}
```

---

## 基础策略配置

### Allow 列表（允许列表）

显式指定允许使用的工具。如果设置了 `allow`，则只有列表中的工具可用。

```json
{
  "tools": {
    "allow": ["read", "write", "web_search", "message_send"]
  }
}
```

### Deny 列表（拒绝列表）

显式禁用某些工具。`deny` 的优先级高于 `allow`。

```json
{
  "tools": {
    "profile": "full",
    "deny": ["exec", "delete", "system_shutdown"]
  }
}
```

### AlsoAllow 列表（额外允许）

在配置文件基础上额外添加工具，而不需要重写整个 `allow` 列表。

```json
{
  "tools": {
    "profile": "messaging",
    "alsoAllow": ["exec", "git_commit"]
  }
}
```

### 通配符支持

使用 `*` 表示所有工具：

```json
{
  "tools": {
    "allow": ["*"], // 允许所有工具
    "deny": ["exec", "delete"] // 但禁用这两个
  }
}
```

---

## 高级策略配置

### Provider 级策略

为不同的 AI Provider 配置不同的工具策略：

```json
{
  "tools": {
    "profile": "full",
    "byProvider": {
      "openai": {
        "allow": ["*"],
        "deny": ["exec"]
      },
      "anthropic": {
        "profile": "coding"
      },
      "openai/gpt-4": {
        "allow": ["*"]
      }
    }
  }
}
```

### Agent 级策略

为特定 Agent 配置工具策略：
": 30,
"cacheTtlMinutes": 60
}
}
}
}

```

**支持的搜索提供商**：
- `brave` - Brave Search（推荐）
- `perplexity` - Perplexity AI
- `grok` - xAI Grok

**Perplexity 配置示例**：
```json
{
  "tools": {
    "web": {
      "search": {
        "provider": "perplexity",
        "perplexity": {
          "apiKey": "${PERPLEXITY_API_KEY}",
          "baseUrl": "https://openrouter.ai/api/v1",
          "model": "perplexity/sonar-pro"
        }
      }
    }
  }
}
```

### 网页获取配置

```json
{
  "tools": {
    "web": {
      "fetch": {
        "enabled": true,
        "maxChars": 50000,
        "maxCharsCap": 100000,
        "timeoutSeconds": 30,
        "cacheTtlMinutes": 60,
        "maxRedirects": 3,
        "readability": true,
        "userAgent": "OpenClaw/1.0",
        "firecrawl": {
          "enabled": true,
          "apiKey": "${FIRECRAWL_API_KEY}",
          "onlyMainContent": true
        }
      }
    }
  }
}
```

---

## 执行工具配置

### 基础执行配置

```json
{
  "tools": {
    "exec": {
      "host": "sandbox",
      "security": "allowlist",
      "ask": "on-miss",
      "timeoutSec": 30,
      "backgroundMs": 5000,
      "cleanupMs": 300000,
      "notifyOnExit": true
    }
  }
}
```

### 配置选项说明

#### `host` - 执行主机

- `sandbox` - 在 Docker 沙箱中执行（推荐，最安全）
- `gateway` - 在 Gateway 主机上执行
- `node` - 在指定节点上执行

#### `security` - 安全模式

- `deny` - 拒绝所有执行（最安全）
- `allowlist` - 只允许白名单中的命令
- `full` - 允许所有命令（危险）

#### `ask` - 询问模式

- `off` - 不询问，直接执行
- `on-miss` - 命令不在白名单时询问
- `always` - 总是询问用户确认

### 安全命令白名单

```json
{
  "tools": {
    "exec": {
      "security": "allowlist",
      "safeBins": ["ls", "cat", "grep", "find", "git", "npm", "node", "python"]
    }
  }
}
```

### PATH 配置

```json
{
  "tools": {
    "exec": {
      "pathPrepend": ["/usr/local/bin", "/opt/homebrew/bin", "$HOME/.local/bin"]
    }
  }
}
```

### 提权执行配置

```json
{
  "tools": {
    "elevated": {
      "enabled": true,
      "allowFrom": {
        "telegram": ["123456789"],
        "discord": ["user#1234"],
        "whatsapp": ["+1234567890"]
      }
    }
  }
}
```

---

## 沙箱策略

沙箱策略用于限制在 Docker 容器中执行的工具。

### 基础沙箱配置

```json
{
  "tools": {
    "sandbox": {
      "tools": {
        "allow": ["read", "write", "exec", "git_*"],
        "deny": ["system_*", "network_*"]
      }
    }
  }
}
```

### 子 Agent 策略

限制子 Agent 可以使用的工具：

```json
{
  "tools": {
    "subagents": {
      "model": "gpt-4",
      "tools": {
        "allow": ["read", "write", "web_search"],
        "deny": ["exec", "spawn_agent"]
      }
    }
  }
}
```

---

## 分组和用户级策略

### 群组工具策略

为特定群组配置工具策略：

```json
{
  "channels": {
    "telegram": {
      "groups": {
        "dev-team": {
          "tools": {
            "allow": ["*"],
            "deny": ["system_shutdown"]
          }
        },
        "public-chat": {
          "tools": {
            "profile": "messaging",
            "deny": ["exec"]
          }
        }
      }
    }
  }
}
```

### 用户级工具策略

为特定用户配置不同的权限：

```json
{
  "channels": {
    "telegram": {
      "groups": {
        "dev-team": {
          "toolsBySender": {
            "admin@example.com": {
              "allow": ["*"]
            },
            "developer@example.com": {
              "allow": ["read", "write", "exec"],
              "deny": ["delete", "system_*"]
            },
            "*": {
              "profile": "minimal"
            }
          }
        }
      }
    }
  }
}
```

---

## 最佳实践

### 1. 最小权限原则

始终从最小权限开始，根据需要逐步添加：

```json
{
  "tools": {
    "profile": "minimal",
    "alsoAllow": ["web_search", "message_send"]
  }
}
```

### 2. 使用配置文件 + 微调

不要从头编写 `allow` 列表，使用配置文件并微调：

```json
{
  "tools": {
    "profile": "coding",
    "deny": ["system_shutdown", "network_scan"]
  }
}
```

### 3. 分层管理

在不同层级设置不同的策略：

```json
{
  "tools": {
    "profile": "full",
    "deny": ["system_*"]
  },
  "agents": [
    {
      "id": "public-bot",
      "tools": {
        "profile": "messaging"
      }
    }
  ]
}
```

### 4. 使用环境变量

敏感信息使用环境变量：

```json
{
  "tools": {
    "web": {
      "search": {
        "apiKey": "${BRAVE_API_KEY}"
      }
    }
  }
}
```

### 5. 定期审查

定期检查工具使用日志，调整策略：

```bash
# 查看工具调用日志
openclaw logs --filter tool_use

# 查看被拒绝的工具调用
openclaw logs --filter tool_denied
```

---

## 常见问题

### Q1: 如何完全禁用某个工具？

在全局 `tools.deny` 中添加：

```json
{
  "tools": {
    "deny": ["exec", "delete"]
  }
}
```

### Q2: 如何为测试环境启用所有工具？

使用 `full` 配置文件：

```json
{
  "tools": {
    "profile": "full"
  }
}
```

### Q3: 如何只允许特定用户使用危险工具？

使用 `toolsBySender`：

```json
{
  "channels": {
    "telegram": {
      "groups": {
        "my-group": {
          "toolsBySender": {
            "admin@example.com": {
              "allow": ["*"]
            },
            "*": {
              "deny": ["exec", "delete"]
            }
          }
        }
      }
    }
  }
}
```

### Q4: 工具策略不生效怎么办？

1. 检查配置文件语法是否正确
2. 重启 Gateway：`openclaw gateway restart`
3. 查看日志：`openclaw logs --level debug`
4. 使用诊断工具：`openclaw doctor`

### Q5: 如何查看当前可用的工具列表？

```bash
# 查看所有工具
openclaw tools list

# 查看特定 Agent 的工具
openclaw tools list --agent coding-assistant

# 查看工具策略
openclaw config get tools
```

### Q6: 沙箱和主机执行有什么区别？

| 特性     | 沙箱 (sandbox)   | 主机 (gateway) |
| -------- | ---------------- | -------------- |
| 安全性   | 高（隔离环境）   | 低（直接访问） |
| 性能     | 略慢（容器开销） | 快             |
| 文件访问 | 受限             | 完全访问       |
| 网络访问 | 可配置           | 完全访问       |
| 推荐场景 | 生产环境         | 开发/测试      |

### Q7: 如何临时启用某个工具？

使用 `alsoAllow`：

```json
{
  "tools": {
    "profile": "messaging",
    "alsoAllow": ["exec"]
  }
}
```

### Q8: 工具策略的优先级是什么？

优先级从高到低：

1. `deny` 列表（最高优先级）
2. `allow` 列表
3. `alsoAllow` 列表
4. `profile` 配置文件

---

## 配置示例

### 示例 1: 安全的生产环境配置

```json
{
  "tools": {
    "profile": "messaging",
    "deny": ["exec", "delete", "system_*"],
    "web": {
      "search": {
        "enabled": true,
        "provider": "brave",
        "maxResults": 5
      },
      "fetch": {
        "enabled": true,
        "maxChars": 10000,
        "readability": true
      }
    },
    "exec": {
      "host": "sandbox",
      "security": "deny"
    }
  }
}
```

### 示例 2: 开发环境配置

```json
{
  "tools": {
    "profile": "coding",
    "alsoAllow": ["docker_*", "k8s_*"],
    "exec": {
      "host": "gateway",
      "security": "allowlist",
      "ask": "on-miss",
      "safeBins": ["git", "npm", "docker", "kubectl"]
    },
    "elevated": {
      "enabled": true,
      "allowFrom": {
        "telegram": ["${ADMIN_TELEGRAM_ID}"]
      }
    }
  }
}
```

### 示例 3: 多用户分级配置

```json
{
  "tools": {
    "profile": "messaging"
  },
  "channels": {
    "telegram": {
      "groups": {
        "company-chat": {
          "toolsBySender": {
            "admin@company.com": {
              "allow": ["*"]
            },
            "dev@company.com": {
              "profile": "coding",
              "deny": ["system_*"]
            },
            "support@company.com": {
              "profile": "messaging",
              "alsoAllow": ["web_search"]
            },
            "*": {
              "profile": "minimal"
            }
          }
        }
      }
    }
  }
}
```

---

## 总结

OpenClaw 的工具策略系统提供了强大而灵活的权限管理能力。通过合理配置：

- ✅ 使用预设配置文件快速开始
- ✅ 通过 allow/deny 列表精确控制
- ✅ 利用多层级策略实现细粒度管理
- ✅ 为不同场景和用户配置不同权限
- ✅ 在安全性和功能性之间找到平衡

记住：**安全第一，从最小权限开始，根据需要逐步放宽。**

---

## 相关资源

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [工具列表参考](https://docs.openclaw.ai/tools)
- [配置文件 Schema](https://docs.openclaw.ai/config/schema)
- [安全最佳实践](https://docs.openclaw.ai/security)

---

**最后更新**: 2024-02-16
**版本**: 1.0.0
