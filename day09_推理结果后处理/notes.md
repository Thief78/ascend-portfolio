# Day 9 理论笔记：Python 函数 / 模块 / 文件

## 1. 函数参数：位置 / 关键字 / 默认 / *args / **kwargs

**概念**：位置参数按顺序传参，关键字参数按名字传参，默认参数给参数设默认值。`*args` 收集多余的位置参数（变成 tuple），`**kwargs` 收集多余的关键字参数（变成 dict）。`lambda` 是匿名函数，`lambda x: x+1` 等价于一个简单的单行函数。作用域 LEGB：Local（函数内）→ Enclosing（外层函数）→ Global（模块级）→ Built-in（内置），变量按这个顺序查找。

**为什么重要**：函数是代码复用的基本单位。默认参数让调用方少传参，`*args/**kwargs` 让你写"转发型"函数（比如包装器）时不用一一列举参数。`lambda` 常用在 `sorted(key=lambda...)` 这类"临时需要一个简单函数"的场景。

**踩坑**：默认参数不要用可变对象（如 `def f(lst=[])`）——列表在函数定义时就创建了，多次调用会共享同一个列表，产生诡异的累积 bug。`lambda` 写复杂逻辑会牺牲可读性，超过一行就别用。

---

## 2. 模块与包：import / __name__ / __init__.py

**概念**：`import 模块` 或 `from 模块 import 名字` 导入代码。`if __name__ == "__main__":` 判断"是直接运行还是被导入"——直接运行时 `__name__` 是 `"__main__"`，被导入时是模块名。`__init__.py` 让一个目录变成可导入的包。

**为什么重要**：模块化是工程的基石——把代码拆成多个文件，各司其职。`__name__` 守卫让同一份代码既能当脚本跑、又能当库被导入，且导入时不产生副作用。

**踩坑**：循环导入（A 导入 B，B 又导入 A）会报错或产生 None。相对导入 `from .utils import x` 只能在包内用，入口脚本里必须用绝对导入。

---

## 3. 标准库：os / sys / json / pathlib / subprocess

**概念**：`os` 操作系统接口（路径、环境变量、进程），`sys` 系统参数（`sys.argv` 命令行参数），`json` JSON 序列化/反序列化（`json.load` 读文件、`json.loads` 读字符串、`json.dump` 写文件、`json.dumps` 转字符串），`pathlib.Path` 面向对象的路径操作（比 `os.path` 更现代），`subprocess` 执行外部命令。

**为什么重要**：这些是"不用 pip 安装就能用"的标配工具箱。处理 JSON 是 AI 推理后处理的刚需——模型 API 的输入输出几乎全是 JSON。`pathlib` 让你的脚本跨平台（Windows/Linux 通用）。

**踩坑**：`json.load` 和 `json.loads` 一个读文件一个读字符串，别搞混。`Path("data") / "a.json"` 用 `/` 拼接路径，比字符串拼接 `"data/" + "a.json"` 更安全（自动处理斜杠差异）。中文写入 JSON 时默认会转义成 `\uXXXX`，要保留中文用 `json.dump(..., ensure_ascii=False)`。

---

## 4. 文件操作：open / 读写模式 / with / JSON-YAML

**概念**：`open(文件, 模式)` 打开文件，模式 `r` 读、`w` 写（覆盖）、`a` 追加、`rb/wb` 二进制模式。`with open(...) as f:` 上下文管理器——代码块结束自动关闭文件，即使中途报错也保证关闭。JSON 处理见上，YAML 用 `pyyaml` 库（`yaml.safe_load`）。

**为什么重要**：数据处理流程 = 读文件 → 处理 → 写文件。`with` 是 Python 的标准写法，避免忘记 `close()` 导致的文件句柄泄漏。JSON 是模型推理、API 交互的标准格式，YAML 是配置文件的标准格式。

**踩坑**：`w` 模式会清空原文件内容，要保留原内容用 `a` 追加。读取大文件不要用 `f.read()` 一次全读进内存，用 `for line in f:` 逐行处理。Windows 上文件路径反斜杠要写成 `r"D:\path"` 或正斜杠 `"D:/path"`，否则 `\t` `\n` 会被当转义符。
