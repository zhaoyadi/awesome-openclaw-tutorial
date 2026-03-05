# 第10章命令修复说明

## 问题

第10章中使用了错误的命令 `openclaw skill`，正确的命令应该是 `openclaw skills`（注意是复数）。

## 需要修复的命令

根据实际测试，以下命令需要修复：

### ❌ 错误命令
```bash
openclaw skill list
openclaw skill install
openclaw skill update
openclaw skill uninstall
openclaw skill check
openclaw skill perf
openclaw skill backup
openclaw skill restore
openclaw skill logs
openclaw skill config
openclaw skill docs
openclaw skill priority
openclaw skill publish
openclaw skill feedback
openclaw skill reinstall
openclaw skill cache
```

### ✅ 正确命令
```bash
openclaw skills list
# 注意：其他 skill 子命令可能不存在，需要使用 npx clawhub@latest
```

## 实际可用的命令

根据 `openclaw --help` 输出，实际可用的命令是：

```bash
# Skills 管理（通过 ClawHub）
npx clawhub@latest search <keyword>
npx clawhub@latest install <skill-name>
npx clawhub@latest uninstall <skill-name>
npx clawhub@latest update <skill-name>
npx clawhub@latest list

# OpenClaw 内置命令
openclaw skills list          # 列出已安装的 Skills
openclaw skills info <name>   # 查看 Skill 信息（可能支持）
openclaw skills enable <name> # 启用 Skill（可能支持）
openclaw skills disable <name># 禁用 Skill（可能支持）
```

## 建议的修复方案

由于很多 `openclaw skill` 子命令可能不存在，建议：

1. **保留基础命令**：
   - `openclaw skills list` - 已验证可用
   
2. **使用 ClawHub 命令**：
   - 安装/卸载/更新使用 `npx clawhub@latest`
   
3. **删除或标注不确定的命令**：
   - `openclaw skill perf`
   - `openclaw skill backup`
   - `openclaw skill logs`
   - 等等

4. **添加警告说明**：
   ```markdown
   > ⚠️ **注意**：以下命令可能在你的 OpenClaw 版本中不可用。
   > 请先运行 `openclaw --help` 查看可用命令。
   ```

## 修复优先级

### 🔴 高优先级（必须修复）
- `openclaw skill list` → `openclaw skills list`
- 所有安装/卸载命令改为使用 `npx clawhub@latest`

### 🟡 中优先级（建议修复）
- 添加命令可用性警告
- 标注哪些命令可能不存在

### 🟢 低优先级（可选）
- 提供替代方案
- 添加故障排查步骤

## 下一步

建议创建一个简化版的第10章，只包含确认可用的命令，并添加清晰的警告说明。
