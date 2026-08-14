#!/usr/bin/env python3
"""数据集预处理脚本：批量重命名、分类、生成标注清单。"""
import os
from pathlib import Path

DATA_DIR = Path("./dataset")           # 数据集目录
CLASSES = ["cat", "dog", "bird"]       # 已知类别
OUTPUT_LABEL = "train.txt"             # 输出标注清单

# 1. 扫描目录，收集所有 .jpg 文件
images = sorted(DATA_DIR.glob("*.jpg"))   # glob 匹配所有 jpg，返回 Path 对象

# 2. 分类计数（用 dict 做类别→计数映射）
class_count = {c: 0 for c in CLASSES}     # 字典推导式：{"cat":0, "dog":0, "bird":0}
unknown = []                              # 存放无法识别类别的文件

# 3. 批量重命名 + 分类
label_lines = []                          # 标注清单的每一行
for img in images:
    # 从文件名提取类别（cat_001.jpg → cat）
    stem = img.stem                        # 去掉 .jpg 后缀 → "cat_001"
    cls = stem.split("_")[0]               # 按 _ 分割取第一部分 → "cat"

    if cls in CLASSES:
        class_count[cls] += 1
        # 规范化命名：cat_001.jpg → cat_0001.jpg（4位补零）
        idx = int(stem.split("_")[1])      # 取数字部分
        new_name = f"{cls}_{idx:04d}.jpg"  # :04d = 补零到4位
        img.rename(DATA_DIR / new_name)

        # 生成标注行：图片路径 类别索引（训练框架通用格式）
        label_idx = CLASSES.index(cls)     # cat→0, dog→1, bird→2
        label_lines.append(f"{new_name} {label_idx}")
    else:
        unknown.append(str(img.name))      # 记录无法识别的脏数据

# 4. 写出标注清单
with open(DATA_DIR / OUTPUT_LABEL, "w") as f:
    f.write("\n".join(label_lines) + "\n")

# 5. 打印报告
print("=== 数据集预处理报告 ===")
print(f"总图片数: {len(images)}")
for cls, cnt in class_count.items():
    print(f"  {cls}: {cnt} 张")
print(f"  无法识别: {len(unknown)} 张")
if unknown:
    print(f"  脏数据文件: {unknown}")
print(f"标注清单已生成: {DATA_DIR / OUTPUT_LABEL}")