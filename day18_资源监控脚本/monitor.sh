#!/bin/bash
# ============================================
# monitor.sh —— 推理资源监控脚本
# 模拟 FAE 性能排查：监控 CPU/内存/磁盘/进程/GPU-NPU
# 用法：./monitor.sh [采样间隔秒数]
# ============================================
INTERVAL="${1:-2}"   # 默认每 2 秒采样一次，可传参覆盖

echo "==========================================="
echo "  推理资源监控报告"
echo "  采样间隔: ${INTERVAL}s"
echo "  时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==========================================="

# ---- 1. 系统信息 ----
echo ""
echo "【系统信息】"
echo "  主机名: $(hostname)"
echo "  内核: $(uname -r)"
echo "  运行时长: $(uptime -p)"

# ---- 2. CPU 负载 ----
echo ""
echo "【CPU 负载】"
echo "  $(uptime | awk -F'load average:' '{print "平均负载:" $2}')"
echo "  核心数: $(nproc)"

# ---- 3. 内存 ----
echo ""
echo "【内存使用】"
free -h | awk 'NR==1 || NR==2 {print "  " $0}'

# ---- 4. 磁盘 ----
echo ""
echo "【磁盘使用】"
df -h / | awk 'NR==1 || NR==2 {print "  " $0}'

# ---- 5. 推理进程占用（模拟：找 python 进程）----
echo ""
echo "【推理进程资源占用】"
ps aux --sort=-%cpu | grep -i python | grep -v grep | head -3 | \
awk '{printf "  进程:%s  CPU:%s%%  内存:%s%%  命令:%s\n", $11, $3, $4, $11}'

# ---- 6. GPU/NPU 检测（有真卡才输出）----
echo ""
echo "【加速卡检测】"
if command -v nvidia-smi &>/dev/null; then
    nvidia-smi --query-gpu=utilization.gpu,memory.used,temperature.gpu \
        --format=csv,noheader | awk '{print "  GPU: 利用率" $1 " 显存" $2 " 温度" $3}'
elif command -v npu-smi &>/dev/null; then
    npu-smi info | head -20
else
    echo "  未检测到 GPU/NPU（当前为无卡环境，模拟监控）"
fi

# ---- 7. 采样循环（模拟持续监控）----
echo ""
echo "【持续采样（Ctrl+C 退出）】"
while true; do
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    mem_avail=$(free -m | awk 'NR==2 {print $7}')
    echo "  [$(date '+%H:%M:%S')] CPU使用率: ${cpu_usage}%  可用内存: ${mem_avail}MB"
    sleep "$INTERVAL"
done
