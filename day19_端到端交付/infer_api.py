#!/usr/bin/env python3
"""推理 HTTP 服务：POST /infer 接收数据，返回分类结果。"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import random

CLASSES = ["cat", "dog", "bird", "car", "person"]

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self._reply(200, {"status": "ok", "service": "ascend-infer-api"})
        else:
            self._reply(404, {"error": "not found"})

    def do_POST(self):
        if self.path == "/infer":
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length).decode()
            try:
                data = json.loads(body)
                img = data.get("image", "unknown")
            except json.JSONDecodeError:
                self._reply(400, {"error": "invalid JSON"})
                return
            self._reply(200, {
                "image": img,
                "output": random.choice(CLASSES),
                "confidence": round(random.uniform(0.8, 0.99), 3),
            })
        else:
            self._reply(404, {"error": "not found"})

    def _reply(self, code, data):
        body = json.dumps(data, ensure_ascii=False).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass

if __name__ == "__main__":
    print("昇腾推理服务已启动，监听 8000")
    HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
