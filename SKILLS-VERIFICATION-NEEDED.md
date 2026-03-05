# Skills验证清单

## 📋 需要验证的Skills

以下是教程中提到的所有需要通过 `npx clawhub@latest install` 安装的skills，需要逐一验证是否在ClawHub上真实存在。

---

## 🔍 验证方法

```bash
# 搜索skill是否存在
npx clawhub@latest search <skill-name>

# 尝试安装
npx clawhub@latest install <skill-name>
```

---

## 📊 Skills清单

### 第10章：Skills扩展 (10-skills-extension.md)

#### 核心Skills（重点推荐）

| Skill名称 | 状态 | 位置 | 说明 |
|-----------|------|------|------|
| `mcporter` | ❓ 待验证 | 第10章 | MCP服务器管理 |
| `brave-search` | ❓ 待验证 | 第10章 | 网页搜索 |
| `transcript-api` | ❌ 不存在 | 第10章 | 视频字幕提取（已确认不存在） |
| `file-system-manager` | ❓ 待验证 | 第10章 | 文件系统管理 |
| `playwright-headless` | ❓ 待验证 | 第10章 | 浏览器自动化 |
| `design-doc-mermaid` | ❓ 待验证 | 第10章 | 设计文档生成 |
| `google-workspace` | ❓ 待验证 | 第10章 | Google工作区集成 |
| `find-skills` | ❓ 待验证 | 第10章 | Skills发现（Skills双幻神之一） |
| `proactive-agent` | ❓ 待验证 | 第10章 | 主动代理（Skills双幻神之一） |

#### 场景化Skills

| Skill名称 | 状态 | 位置 | 说明 |
|-----------|------|------|------|
| `github` | ❓ 待验证 | 第10章 | GitHub集成 |
| `linear-integration` | ❓ 待验证 | 第10章 | Linear项目管理 |
| `slack-bot` | ❓ 待验证 | 第10章 | Slack机器人 |
| `home-assistant` | ❓ 待验证 | 第10章 | 智能家居 |
| `weather-api` | ❓ 待验证 | 第10章 | 天气API |
| `location-tracker` | ❓ 待验证 | 第10章 | 位置追踪 |
| `automation-scheduler` | ❓ 待验证 | 第10章 | 自动化调度 |
| `baidu-search` | ❓ 待验证 | 第10章 | 百度搜索 |

---

### 第14章：API集成 (14-api-integration.md)

#### 视频生成Skills

| Skill名称 | 状态 | 位置 | 说明 |
|-----------|------|------|------|
| `video-agent` | ❓ 待验证 | 第14章 | 视频代理 |
| `sora-video-gen` | ❓ 待验证 | 第14章 | Sora视频生成 |
| `veo3-video-gen` | ❓ 待验证 | 第14章 | Veo3视频生成 |
| `tube-cog` | ❓ 待验证 | 第14章 | Tube Cog |
| `video-cog` | ❓ 待验证 | 第14章 | Video Cog |

#### 语音合成Skills

| Skill名称 | 状态 | 位置 | 说明 |
|-----------|------|------|------|
| `elevenlabs` | ❓ 待验证 | 第14章 | ElevenLabs TTS |
| `azure-tts` | ❓ 待验证 | 第14章 | Azure TTS |
| `google-tts` | ❓ 待验证 | 第14章 | Google TTS |
| `openai-tts` | ❓ 待验证 | 第14章 | OpenAI TTS |

#### AI绘图Skills

| Skill名称 | 状态 | 位置 | 说明 |
|-----------|------|------|------|
| `fal-ai` | ❓ 待验证 | 第14章 | Fal AI |
| `nvidia-image-gen` | ❓ 待验证 | 第14章 | NVIDIA图像生成 |
| `pollinations` | ❓ 待验证 | 第14章 | Pollinations |
| `venice-ai` | ❓ 待验证 | 第14章 | Venice AI |
| `recraft` | ❓ 待验证 | 第14章 | Recraft |

---

## 📝 验证结果记录

### 已确认不存在的Skills

1. ✅ `transcript-api` - 已从教程中删除

### 待验证的Skills（共31个）

**核心Skills（9个）**：
1. mcporter
2. brave-search
3. file-system-manager
4. playwright-headless
5. design-doc-mermaid
6. google-workspace
7. find-skills
8. proactive-agent
9. baidu-search

