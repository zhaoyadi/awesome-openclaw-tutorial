#!/usr/bin/env bash
# 修复第15章编号冲突问题

set -euo pipefail

echo "🔧 修复第15章编号冲突..."
echo ""

cd awesome-openclaw-tutorial/docs/04-practical-cases

# 重命名文件 (从后往前,避免冲突)
echo "1️⃣ 重命名文件..."
mv 18-solo-entrepreneur-cases.md 19-solo-entrepreneur-cases.md
mv 17-creative-applications.md 18-creative-applications.md
mv 16-advanced-automation.md 17-advanced-automation.md
mv 15-personal-productivity.md 16-personal-productivity.md

echo ""
echo "2️⃣ 修改文件内标题..."

# 修改第16章标题
sed -i '' 's/^# 第15章 5类人群的效率提升实战/# 第16章 5类人群的效率提升实战/' 16-personal-productivity.md

# 修改第17章标题
sed -i '' 's/^# 第16章 高级自动化工作流/# 第17章 高级自动化工作流/' 17-advanced-automation.md

# 修改第18章标题
sed -i '' 's/^# 第17章 创意应用探索/# 第18章 创意应用探索/' 18-creative-applications.md

# 修改第19章标题
sed -i '' 's/^# 第18章 一人公司实战案例/# 第19章 一人公司实战案例/' 19-solo-entrepreneur-cases.md

echo ""
echo "3️⃣ 修改章节内部编号..."

# 第16章: 15.x.x → 16.x.x
sed -i '' 's/^### 15\./### 16./g' 16-personal-productivity.md
sed -i '' 's/^## 15\./## 16./g' 16-personal-productivity.md

# 第17章: 16.x.x → 17.x.x
sed -i '' 's/^### 16\./### 17./g' 17-advanced-automation.md
sed -i '' 's/^## 17\./## 17./g' 17-advanced-automation.md

# 第18章: 17.x.x → 18.x.x
sed -i '' 's/^### 17\./### 18./g' 18-creative-applications.md
sed -i '' 's/^## 18\./## 18./g' 18-creative-applications.md

# 第19章: 18.x.x → 19.x.x
sed -i '' 's/^### 18\./### 19./g' 19-solo-entrepreneur-cases.md
sed -i '' 's/^## 19\./## 19./g' 19-solo-entrepreneur-cases.md

echo ""
echo "✅ 第15章编号冲突已修复！"
echo ""
echo "修复内容："
echo "  - 15-personal-productivity.md → 16-personal-productivity.md (第16章)"
echo "  - 16-advanced-automation.md → 17-advanced-automation.md (第17章)"
echo "  - 17-creative-applications.md → 18-creative-applications.md (第18章)"
echo "  - 18-solo-entrepreneur-cases.md → 19-solo-entrepreneur-cases.md (第19章)"
echo ""
echo "现在章节编号为: 1-15 (03-advanced), 16-19 (04-practical-cases)"
