#!/bin/bash
# ============================================
# init_env.sh —— 新机器环境初始化脚本
# 模拟 FAE 接手一台新 Ubuntu Server 后的标准操作
# ============================================
set -e  # 任何一条命令出错就立即退出（安全机制）

echo "=== 1. 检查是否为 root 执行 ==="
if [ "$(whoami)" != "root" ]; then
    echo "❌ 请用 sudo 运行此脚本"
    exit 1
fi

echo "=== 2. 创建专用用户 ==="
NEW_USER="fae_dev"
if id "$NEW_USER" &>/dev/null; then
    echo "⚠ 用户 $NEW_USER 已存在，跳过创建"
else
    useradd -m -s /bin/bash "$NEW_USER"
    echo "✅ 用户 $NEW_USER 已创建"
fi
#    useradd  -m  -s /bin/bash  fae_dev
#    │        │    │             └─ 用户名
#    │        │    └─ 指定 shell（bash）
#    │        └─ 自动创建家目录 /home/fae_dev
#    └─ 添加用户

echo "=== 3. 配置 sudo 权限 ==="
if grep -q "^$NEW_USER" /etc/sudoers; then
    echo "⚠ $NEW_USER 已在 sudoers 中"
else
    echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$NEW_USER
    #          │          │               └─ 追加到专用配置文件
    #          │          └─ 免密码执行 sudo
    #          └─ 所有命令
    echo "✅ sudo 权限已配置"
fi

echo "=== 4. 更换 apt 国内源 ==="
if [ -f /etc/apt/sources.list ]; then
    cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d)
    sed -i 's/mirrors.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
    #       │                         │
    #       │                         └─ 换成阿里云源
    #       └─ 原地替换文件内容
    echo "✅ apt 源已切换为阿里云镜像"
else
    echo "⚠ sources.list 不存在，可能是新版 Ubuntu，跳过"
fi

echo "=== 5. 更新系统 ==="
apt update && apt upgrade -y
echo "✅ 系统更新完成"

echo ""
echo "==============================================="
echo "  ✅ 初始化完成！"
echo "  新用户: $NEW_USER"
echo "  家目录: /home/$NEW_USER"
echo "==============================================="#!/bin/bash
# ============================================
# init_env.sh —— 新机器环境初始化脚本
# 模拟 FAE 接手一台新 Ubuntu Server 后的标准操作
# ============================================
set -e  # 任何一条命令出错就立即退出（安全机制）

echo "=== 1. 检查是否为 root 执行 ==="
if [ "$(whoami)" != "root" ]; then
    echo "❌ 请用 sudo 运行此脚本"
    exit 1
fi

echo "=== 2. 创建专用用户 ==="
NEW_USER="fae_dev"
if id "$NEW_USER" &>/dev/null; then
    echo "⚠ 用户 $NEW_USER 已存在，跳过创建"
else
    useradd -m -s /bin/bash "$NEW_USER"
    echo "✅ 用户 $NEW_USER 已创建"
fi
#    useradd  -m  -s /bin/bash  fae_dev
#    │        │    │             └─ 用户名
#    │        │    └─ 指定 shell（bash）
#    │        └─ 自动创建家目录 /home/fae_dev
#    └─ 添加用户

echo "=== 3. 配置 sudo 权限 ==="
if grep -q "^$NEW_USER" /etc/sudoers; then
    echo "⚠ $NEW_USER 已在 sudoers 中"
else
    echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$NEW_USER
    #          │          │               └─ 追加到专用配置文件
    #          │          └─ 免密码执行 sudo
    #          └─ 所有命令
    echo "✅ sudo 权限已配置"
fi

echo "=== 4. 更换 apt 国内源 ==="
if [ -f /etc/apt/sources.list ]; then
    cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d)
    #  └─ 改配置前先备份！这是工程师的基本素养
    sed -i 's/mirrors.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
    #       │                         │
    #       │                         └─ 换成阿里云源
    #       └─ 原地替换文件内容
    echo "✅ apt 源已切换为阿里云镜像"
else
    echo "⚠ sources.list 不存在，可能是新版 Ubuntu，跳过"
fi

echo "=== 5. 更新系统 ==="
apt update && apt upgrade -y
echo "✅ 系统更新完成"

echo ""
echo "==============================================="
echo "  ✅ 初始化完成！"
echo "  新用户: $NEW_USER"
echo "  家目录: /home/$NEW_USER"
echo "==============================================="
