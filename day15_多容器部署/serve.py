#!/usr/bin/env python3
"""简易推理 HTTP 服务——监听 8000，返回推理结果 JSON。"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import random

CLASSES = ["cat", "dog", "bird"]

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        result = {
            "model": "mock-classifier",
            "output": random.choice(CLASSES),
            "confidence": round(random.uniform(0.8, 0.99), 3),
        }
        body = json.dumps(result, ensure_ascii=False).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass   # 关闭默认日志，保持输出干净

if __name__ == "__main__":
    HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
