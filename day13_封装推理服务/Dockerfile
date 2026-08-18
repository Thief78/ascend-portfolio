# 基于 Python 精简镜像
FROM python:3.12-slim

# 设置工作目录（容器内的路径）
WORKDIR /app

# 设置环境变量（避免 Python 生成 __pycache__，让输出更干净）
ENV PYTHONDONTWRITEBYTECODE=1

# 把当前目录的 infer.py 复制进容器的 /app 目录
COPY infer.py .

# 构建时执行：这里没有额外依赖，留空或装个包做演示
RUN echo "Build complete"

# 声明容器将监听 8000 端口（文档性质，实际服务用）
EXPOSE 8000

# 容器启动时默认运行推理程序
CMD ["python", "infer.py"]
