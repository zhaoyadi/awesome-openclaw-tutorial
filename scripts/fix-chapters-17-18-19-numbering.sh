#!/usr/bin/env bash
# 修复第17、18、19章的内部编号问题

set -euo pipefail

echo "🔧 修复第17、18、19章的内部编号..."
echo ""

# 第17章: 将所有 16.x 改为 17.x
echo "1️⃣ 修复第17章..."
sed -i '' 's/^## 16\./## 17./g' awesome-openclaw-tutorial/docs/04-practical-cases/17-advanced-automation.md

# 第18章: 将所有 14.x 改为 18.x
echo "2️⃣ 修复第18章..."
sed -i '' 's/^## 14\./## 18./g' awesome-openclaw-tutorial/docs/04-practical-cases/18-creative-applications.md
sed -i '' 's/^### 14\./### 18./g' awesome-openclaw-tutorial/docs/04-practical-cases/18-creative-applications.md

# 第19章: 将所有 15.x 改为 19.x
echo "3️⃣ 修复第19章..."
sed -i '' 's/^## 15\./## 19./g' awesome-openclaw-tutorial/docs/04-practical-cases/19-solo-entrepreneur-cases.md
sed -i '' 's/^### 15\./### 19./g' awesome-openclaw-tutorial/docs/04-practical-cases/19-solo-entrepreneur-cases.md

echo ""
echo "✅ 第17、18、19章的内部编号已修复！"
echo ""
echo "修复内容："
echo "  - 第17章: 16.x → 17.x"
echo "  - 第18章: 14.x → 18.x"
echo "  - 第19章: 15.x → 19.x"
