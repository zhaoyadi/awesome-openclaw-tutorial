#!/usr/bin/env python3
"""
为代码块添加引用语
根据清华大学出版社规范:
- 代码用"代码如下:"引出
- 命令用"命令如下:"引出
"""

import os
import re

def is_command_block(code_content):
    """判断是否为命令块"""
    # 常见的命令特征
    command_patterns = [
        r'^(npm|pnpm|yarn|bun|node|python|pip|git|docker|curl|wget|ssh|scp)',
        r'^(cd|ls|mkdir|rm|cp|mv|cat|grep|find|chmod|chown)',
        r'^(openclaw|clawhub)',
        r'^\$',  # shell提示符
        r'^#',   # root提示符
    ]
    
    lines = code_content.strip().split('\n')
    if not lines:
        return False
    
    first_line = lines[0].strip()
    for pattern in command_patterns:
        if re.match(pattern, first_line, re.IGNORECASE):
            return True
    
    return False

def add_code_references(filepath):
    """为文件中的代码块添加引用语"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 查找所有代码块
    pattern = r'(^|\n)(```[\w]*\n)(.*?)(^```$)'
    
    def replace_code_block(match):
        prefix = match.group(1)
        code_start = match.group(2)
        code_content = match.group(3)
        code_end = match.group(4)
        
        # 检查前面是否已经有引用语
        before_code = content[:match.start()]
        last_lines = before_code.split('\n')[-3:]  # 检查前3行
        
        has_reference = False
        for line in last_lines:
            if '代码如下' in line or '命令如下' in line:
                has_reference = True
                break
        
        if has_reference:
            # 已经有引用语,不添加
            return match.group(0)
        
        # 判断是代码还是命令
        if is_command_block(code_content):
            reference = "命令如下:\n\n"
        else:
            reference = "代码如下:\n\n"
        
        return prefix + reference + code_start + code_content + code_end
    
    new_content = re.sub(pattern, replace_code_block, content, flags=re.MULTILINE | re.DOTALL)
    
    # 统计添加的数量
    added_count = new_content.count('代码如下:') + new_content.count('命令如下:') - \
                  content.count('代码如下:') - content.count('命令如下:')
    
    if added_count > 0:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return added_count
    
    return 0

def main():
    """主函数"""
    print("开始为代码块添加引用语...")
    print()
    
    total_added = 0
    processed_files = 0
    
    for root, dirs, files in os.walk("docs"):
        for file in sorted(files):
            if file.endswith(".md") and not file.endswith(".emoji-backup"):
                filepath = os.path.join(root, file)
                added = add_code_references(filepath)
                if added > 0:
                    print(f"✓ {filepath}: 添加了 {added} 个引用语")
                    total_added += added
                    processed_files += 1
    
    print()
    print(f"完成! 共处理 {processed_files} 个文件,添加了 {total_added} 个引用语")

if __name__ == "__main__":
    main()
