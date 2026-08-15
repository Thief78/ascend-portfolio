#!/usr/bin/env python3
"""推理 API 客户端：调用 DeepSeek 大模型接口，带异常处理和进度条。"""
import time
import requests
from tqdm import tqdm
import os


class InferenceClient:
    """封装大模型 API 调用。"""

    def __init__(self, api_key: str, base_url: str = "https://api.deepseek.com"):
        self.api_key = api_key
        self.base_url = base_url.rstrip("/")

    def chat(self, prompt: str, model: str = "deepseek-chat", max_tokens: int = 200) -> str:
        """发送一条消息，返回模型回复文本。"""
        url = f"{self.base_url}/chat/completions"
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        }
        payload = {
            "model": model,
            "messages": [{"role": "user", "content": prompt}],
            "max_tokens": max_tokens,
        }

        # 异常处理：区分超时和其他请求错误
        try:
            resp = requests.post(url, json=payload, headers=headers, timeout=30)
            resp.raise_for_status()
            data = resp.json()
            return data["choices"][0]["message"]["content"]
        except requests.exceptions.Timeout:
            return "[错误] 请求超时（30秒无响应）"
        except requests.exceptions.HTTPError as e:
            return f"[错误] HTTP 状态码异常: {resp.status_code}"
        except requests.exceptions.RequestException as e:
            return f"[错误] 请求失败: {e}"
        except (KeyError, IndexError):
            return "[错误] 返回格式异常，无法解析回复内容"


def batch_infer(client: InferenceClient, prompts: list[str]) -> list[str]:
    """批量推理：遍历多个 prompt，显示进度条。"""
    results = []
    for p in tqdm(prompts, desc="批量推理中"):
        # tqdm 包装可迭代对象，自动显示进度条
        results.append(client.chat(p))
        time.sleep(0.5)   # 模拟间隔，避免触发限流（也让你看清进度条）
    return results


def main():
    # 从环境变量读取，代码里不出现真实 key
    API_KEY = os.environ.get("DEEPSEEK_API_KEY", "")
    if not API_KEY:
        print("请先设置环境变量：$env:DEEPSEEK_API_KEY = '你的key'")
        exit(1)

    client = InferenceClient(API_KEY)

    # 单次调用
    print("=== 单次调用测试 ===")
    reply = client.chat("用一句话解释什么是昇腾NPU")
    print(f"模型回复: {reply}\n")

    # 批量调用（带进度条）
    print("=== 批量调用测试 ===")
    prompts = [
        "1+1等于几？",
        "用一句话介绍Python",
        "什么是Docker？",
        "昇腾AI芯片的核心优势是什么？",
    ]
    replies = batch_infer(client, prompts)
    for p, r in zip(prompts, replies):
        print(f"\nQ: {p}\nA: {r}")


if __name__ == "__main__":
    main()