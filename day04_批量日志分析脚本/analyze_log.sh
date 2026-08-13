#!/bin/bash
# ============================================
# analyze_log.sh —— 批量日志分析脚本
# 用法：./analyze_log.sh <日志文件路径>
# ============================================
set -e

# ---- 1. 检查参数 ----
if [ -z "$1" ]; then
    echo "用法: $0 <日志文件>"
    exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "错误: 文件 $LOG_FILE 不存在"
    exit 1
fi

echo "==========================================="
echo "  日志分析报告: $LOG_FILE"
echo "  分析时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==========================================="

# ---- 2. 统计函数 ----
count_by_level() {
    local level="$1"
    local count
    count=$(grep -c "$level" "$LOG_FILE")
    echo "  [$level]  $count 条"
}

echo ""
echo "【按级别统计】"
count_by_level "FATAL"
count_by_level "ERROR"
count_by_level "WARN"
count_by_level "INFO"

# ---- 3. 提取错误详情 ----
echo ""
echo "【错误详情（最近5条）】"
grep "ERROR\|FATAL" "$LOG_FILE" | tail -5 | while read line; do
    echo "  $line"
done

# ---- 4. 按模块统计 ----
echo ""
echo "【按模块统计错误数】"
grep "ERROR\|FATAL" "$LOG_FILE" | awk '{print $5}' | sort | uniq -c | sort -rn
#                                        │          │      │        │
#                                        │          │      │        └─ 按数字降序
#                                        │          │      └─ 数每个模块出现几次
#                                        │          └─ 排序（把相同模块放一起）
#                                        └─ 提取第5列（模块名 [worker]）

echo ""
echo "==========================================="
echo "  分析完成"
echo "==========================================="
