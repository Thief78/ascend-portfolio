#!/bin/bash
# 模拟长时间训练任务——每 10 秒输出一行日志
for i in $(seq 1 6); do
    echo "[$(date '+%H:%M:%S')] Epoch $i/6 | loss: $(echo "scale=4; 0.9^$i" | bc) | accuracy: $(echo "scale=2; 0.5+0.08*$i" | bc)"
    sleep 10
done
echo "[$(date '+%H:%M:%S')] ✅ 训练完成"
