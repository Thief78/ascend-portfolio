# Day 1 理论笔记：Linux 系统认知 / 文件目录

## 1\. 主流发行版区别

* **概念**：Ubuntu (Debian系/apt)、CentOS (RedHat系/yum)、Debian (稳定版)
* **选型**：AI 开发领域 Ubuntu 是事实标准
* **易错点**：CentOS 用 yum，Ubuntu 用 apt，不能混用

## 2\. 核心目录作用

* /home → 用户文件 | /etc → 配置 | /var/log → 日志 | /tmp → 临时(重启清空)
* **易错点**：/root 是管理员家目录，不是根目录 /

## 3\. 核心命令

* ls/cd/pwd/mkdir -p/rm -r/cp -r/mv/find -name
* **易错点**：rm -rf / 会删光系统；mv 覆盖不提示

## 4\. 绝对路径 vs 相对路径

* 绝对路径从 / 开始；相对路径依赖当前目录；\~ 是家目录简写
* **易错点**：脚本用绝对路径更安全

