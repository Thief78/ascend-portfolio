# 昇腾推理服务 · 端到端交付示例

模拟 FAE 交付一个可运行推理服务项目。

## 项目结构
.
├── infer_api.py # 推理 HTTP 服务
├── Dockerfile # 容器化定义
└── README.md # 部署说明（本文件）


## 快速开始

### 方式一：直接运行（需要 Python 3.10+）
```bash
python infer_api.py
```

### 方式二：Docker 运行（推荐）
```bash
# 1. 构建镜像
docker build -t ascend-infer:1.0 .

# 2. 启动容器（映射端口 8000）
docker run -d --name infer -p 8000:8000 ascend-infer:1.0

# 3. 健康检查
curl http://localhost:8000/health
```

## 接口说明
| 接口 | 方法 | 说明 |
|------|------|------|
| /health | GET | 健康检查 |
| /infer | POST | 推理（请求体 `{"image": "xxx.jpg"}`） |

## 测试
```bash
curl -X POST http://localhost:8000/infer \
  -H "Content-Type: application/json" \
  -d '{"image": "test.jpg"}'
```
