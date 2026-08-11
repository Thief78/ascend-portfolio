#!/bin/bash
echo "=== 检查工作区结构 ==="
for dir in code data log doc; do
    if [ -d "$HOME/project/$dir" ]; then
        echo "✅ $dir 存在"
    else
        echo "❌ $dir 缺失"
    fi
done
echo "=== 速查表 ==="
cat ~/project/doc/commands_cheatsheet.md