**场景化Skills（7个）**：
10. github
11. linear-integration
12. slack-bot
13. home-assistant
14. weather-api
15. location-tracker
16. automation-scheduler

**视频生成Skills（5个）**：
17. video-agent
18. sora-video-gen
19. veo3-video-gen
20. tube-cog
21. video-cog

**语音合成Skills（4个）**：
22. elevenlabs
23. azure-tts
24. google-tts
25. openai-tts

**AI绘图Skills（5个）**：
26. fal-ai
27. nvidia-image-gen
28. pollinations
29. venice-ai
30. recraft

---

## 🎯 验证优先级

### P0 - 高优先级（核心功能）

这些skills在教程中被重点推荐，需要优先验证：

1. ✅ `mcporter` - MCP服务器管理（Skills双幻神前置）
2. ✅ `brave-search` - 网页搜索（核心功能）
3. ✅ `find-skills` - Skills发现（Skills双幻神）
4. ✅ `proactive-agent` - 主动代理（Skills双幻神）
5. ✅ `file-system-manager` - 文件系统管理
6. ✅ `playwright-headless` - 浏览器自动化

### P1 - 中优先级（常用功能）

7. `design-doc-mermaid` - 设计文档生成
8. `google-workspace` - Google工作区集成
9. `github` - GitHub集成
10. `baidu-search` - 百度搜索

### P2 - 低优先级（扩展功能）

其余的视频生成、语音合成、AI绘图等skills。

---

## 🔧 验证脚本

```bash
#!/bin/bash

# Skills验证脚本
# 用法: ./verify-skills.sh

echo "开始验证Skills..."

# P0 核心Skills
skills_p0=(
  "mcporter"
  "brave-search"
  "find-skills"
  "proactive-agent"
  "file-system-manager"
  "playwright-headless"
)

# P1 常用Skills
skills_p1=(
  "design-doc-mermaid"
  "google-workspace"
  "github"
  "baidu-search"
)

# P2 扩展Skills
skills_p2=(
  "video-agent"
  "sora-video-gen"
  "elevenlabs"
  "fal-ai"
)

echo "=== P0 核心Skills验证 ==="
for skill in "${skills_p0[@]}"; do
  echo "验证: $skill"
  npx clawhub@latest search "$skill" 2>&1 | grep -q "not found" && echo "❌ $skill - 不存在" || echo "✅ $skill - 存在"
done

echo ""
echo "=== P1 常用Skills验证 ==="
for skill in "${skills_p1[@]}"; do
  echo "验证: $skill"
  npx clawhub@latest search "$skill" 2>&1 | grep -q "not found" && echo "❌ $skill - 不存在" || echo "✅ $skill - 存在"
done

echo ""
echo "=== P2 扩展Skills验证 ==="
for skill in "${skills_p2[@]}"; do
  echo "验证: $skill"
  npx clawhub@latest search "$skill" 2>&1 | grep -q "not found" && echo "❌ $skill - 不存在" || echo "✅ $skill - 存在"
done

echo ""
echo "验证完成！"
```

---

## 📌 注意事项

1. **验证方法**：
   - 优先使用 `npx clawhub@latest search <skill-name>` 搜索
   - 如果搜索不到，尝试 `npx clawhub@latest install <skill-name>` 安装
   - 如果安装失败显示"Skill not found"，则确认不存在

2. **命名规范**：
   - ClawHub上的skill名称可能与教程中的不完全一致
   - 需要尝试不同的命名格式（如：`brave-search` vs `brave_search` vs `bravesearch`）

3. **替代方案**：
   - 如果某个skill不存在，查找OpenClaw内置的类似功能
   - 或者在教程中添加"该skill暂不可用"的说明

4. **更新教程**：
   - 验证完成后，删除所有不存在的skills
   - 更新批量安装命令
   - 调整相关的使用示例

---

## 🎯 下一步行动

1. **运行验证脚本**：逐一验证所有skills
2. **记录验证结果**：更新本文档的验证状态
3. **更新教程内容**：删除不存在的skills，调整相关命令
4. **创建替代方案**：为不存在的skills提供替代方案或说明

---

**创建时间**：2026-02-17  
**待验证Skills数量**：31个  
**已确认不存在**：1个（transcript-api）  
**状态**：待验证
