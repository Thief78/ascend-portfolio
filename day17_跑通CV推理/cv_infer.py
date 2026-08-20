#!/usr/bin/env python3
"""CV 图片分类推理：用预训练 ResNet18 对图片做分类，记录耗时。"""
import time
import torch
import torchvision
from torchvision import transforms
from PIL import Image

# 1. 加载预训练模型（第一次运行会自动下载权重，约 45MB）
print("加载预训练 ResNet18 ...")
model = torchvision.models.resnet18(weights=torchvision.models.ResNet18_Weights.IMAGENET1K_V1)
model.eval()   # 切换到推理模式（关闭 dropout 等训练专用行为）

# 2. 准备一张测试图片
# 生成一个彩色渐变图（真实场景应换成你的图片）
import numpy as np
arr = np.zeros((224, 224, 3), dtype=np.uint8)
arr[:, :, 0] = np.linspace(0, 255, 224).reshape(-1, 1)   # 红色渐变
img = Image.fromarray(arr)

# 3. 预处理：图片 → 模型要求的张量格式
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])
input_tensor = preprocess(img).unsqueeze(0)   # 增加 batch 维度：[1, 3, 224, 224]

# 4. 推理并计时
print("开始推理 ...")
start = time.time()
with torch.no_grad():   # 不计算梯度，推理时省内存加速
    output = model(input_tensor)
elapsed = time.time() - start

# 5. 解析结果
probabilities = torch.nn.functional.softmax(output[0], dim=0)
top5_prob, top5_idx = torch.topk(probabilities, 5)

# ImageNet 类别标签
labels = torchvision.models.ResNet18_Weights.IMAGENET1K_V1.meta["categories"]

print(f"\n=== 推理结果 ===")
print(f"输入: 224x224 彩色图")
print(f"耗时: {elapsed:.3f} 秒")
print(f"Top-5 预测:")
for i in range(5):
    print(f"  {i+1}. {labels[top5_idx[i]]}: {top5_prob[i]:.3f}")
