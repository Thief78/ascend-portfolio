#!/bin/bash
# ============================================
# check_service.sh —— 服务连通自检
# 用法: ./check_service.sh [端口1 端口2 ...]
# ============================================

# ① 待检查端口：有参数用参数，否则默认 22 8080
PORTS="${@:-22 8080}"

# ② 报告头
echo "==========================================="
echo "  服务连通自检报告"
echo "  检查时间: $(date '+%F %T')"
echo "  检查端口: $PORTS"
echo "==========================================="
printf "  %-8s %-10s %s\n" "端口" "监听" "HTTP"
echo "  ------------------------------"

# ③ 逐个端口检查
for port in $PORTS; do
	# 判断端口是否在监听
    if ss -tln | grep -q ":${port} "; then
        listen="监听中"
        # curl 取 HTTP 状态码存进变量 code
        code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${port} 2>/dev/null)
    else
        listen="未监听"
        code="-"
    fi
    # 用 printf 左对齐打印这一行
    printf "  %-8s %-10s %s\n" "$port" "$listen" "$code"
done

echo "  ------------------------------"
echo "  自检完成"
