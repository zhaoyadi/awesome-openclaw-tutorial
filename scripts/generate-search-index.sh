#!/bin/bash

# 搜索索引生成脚本
# 从所有 markdown 文件中提取关键词和内容，生成完整的搜索索引

echo "🔍 生成搜索索引..."

OUTPUT_FILE="search-index-expanded.json"

# 开始 JSON 数组
echo "[" > "$OUTPUT_FILE"

# 首次处理标志
first=true

# 查找所有 markdown 文件（排除特定目录）
find docs appendix examples -name "*.md" -type f | while read -r file; do
    # 获取相对路径
    rel_path=${file#*/}

    # 转换为 HTML URL
    url_path="/${rel_path%.md}.html"

    # 提取标题（第一个 # 标题）
    title=$(head -20 "$file" | grep "^# " | head -1 | sed 's/^# //' | sed 's/^第.*章：//' || echo "未命名文档")

    # 提取前几段作为摘要
    excerpt=$(sed -n '/^> /p; /^## /p; /^### /p' "$file" | head -5 | tr '\n' ' ' | sed 's/> //g' | sed 's/^## //g' | sed 's/^### //g' | cut -c1-200)

    # 提取内容关键词（去掉特殊字符和空行）
    content=$(cat "$file" | grep -v "^\!\[" | grep -v "^```" | grep -v "^\*\*" | tr '\n' ' ' | sed 's/[^a-zA-Z0-9\u4e00-\u9fa5]/ /g' | tr -s ' ' | cut -c1-500)

    # 确定分类
    if [[ $file == docs* ]]; then
        category="docs"
    elif [[ $file == appendix* ]]; then
        category="appendix"
    elif [[ $file == examples* ]]; then
        category="examples"
    else
        category="other"
    fi

    # 如果不是第一个元素，添加逗号
    if [ "$first" = false ]; then
        echo "," >> "$OUTPUT_FILE"
    fi
    first=false

    # 添加 JSON 对象（需要转义特殊字符）
    echo "  {" >> "$OUTPUT_FILE"
    echo "    \"title\": \"$title\"," >> "$OUTPUT_FILE"
    echo "    \"url\": \"$url_path\"," >> "$OUTPUT_FILE"
    echo "    \"excerpt\": \"$excerpt\"," >> "$OUTPUT_FILE"
    echo "    \"content\": \"$content\"," >> "$OUTPUT_FILE"
    echo "    \"category\": \"$category\"" >> "$OUTPUT_FILE"
    echo "  }" >> "$OUTPUT_FILE"

    echo "✓ 已索引: $title"
done

# 结束 JSON 数组
echo "" >> "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

echo ""
echo "✅ 搜索索引已生成: $OUTPUT_FILE"
echo "📊 ��计文档数: $(find docs appendix examples -name "*.md" -type f | wc -l)"
