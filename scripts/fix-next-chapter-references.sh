#!/usr/bin/env bash
# 修复所有"下一章预告"的章节引用错误

set -euo pipefail

echo "🔧 开始修复'下一章预告'的章节引用..."
echo ""

# 第8章 → 下一章是第9章
echo "1️⃣ 修复第8章的下一章预告..."
sed -i '' 's/\*\*下一章预告\*\*：第7章将学习自动化工作流/\*\*下一章预告\*\*：第9章将学习自动化工作流/' \
  awesome-openclaw-tutorial/docs/02-core-features/08-schedule-management.md

# 第9章 → 下一章是第10章
echo "2️⃣ 修复第9章的下一章预告..."
sed -i '' 's/\*\*下一章预告\*\*：第8章将学习Skills扩展/\*\*下一章预告\*\*：第10章将学习Skills扩展/' \
  awesome-openclaw-tutorial/docs/02-core-features/09-automation-workflow.md

# 第10章 → 下一章是第11章 (有两处)
echo "3️⃣ 修复第10章的下一章预告..."
sed -i '' 's/\*\*下一章预告\*\*：第9章将学习多平台集成/\*\*下一章预告\*\*：第11章将学习多平台集成/g' \
  awesome-openclaw-tutorial/docs/03-advanced/10-skills-extension.md

# 第14章 → 下一章是第15章
echo "4️⃣ 修复第14章的下一章预告..."
sed -i '' 's/\*\*下一章预告：\*\* 第11章 高级配置/\*\*下一章预告：\*\* 第15章 高级配置/' \
  awesome-openclaw-tutorial/docs/03-advanced/14-api-integration.md

# 第15章(高级配置) → 下一章是第15章(个人效率)
echo "5️⃣ 修复第15章(高级配置)的下一章预告..."
sed -i '' 's/\*\*下一章预告\*\*：第12章将进入实战案例部分/\*\*下一章预告\*\*：第15章将进入实战案例部分/' \
  awesome-openclaw-tutorial/docs/03-advanced/15-advanced-configuration.md

# 第15章(个人效率) → 下一章是第16章
echo "6️⃣ 修复第15章(个人效率)的下一章预告..."
sed -i '' 's/\*\*下一章预告\*\*：第12章将学习个人效率进阶/\*\*下一章预告\*\*：第16章将学习高级自动化工作流/' \
  awesome-openclaw-tutorial/docs/04-practical-cases/15-personal-productivity.md

# 第16章 → 下一章是第17章
echo "7️⃣ 修复第16章的下一章预告..."
sed -i '' 's/\*\*下一章预告\*\*：第13章将学习创意应用探索/\*\*下一章预告\*\*：第17章将学习创意应用探索/' \
  awesome-openclaw-tutorial/docs/04-practical-cases/16-advanced-automation.md

# 第17章 → 下一章是第18章
echo "8️⃣ 修复第17章的下一章预告..."
sed -i '' 's/\*\*下一章预告\*\*：第15章将学习常见问题与解决方案/\*\*下一章预告\*\*：第18章将学习一人公司实战案例/' \
  awesome-openclaw-tutorial/docs/04-practical-cases/17-creative-applications.md

echo ""
echo "✅ 所有'下一章预告'的章节引用已修复！"
echo ""
echo "修复内容："
echo "  - 第8章: 第7章 → 第9章"
echo "  - 第9章: 第8章 → 第10章"
echo "  - 第10章: 第9章 → 第11章 (2处)"
echo "  - 第14章: 第11章 → 第15章"
echo "  - 第15章(高级配置): 第12章 → 第15章(个人效率)"
echo "  - 第15章(个人效率): 第12章 → 第16章"
echo "  - 第16章: 第13章 → 第17章"
echo "  - 第17章: 第15章 → 第18章"
