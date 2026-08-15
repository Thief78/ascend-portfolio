# Day 10 理论笔记：Python OOP / 异常 / 第三方库

## 1. 面向对象：类与对象、__init__、继承、魔术方法

**概念**：类（class）是对象的蓝图，对象是类的实例。`__init__` 是构造方法，创建对象时自动执行，用来初始化属性。`self` 代表实例本身。继承让子类复用父类的属性和方法。魔术方法（如 `__str__`、`__repr__`、`__len__`）是 Python 内置的、以双下划线包裹的特殊方法，定义了对象的内置行为。

**为什么重要**：OOP 的核心是封装——把 API key、请求逻辑、重试策略全部关进一个类里，外部只管调用 `client.chat()`。本案例的 `InferenceClient` 就是典型：数据（api_key、base_url）和操作（chat 方法）打包在一起，换模型、换接口时只需改类内部，调用方无感知。

**踩坑**：`__init__` 里的 `self.xxx` 才是实例属性，类里直接写的 `xxx = ...` 是类属性（所有实例共享）。`__str__` 用于 `print(obj)` 的可读输出，`__repr__` 用于调试输出，两者用途不同。

---

## 2. 异常处理：try/except/finally、自定义异常

**概念**：`try/except` 捕获异常，`finally` 无论是否异常都执行。`except 具体异常类型` 精确捕获，`except Exception as e` 兜底。可以自定义异常类（继承 `Exception`）。`raise` 手动抛异常。

**为什么重要**：调用外部 API 时失败是常态——网络超时、限流、服务端 500、返回格式异常。不处理异常，一个请求失败整个程序崩溃；处理了异常，程序能优雅降级。本案例区分了 Timeout、HTTPError、RequestException、KeyError 四类异常，分别给出不同的错误提示。

**踩坑**：`except:` 不带异常类型会捕获所有异常（包括键盘中断 Ctrl+C），不推荐。`except Exception` 兜底时一定要用 `as e` 拿到异常对象并打印，否则排错时两眼一抹黑。`finally` 里的代码在 return 之前也会执行，适合放清理逻辑。

---

## 3. 第三方库：requests / tqdm / pydantic

**概念**：`requests` 是 HTTP 请求的事实标准——`requests.post(url, json=data, headers=h, timeout=30)` 发 POST，`resp.json()` 解析 JSON 响应，`resp.raise_for_status()` 在状态码非 2xx 时抛异常。`tqdm` 是进度条库，`tqdm(可迭代对象)` 一行代码显示实时进度。`pydantic` 是数据校验库，用类型注解定义数据结构并自动校验。

**为什么重要**：这些是 AI 开发者的标配工具箱。调用任何大模型 API（DeepSeek、通义、OpenAI）都靠 requests；处理批量任务靠 tqdm 显示进度；pydantic 是 FastAPI 的基础。学会这三个库，大部分 AI 应用开发的基础就齐了。

**踩坑**：`requests` 默认不超时，请求可能永远卡住——一定要加 `timeout` 参数。`resp.json()` 在返回非 JSON 内容时会抛异常，要用 try 包住。`tqdm` 包装的对象只能遍历一次，需要重复遍历时先把结果转成 list。

---

## 4. 敏感信息管理：API Key 不硬编码

**概念**：API key、数据库密码等敏感信息不能直接写在代码里，应该通过环境变量（`os.environ.get("KEY")`）或独立配置文件读取，配置文件加入 `.gitignore` 排除在版本控制之外。

**为什么重要**：代码托管到 GitHub 后，一旦 key 泄露，任何人都能用你的账号刷爆额度、盗用服务。即使之后删除，Git 历史里依然保留——最安全的做法是从源头不让 key 进仓库。这也是面试中"你的项目怎么管理密钥"的标准答案。

**踩坑（今天真实踩到的）**：环境变量是进程级的——在 PowerShell 里 `$env:KEY = "xxx"` 只对当前窗口和它启动的子进程生效，独立启动的 PyCharm 读不到。正确做法是在 PyCharm 的 Run Configuration 里配置环境变量，或设置系统级环境变量。已经 push 过的 key 建议直接去服务商后台作废重生成。
