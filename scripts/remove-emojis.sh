#!/usr/bin/env bash
# 将emoji表情替换为适合书籍的符号

set -euo pipefail

echo "🔧 替换emoji表情为书籍符号..."
echo ""

# 查找所有markdown文件
find awesome-openclaw-tutorial/docs -name "*.md" -type f | while read -r file; do
    echo "处理: $file"
    
    # 备份文件
    cp "$file" "${file}.emoji-backup"
    
    # 替换常见emoji
    sed -i '' 's/🍎/【Mac】/g' "$file"
    sed -i '' 's/🪟/【Windows】/g' "$file"
    sed -i '' 's/🐧/【Linux】/g' "$file"
    sed -i '' 's/🌍/【国外】/g' "$file"
    sed -i '' 's/🇨🇳/【国内】/g' "$file"
    sed -i '' 's/💻/【本地】/g' "$file"
    sed -i '' 's/☁️/【云端】/g' "$file"
    sed -i '' 's/🐳/【Docker】/g' "$file"
    
    # 替换状态emoji
    sed -i '' 's/✅/√/g' "$file"
    sed -i '' 's/❌/×/g' "$file"
    sed -i '' 's/⚠️/！/g' "$file"
    sed -i '' 's/💡/提示：/g' "$file"
    sed -i '' 's/⭐/★/g' "$file"
    sed -i '' 's/🔥/热门：/g' "$file"
    
    # 替换功能emoji
    sed -i '' 's/📋/【目录】/g' "$file"
    sed -i '' 's/📝/【说明】/g' "$file"
    sed -i '' 's/📊/【数据】/g' "$file"
    sed -i '' 's/📈/【趋势】/g' "$file"
    sed -i '' 's/📚/【文档】/g' "$file"
    sed -i '' 's/📄/【文件】/g' "$file"
    sed -i '' 's/📁/【文件夹】/g' "$file"
    sed -i '' 's/🔑/【密钥】/g' "$file"
    sed -i '' 's/🔧/【配置】/g' "$file"
    sed -i '' 's/⚡/【快速】/g' "$file"
    sed -i '' 's/💰/【成本】/g' "$file"
    sed -i '' 's/🎯/【目标】/g' "$file"
    sed -i '' 's/🚀/【启动】/g' "$file"
    sed -i '' 's/🔒/【安全】/g' "$file"
    sed -i '' 's/🎥/【视频】/g' "$file"
    sed -i '' 's/📱/【手机】/g' "$file"
    sed -i '' 's/🎨/【设计】/g' "$file"
    sed -i '' 's/🧹/【清理】/g' "$file"
    
    # 替换箭头emoji
    sed -i '' 's/→/-->/g' "$file"
    sed -i '' 's/←/<--/g' "$file"
    sed -i '' 's/↓/|/g' "$file"
    sed -i '' 's/↑/^/g' "$file"
    
    # 替换其他常见emoji
    sed -i '' 's/🎬/【脚本】/g' "$file"
    sed -i '' 's/🤖/【AI】/g' "$file"
    sed -i '' 's/💬/【对话】/g' "$file"
    sed -i '' 's/🔍/【搜索】/g' "$file"
    sed -i '' 's/📦/【包】/g' "$file"
    sed -i '' 's/🌐/【网络】/g' "$file"
    sed -i '' 's/🧠/【智能】/g' "$file"
    sed -i '' 's/💻/【编程】/g' "$file"
    
done

echo ""
echo "✅ emoji替换完成！"
echo ""
echo "备份文件已保存为 *.emoji-backup"
echo "如需恢复，运行："
echo "  find awesome-openclaw-tutorial/docs -name '*.emoji-backup' | while read f; do mv \"\$f\" \"\${f%.emoji-backup}\"; done"
