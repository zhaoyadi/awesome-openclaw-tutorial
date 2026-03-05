# 章节编号问题汇总

## 📋 发现的问题

根据图书出版规范，章节内的二级标题不应该使用数字编号（如"1.1"、"8.1"等），应该只使用描述性标题。

---

## 🔍 需要修复的文件

### 1. 第1章：OpenClaw简介
**文件**：`docs/01-basics/01-introduction.md`

**当前编号**：
- ## 1.1 什么是OpenClaw
- ## 1.2 为什么选择OpenClaw
- ## 1.3 OpenClaw vs 主流AI工具
- ## 1.4 适用场景
- ## 1.5 OpenClaw vs 其他AI工具能力对比

**应该改为**：
- ## 什么是OpenClaw
- ## 为什么选择OpenClaw
- ## OpenClaw vs 主流AI工具
- ## 适用场景
- ## OpenClaw vs 其他AI工具能力对比

---

### 2. 第10章：Skills扩展
**文件**：`docs/03-advanced/10-skills-extension.md`

**当前编号**：
- ## 8.0 Skills本质：AI的"操作说明书"
- ## 8.1 内置Skills（无需安装）
- ## 8.2 ClawHub技能市场
- ## 8.2 必装Skills推荐（重复编号！）
- ## 8.3 Skills 安装方法详解
- ... 更多

**问题**：
1. 使用了"8.x"编号（应该是"10.x"或者不用编号）
2. 存在重复编号（两个8.2）
3. 编号混乱

**应该改为**：
- ## Skills本质：AI的"操作说明书"
- ## 内置Skills（无需安装）
- ## ClawHub技能市场
- ## 必装Skills推荐
- ## Skills 安装方法详解
- ... 更多

---

### 3. 第12章：飞书Bot配置
**文件**：`docs/03-advanced/12-feishu-bot.md`

**当前编号**：
- ## 9.1.1 飞书机器人介绍
- ## 9.1.2 快速开始
- ## 9.1.3 创建飞书应用
- ## 9.1.4 配置OpenClaw
- ## 9.1.5 启动并测试

**问题**：
1. 使用了"9.1.x"编号（应该是"12.x"或者不用编号）
2. 三级编号不符合规范

**应该改为**：
- ## 飞书机器人介绍
- ## 快速开始
- ## 创建飞书应用
- ## 配置OpenClaw
- ## 启动并测试

---

### 4. 第13章：企微+钉钉+QQ配置
**文件**：`docs/03-advanced/13-wework-dingtalk-qq.md`

**当前编号**：
- ## 13.1 企业微信Bot配置
- ## 13.2 钉钉Bot配置
- ## 13.3 QQ Bot配置

**应该改为**：
- ## 企业微信Bot配置
- ## 钉钉Bot配置
- ## QQ Bot配置

---

### 5. 第14章：API集成
**文件**：`docs/03-advanced/14-api-integration.md`

**当前编号**：
- ## 10.1 AI绘图服务集成
- ## 10.2 Notion数据同步封装
- ## 10.3 视频生成服务
- ## 10.4 语音合成接入

**问题**：使用了"10.x"编号（应该是"14.x"或者不用编号）

**应该改为**：
- ## AI绘图服务集成
- ## Notion数据同步封装
- ## 视频生成服务
- ## 语音合成接入

---

### 6. 第15章：高级配置
**文件**：`docs/03-advanced/15-advanced-configuration.md`

**当前编号**：
- ## 11.1 Antigravity Manager完全配置指南
- ## 11.2 多模型切换策略
- ## 11.3 记忆搜索配置（Memory Search）
- ## 11.4 成本优化方案
- ## 11.5 性能调优技巧

**问题**：使用了"11.x"编号（应该是"15.x"或者不用编号）

**应该改为**：
- ## Antigravity Manager完全配置指南
- ## 多模型切换策略
- ## 记忆搜索配置（Memory Search）
- ## 成本优化方案
- ## 性能调优技巧

---

### 7. 第15-18章：实战案例
**文件**：
- `docs/04-practical-cases/15-personal-productivity.md`
- `docs/04-practical-cases/16-advanced-automation.md`
- `docs/04-practical-cases/17-creative-applications.md`
- `docs/04-practical-cases/18-solo-entrepreneur-cases.md`

**需要检查**：是否也存在类似的子编号问题

---

## 🎯 修复方案

### 方案1：完全移除子编号（推荐）

**优点**：
- 符合图书出版规范
- 简洁明了
- 便于维护

**缺点**：
- 失去了章节内的层次结构

**示例**：
```markdown
# 第10章 Skills扩展

## Skills本质
## 内置Skills
## ClawHub技能市场
## 必装Skills推荐
```

### 方案2：保留但统一编号

**优点**：
- 保持章节内的层次结构
- 便于交叉引用

**缺点**：
- 不符合图书出版规范
- 需要大量修改

**示例**：
```markdown
# 第10章 Skills扩展

## 10.1 Skills本质
## 10.2 内置Skills
## 10.3 ClawHub技能市场
## 10.4 必装Skills推荐
```

---

## 📝 建议

根据之前的修复经验（第5章已经移除了子编号），建议：

1. **采用方案1**：完全移除所有子编号
2. **保持一致性**：所有章节使用相同的格式
3. **使用描述性标题**：让标题本身就能说明内容

---

## 🔧 批量修复命令

```bash
# 第1章
sed -i '' 's/^## 1\.\([1-5]\) /## /g' docs/01-basics/01-introduction.md

# 第10章（需要手动处理，因为编号混乱）
# 建议手动修复

# 第12章
sed -i '' 's/^## 9\.1\.\([1-5]\) /## /g' docs/03-advanced/12-feishu-bot.md

# 第13章
sed -i '' 's/^## 13\.\([1-3]\) /## /g' docs/03-advanced/13-wework-dingtalk-qq.md

# 第14章
sed -i '' 's/^## 10\.\([1-4]\) /## /g' docs/03-advanced/14-api-integration.md

# 第15章
sed -i '' 's/^## 11\.\([1-5]\) /## /g' docs/03-advanced/15-advanced-configuration.md
```

---

## ✅ 已修复的文件

- ✅ 第2章：02-installation.md
- ✅ 第3章：03-advanced-deployment.md
- ✅ 第4章：04-maintenance-upgrade.md
- ✅ 第5章：05-quick-start.md
- ✅ 第6章：06-file-management.md
- ✅ 第7章：07-knowledge-management.md
- ✅ 第8章：08-schedule-management.md
- ✅ 第9章：09-automation-workflow.md

---

## ⚠️ 待修复的文件

- ⚠️ 第1章：01-introduction.md
- ⚠️ 第10章：10-skills-extension.md（编号混乱，需要手动处理）
- ⚠️ 第12章：12-feishu-bot.md
- ⚠️ 第13章：13-wework-dingtalk-qq.md
- ⚠️ 第14章：14-api-integration.md
- ⚠️ 第15章：15-advanced-configuration.md
- ⚠️ 第15-18章：实战案例（待检查）

---

**创建时间**：2026-02-17  
**状态**：待修复  
**优先级**：P1（中优先级）
