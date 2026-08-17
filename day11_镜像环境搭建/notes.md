# Day 11 理论笔记：Docker 概念 / 安装 / 镜像

## 1. 容器 vs 虚拟机

**概念**：虚拟机（如 VMware）是硬件级虚拟化，每个实例包含完整操作系统（几 GB），启动需分钟级。Docker 容器是操作系统级隔离，共享宿主机内核（几十 MB），启动仅秒级。虚拟机是"装了一台新电脑"，容器是"在这台电脑上开个独立小房间"。

**为什么重要**：昇腾 FAE 交付推理服务时，容器是标准方式——把模型、依赖、运行环境打包成一个镜像，用户拉下来就能跑，不受"我机器上为什么跑不起来"的困扰。容器轻量、启动快，一台服务器能跑几十个容器，而虚拟机只能跑几个。

**踩坑**：容器共享宿主机内核，所以**Linux 容器只能在 Linux 上跑**（Windows/Mac 上的 Docker 本质是套了一层虚拟机）。Docker 不是虚拟机的替代品，两者常组合使用——虚拟机做隔离边界，容器做应用打包。

---

## 2. 核心概念：Image / Container / Registry

**概念**：镜像（Image）是只读的模板，类似程序安装包；容器（Container）是镜像运行起来的实例，类似从安装包装好的程序；仓库（Registry）是存镜像的地方，Docker Hub 是最大公共仓库。Docker 采用 C/S 架构——`docker` 命令是客户端，发给 Docker daemon（守护进程）执行。

**为什么重要**：三个词是 Docker 的全部基础。`pull` 从仓库下载镜像，`run` 从镜像启动容器，`images` 看本地镜像。理解"镜像→容器"的关系，后面 Day 12-15 全部围绕它展开。

**踩坑**：镜像和容器容易混淆——镜像是"类"，容器是"实例"。删容器不影响镜像，删镜像前必须先删光它启动的容器。`docker` 命令和 `docker daemon` 是两个进程，daemon 没启动时所有命令都报 `Cannot connect to the Docker daemon`。

---

## 3. 安装配置：Docker Engine、镜像加速器

**概念**：Docker Engine 是核心运行环境，官方提供一键安装脚本 `get.docker.com`。国内加速器（阿里云、DaoCloud 等）是 Docker Hub 的镜像代理，配置写在 `/etc/docker/daemon.json` 的 `registry-mirrors` 里。`systemctl start/stop/restart docker` 管理 Docker 服务。

**为什么重要**：Docker 默认从 Docker Hub 拉镜像，国内访问慢且常超时。配置加速器后走国内 CDN，拉取速度从"几小时"变"几分钟"。`daemon.json` 改完必须 `systemctl restart docker` 才生效。

**踩坑**：加速器地址失效很常见（镜像站经常关停），配置多个地址做备份，Docker 会自动尝试下一个。把用户加入 `docker` 组后必须重新登录才生效，否则还是每次要 sudo。

---

## 4. 镜像操作：pull / images / rmi / tag、分层原理

**概念**：`docker pull 镜像:tag` 拉取镜像，`docker images` 列出本地镜像，`docker rmi 镜像` 删除镜像，`docker tag 旧名 新名` 打标签。镜像分层（layer）——镜像由多层叠加而成，每层只存"相对上一层的增量"，相同的层可以复用。tag 是镜像的版本标签（如 `python:3.12-slim`）。

**为什么重要**：分层是 Docker 体积小的秘密——拉取新镜像时，已经存在的层直接复用，只下载新增的层。`-slim` 标签是精简版（去掉编译工具），生产部署首选；`-alpine` 更小但可能缺依赖。

**踩坑**：`python:3.12` 和 `python:3.12-slim` 是完全不同的镜像，tag 写错会拉错。`latest` 标签不代表"最新"，只是默认标签，生产环境要写死具体版本号。镜像占用空间大，`docker images` 看到几 GB 是正常的，注意定期清理不用的镜像。
