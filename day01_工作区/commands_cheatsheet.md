# Linux 常用命令速查表

## 文件与目录
| 命令 | 功能 | 示例 |
|------|------|------|
| ls -la | 列出所有文件（含隐藏） | ls -la /home |
| cd | 切换目录 | cd ~/project |
| pwd | 打印当前路径 | pwd |
| mkdir -p | 创建目录（自动补父目录） | mkdir -p a/b/c |
| rm -r | 删除文件/目录（⚠ -rf 慎用） | rm -r old_dir/ |
| cp -r | 复制文件/目录 | cp -r src/ dst/ |
| mv | 移动/重命名 | mv old new |
| find -name | 按文件名搜索 | find . -name "*.py" |
| tree | 树形展示目录 | tree ~/project |

## 文件查看
| 命令 | 功能 |
|------|------|
| cat | 查看小文件全部内容 |
| less | 分页查看大文件（q 退出） |
| head -20 | 看文件前 20 行 |
| tail -20 | 看文件末尾 20 行 |
| tail -f | 实时监控文件更新（盯日志） |

## 权限
| 命令 | 功能 |
|------|------|
| chmod +x file | 加执行权限 |
| chmod 755 dir | 目录标准权限 |
| sudo cmd | 以管理员身份执行 |

## 系统信息
| 命令 | 功能 |
|------|------|
| whoami | 当前用户 |
| df -h | 磁盘剩余空间 |
| free -h | 内存剩余 |
| ps aux | 所有进程 |
| top | 实时系统负载（q 退出） |
