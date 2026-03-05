# 章节重新编号方案（图书出版版）

## 📋 调整原则

1. **连续编号**：所有章节按顺序编号，无跳号
2. **去除子章节**：不使用"第X.Y章"的格式
3. **合并优化**：
   - 去掉Discord配置（国外平台，国内用户较少）
   - QQ配置合并到企微+钉钉章节

## 📊 新旧章节对照表

### 第一部分：基础篇

| 新编号 | 旧编号 | 章节名称 | 文件名 | 状态 |
|--------|--------|----------|--------|------|
| 第1章 | 第1章 | OpenClaw简介 | 01-introduction.md | 保持 |
| 第2章 | 第2章 | 快速安装 | 02-installation.md | 保持 |
| 第3章 | 第2.1章 | 进阶部署 | 02-1-advanced-deployment.md → 03-advanced-deployment.md | 重命名 |
| 第4章 | 第2.2章 | 维护升级 | 02-2-maintenance-upgrade.md → 04-maintenance-upgrade.md | 重命名 |
| 第5章 | 第3章 | 快速上手 | 03-quick-start.md → 05-quick-start.md | 重命名 |

### 第二部分：核心功能

| 新编号 | 旧编号 | 章节名称 | 文件名 | 状态 |
|--------|--------|----------|--------|------|
| 第6章 | 第4章 | 对话管理 | 04-conversation-management.md → 06-conversation-management.md | 重命名 |
| 第7章 | 第5章 | 指令系统 | 05-command-system.md → 07-command-system.md | 重命名 |
| 第8章 | 第6章 | 定时任务 | 06-schedule-management.md → 08-schedule-management.md | 重命名 |
| 第9章 | 第7章 | 文件处理 | 07-file-processing.md → 09-file-processing.md | 重命名 |

### 第三部分：进阶功能

| 新编号 | 旧编号 | 章节名称 | 文件名 | 状态 |
|--------|--------|----------|--------|------|
| 第10章 | 第8章 | Skills扩展 | 08-skills-extension.md → 10-skills-extension.md | 重命名 |
| 第11章 | 第9章 | 多平台集成概述 | 09-multi-platform-integration.md → 11-multi-platform-integration.md | 重命名 |
| 第12章 | 第9.1章 | 飞书Bot配置 | 09-1-feishu-bot.md → 12-feishu-bot.md | 重命名 |
| 第13章 | 第9.2章+9.3章(QQ) | 企微+钉钉+QQ配置 | 09-2-wework-dingtalk.md → 13-wework-dingtalk-qq.md | 合并+重命名 |
| 第14章 | 第10章 | API集成 | 10-api-integration.md → 14-api-integration.md | 重命名 |

### 第四部分：实战案例

| 新编号 | 旧编号 | 章节名称 | 文件名 | 状态 |
|--------|--------|----------|--------|------|
| 第15章 | 第14章 | 个人效率提升 | 14-personal-productivity.md → 15-personal-productivity.md | 重命名 |
| 第16章 | 第15章 | 高级自动化 | 15-advanced-automation.md → 16-advanced-automation.md | 重命名 |
| 第17章 | 第16章 | 创意应用 | 16-creative-applications.md → 17-creative-applications.md | 重命名 |
| 第18章 | 第17章 | 独立开发者案例 | 17-solo-entrepreneur-cases.md → 18-solo-entrepreneur-cases.md | 重命名 |

## 🗑️ 删除的文件

| 文件名 | 原因 |
|--------|------|
| 09-3-qq-discord.md | Discord去掉，QQ合并到第13章 |

## 📝 需要修改的内容

### 1. 第13章：企微+钉钉+QQ配置

**操作**：
1. 复制 `09-2-wework-dingtalk.md` 为 `13-wework-dingtalk-qq.md`
2. 从 `09-3-qq-discord.md` 提取QQ部分
3. 添加到第13章末尾
4. 删除Discord相关内容
5. 更新章节标题和导航

### 2. 更新所有章节的内部链接

需要更新的链接类型：
- 章节间跳转链接
- 返回导航链接
- 参考链接

### 3. 更新README.md目录

更新主目录，反映新的章节编号。

## ⏱️ 执行步骤

### 步骤1：创建第13章（合并版）
- 复制企微+钉钉内容
- 添加QQ配置内容
- 更新章节标题和编号

### 步骤2：重命名文件
- 按照对照表重命名所有文件
- 使用 `smartRelocate` 自动更新引用

### 步骤3：删除废弃文件
- 删除 `09-3-qq-discord.md`

### 步骤4：更新README
- 更新主目录结构
- 确保所有链接正确

### 步骤5：验证
- 检查所有链接是否正确
- 确认章节编号连续
- 测试导航功能

## 📊 调整后的目录结构

```
awesome-openclaw-tutorial/
├── docs/
│   ├── 01-basics/
│   │   ├── 01-introduction.md          # 第1章
│   │   ├── 02-installation.md          # 第2章
│   │   ├── 03-advanced-deployment.md   # 第3章（新）
│   │   ├── 04-maintenance-upgrade.md   # 第4章（新）
│   │   └── 05-quick-start.md           # 第5章（新）
│   ├── 02-core-features/
│   │   ├── 06-conversation-management.md  # 第6章（新）
│   │   ├── 07-command-system.md          # 第7章（新）
│   │   ├── 08-schedule-management.md     # 第8章（新）
│   │   └── 09-file-processing.md         # 第9章（新）
│   ├── 03-advanced/
│   │   ├── 10-skills-extension.md           # 第10章（新）
│   │   ├── 11-multi-platform-integration.md # 第11章（新）
│   │   ├── 12-feishu-bot.md                 # 第12章（新）
│   │   ├── 13-wework-dingtalk-qq.md         # 第13章（新，合并）
│   │   └── 14-api-integration.md            # 第14章（新）
│   └── 04-practical-cases/
│       ├── 15-personal-productivity.md      # 第15章（新）
│       ├── 16-advanced-automation.md        # 第16章（新）
│       ├── 17-creative-applications.md      # 第17章（新）
│       └── 18-solo-entrepreneur-cases.md    # 第18章（新）
```

## ✅ 预期效果

1. **章节编号连续**：第1章到第18章，无跳号
2. **符合出版规范**：每个文件对应一个独立章节
3. **内容优化**：去掉不常用的Discord，保留国内主流平台
4. **便于阅读**：章节逻辑清晰，查找方便

---

**创建时间**：2026-02-16
**状态**：待执行
