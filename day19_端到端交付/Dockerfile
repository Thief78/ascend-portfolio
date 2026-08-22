FROM python:3.12-slim

WORKDIR /app

# 复制推理服务代码
COPY infer_api.py .

# 暴露推理服务端口
EXPOSE 8000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# 启动服务
CMD ["python", "infer_api.py"]
