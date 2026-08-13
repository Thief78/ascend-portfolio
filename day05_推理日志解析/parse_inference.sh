#!/bin/bash
# ============================================
# parse_inference.sh —— 推理日志解析脚本
# 模拟 FAE 排查：提取精度/耗时指标，生成指标报表
# ============================================
set -e

if [ -z "$1" ]; then
    echo "用法: $0 <日志文件>"
    exit 1
fi
LOG="$1"
[ -f "$LOG" ] || { echo "错误: $LOG 不存在"; exit 1; }

echo "==========================================="
echo "  推理日志解析报告"
echo "  文件: $LOG"
echo "==========================================="

echo ""
echo "【日志级别统计】(grep -c)"
for level in INFO WARN ERROR; do
    n=$(grep -c "\[$level\]" "$LOG")
    echo "  $level: $n 条"
done

echo ""
echo "【推理指标明细】(awk 提取)"
echo "  序号  精度(accuracy)  耗时(latency)"
echo "  ------------------------------------"
awk -F'[=,]' '/accuracy=/ {
    gsub(/^.*Batch /, "", $1)       # 去掉 $1 前缀，只留 Batch 后的内容
    printf "  %-10s   %s      %s\n", $1, $3, $5
}' "$LOG"

echo ""
echo "【汇总指标】(awk 平均值)"
awk -F'[=,]' '
    /accuracy=/ && $5+0 > 0 {        # 过滤失败行(latency=0)
        sum_acc += $3                # $3 = accuracy 值
        sum_lat += $5                # $5 = latency 值
        cnt++
    }
    END {
        if (cnt > 0) {
            printf "  有效批次: %d\n", cnt
            printf "  平均精度: %.4f\n", sum_acc / cnt
            printf "  平均耗时: %.2f ms\n", sum_lat / cnt
        }
    }
' "$LOG"

echo ""
echo "【失败批次定位】(grep + sed)"
grep "ERROR" "$LOG" | sed 's/.*\(Batch [0-9]*\).*/\1/'

echo ""
echo "==========================================="
echo "  解析完成"
echo "==========================================="
