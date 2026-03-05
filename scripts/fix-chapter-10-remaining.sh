#!/bin/bash

# 修复第10章剩余的命令
# 这个脚本修复第一次脚本未处理的命令

set -e

FILE="docs/03-advanced/10-skills-extension.md"

echo "修复剩余的 openclaw skill 命令..."

# openclaw skill stats -> 标注为可能不可用
sed -i.tmp2 's/openclaw skill stats/# ⚠️ 命令可能不可用: openclaw skill stats/g' "$FILE"

# openclaw skill status -> 标注为可能不可用
sed -i.tmp2 's/openclaw skill status/# ⚠️ 命令可能不可用: openclaw skill status/g' "$FILE"

# 删除临时文件
rm -f "${FILE}.tmp2"

# 统计剩余数量
count=$(grep -c "openclaw skill " "$FILE" || true)
echo "修复完成！剩余 $count 处需要检查"

# 显示剩余的
if [ $count -gt 0 ]; then
    echo ""
    echo "剩余的命令："
    grep -n "openclaw skill " "$FILE"
fi
