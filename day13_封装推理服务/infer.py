#!/usr/bin/env python3
"""简易推理服务——模拟模型加载和推理。"""
import json
import random
import time

CLASSES = ["cat", "dog", "bird", "car", "person"]

def main():
    print("Loading model...")
    time.sleep(2)   # 模拟模型加载
    print("Model loaded. Running inference...\n")

    result = {
        "model": "mock-classifier",
        "output": random.choice(CLASSES),
        "confidence": round(random.uniform(0.80, 0.99), 3),
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
