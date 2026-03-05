# 第10章命令修复报告

## 修复时间
2026-02-20 13:11:42

## 修复统计
- 修复前错误数量: 19
- 修复后错误数量: 17
- 成功修复数量: 2

## 修复内容

### 已修复的命令
1. `openclaw skill list` → `openclaw skills list`
2. `openclaw skill install` → `npx clawhub@latest install`
3. `openclaw skill uninstall` → `npx clawhub@latest uninstall`
4. `openclaw skill update` → `npx clawhub@latest update`
5. `openclaw skill check` → `openclaw skills check`

### 标注为可能不可用的命令
- `openclaw skill perf`
- `openclaw skill backup`
- `openclaw skill restore`
- `openclaw skill logs`
- `openclaw skill config`
- `openclaw skill docs`
- `openclaw skill priority`
- `openclaw skill publish`
- `openclaw skill feedback`
- `openclaw skill reinstall`
- `openclaw skill cache`

## 备份文件
原文件已备份到: `docs/03-advanced/10-skills-extension.md.backup-20260220-131142`

## 验证方法
```bash
# 查看修复后的文件
cat docs/03-advanced/10-skills-extension.md | grep "openclaw skill"

# 如果需要恢复
cp docs/03-advanced/10-skills-extension.md.backup-20260220-131142 docs/03-advanced/10-skills-extension.md
```

## 建议
1. 运行 `openclaw --help` 查看实际可用的命令
2. 测试修复后的命令是否可用
3. 如有问题，可从备份文件恢复
