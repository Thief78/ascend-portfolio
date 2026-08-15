#!/usr/bin/env python3
"""推理结果后处理：读取 JSON 检测输出，生成格式化报表。"""
import json
from pathlib import Path

RESULT_FILE = Path("inference_result.json")
REPORT_FILE = Path("report.txt")
CONF_THRESHOLD = 0.7   # 置信度阈值，低于这个的检测框视为不可靠


def load_result(path: Path) -> dict:
    """读取 JSON 推理结果文件。"""
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)
    # json.load：把 JSON 字符串 → Python 字典


def filter_detections(detections: list, threshold: float) -> list:
    """过滤掉置信度低于阈值的检测框。"""
    return [d for d in detections if d["confidence"] >= threshold]
    # 列表推导式 + 条件过滤：一行完成"筛选"


def classify_count(detections: list) -> dict:
    """统计每类物体出现几次。"""
    counts = {}
    for d in detections:
        cls = d["class"]
        counts[cls] = counts.get(cls, 0) + 1
        # dict.get(key, 默认值)：key 不存在时返回默认值，避免 KeyError
    return counts


def format_report(result: dict, detections: list, counts: dict) -> str:
    """生成格式化文本报表。"""
    lines = []
    lines.append("=" * 50)
    lines.append(f"模型: {result['model']}")
    lines.append(f"图片: {result['image']} ({result['width']}x{result['height']})")
    lines.append(f"推理耗时: {result['inference_time_ms']} ms")
    lines.append("=" * 50)
    lines.append(f"有效检测数: {len(detections)}")
    lines.append("")
    lines.append("【类别统计】")
    for cls, cnt in sorted(counts.items(), key=lambda x: -x[1]):
        # sorted + lambda：按数量降序排列
        lines.append(f"  {cls}: {cnt}")
    lines.append("")
    lines.append("【检测明细】")
    for i, d in enumerate(detections, start=1):
        # enumerate(..., start=1)：从 1 开始编号
        x1, y1, x2, y2 = d["bbox"]
        lines.append(
            f"  {i}. {d['class']:<14} 置信度 {d['confidence']:.2f}  "
            f"框 [{x1},{y1},{x2},{y2}]"
        )
        # :<14 左对齐占14字符；:.2f 保留两位小数
    lines.append("=" * 50)
    return "\n".join(lines)


def main():
    result = load_result(RESULT_FILE)
    dets = filter_detections(result["detections"], CONF_THRESHOLD)
    counts = classify_count(dets)
    report = format_report(result, dets, counts)

    # 同时输出到屏幕和文件
    print(report)
    with open(REPORT_FILE, "w", encoding="utf-8") as f:
        f.write(report + "\n")
    print(f"\n报表已保存: {REPORT_FILE}")


if __name__ == "__main__":
    main()