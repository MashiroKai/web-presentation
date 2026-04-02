# 从现有 PPT 提取模板 — Agent 操作指南

> 用户提供一个已有的 .pptx 文件，Agent 提取其设计风格，生成 `模板.md`，然后用这个模板生成新的演示。

---

## 触发条件

用户表达类似以下意图时触发：
- "参考这个 PPT 的风格做一个新的"
- "我喜欢这个 PPT 的模板，帮我提取出来"
- "照着这个 PPT 的样子做"
- "帮我从这个 PPT 里提取设计模板"

---

## 工作流程

```
用户提供 .pptx 文件
    ↓
Step 1: 提取结构化数据（脚本）
    ↓
Step 2: 视觉分析（截图 + Agent 观察）
    ↓
Step 3: 生成模板.md（综合提取结果 + 视觉判断）
    ↓
Step 4: 用户确认模板
    ↓
Step 5: 用新模板生成演示
```

---

## Step 1: 运行提取脚本

```bash
python3 <SKILL_DIR>/scripts/extract_pptx.py <file.pptx> <output-dir>
```

输出 `extracted-style.json`，包含：
- `slide_size` — 幻灯片尺寸和比例
- `colors` — 主题配色方案（accent1-6, dark, light 等）
- `fonts` — 字体方案（标题/正文的英文字体和 CJK 字体）
- `layouts` — 布局类型列表（标题页、内容页、两栏等）
- `slide_analyses` — 每页的元素类型（文字/图片/图表/表格）和动画信息
- `slide_count` — 总页数

---

## Step 2: 视觉分析

脚本只能提取结构化数据，无法捕获完整的视觉效果。需要**截图辅助判断**：

### 2.1 用 LibreOffice 或在线工具将 PPT 转为图片

```bash
# 方法一：LibreOffice（如果已安装）
libreoffice --headless --convert-to png <file.pptx>

# 方法二：Python (如果有 python-pptx)
python3 -c "
from pptx import Presentation
from pptx.util import Inches
# 需要额外安装: pip install python-pptx Pillow
"
```

如果以上都不可用，让用户提供 PPT 截图（至少封面、内容页、图表页、结束页各一张）。

### 2.2 Agent 观察截图并判断

观察以下要素，补充到模板中：

| 观察项 | 需要判断的内容 |
|--------|---------------|
| 整体氛围 | 严肃/活泼/科技感/文艺？ |
| 对齐方式 | 居中？左对齐？分栏？ |
| 标题样式 | 有无装饰线？字号比例？位置？ |
| 列表样式 | 圆点/数字/自定义？缩进？ |
| 背景处理 | 纯色/渐变/图案/全幅图片？ |
| 动画倾向 | 有无动画？克制还是丰富？ |
| 留白程度 | 密集还是大量留白？ |
| 特殊元素 | Logo 位置、页码样式、导航等 |

---

## Step 3: 生成模板.md

综合 Step 1 的数据和 Step 2 的视觉判断，生成符合 `templates/` 目录格式的模板文件。

### 模板映射规则

| 提取数据 | 模板字段 | 映射说明 |
|----------|----------|----------|
| `colors.accent1-6` | 配色表 | 映射到主色/辅助色/强调色，选择最突出的 2-3 个 |
| `colors.dark1/light1` | 深色/浅色背景 | 映射到背景色 |
| `fonts.heading` | 标题字体 | 直接映射 |
| `fonts.body` | 正文字体 | 直接映射 |
| `slide_size.ratio` | 幻灯片尺寸 | 16:9 或 4:3 |
| `layouts` 列表 | 布局偏好 | 从布局名称推断页面结构 |
| `slide_analyses[].animation_count` | 动画风格 | 平均值判断克制/丰富 |
| `slide_analyses[].bg_color` | 深色背景页 | 判断哪些页用深色 |

### 命名建议

基于提取的设计语言给模板命名：
- 如果配色偏蓝/灰 + 严谨布局 → `学术-公司品牌`
- 如果暗色背景 → `科技-深色系`
- 如果暖色调 → `商务-暖色`
- 用户可自定义名称

### 生成示例

```markdown
# 模板：（从PPT提取的风格）

## 场景
基于用户提供的 PPT 提取。原始场景：（根据内容推断）

## 设计语言
（根据视觉分析写一句话）

## 配色

| 语义 | 色值 | 用途 |
|------|------|------|
| 主色 | `#(accent值)` | 标题、强调 |
| 辅助色 | `#(accent值)` | 注释、次要信息 |
| 强调色 | `#(accent值)` | 关键数据 |
| 正文色 | `#(dk1或dk2值)` | 正文文字 |
| 背景 | `#(lt1值)` | 页面底色 |
| 深色背景 | `#(dk1值)` | 封面、结束页 |

## 字体

| 元素 | 字体 | 字重 |
|------|------|------|
| 标题 | (heading字体), fallback | 700 |
| 正文 | (body字体), fallback | 400 |
| 代码 | SF Mono, Menlo | 400 |

## 布局偏好
- **封面** — （根据截图描述）
- **内容页** — （根据截图描述）
- **过渡页** — （根据截图描述）
- **结束页** — （根据截图描述）

## 动画风格
- **进入** — （根据分析数据判断）
- **页间过渡** — fade
- **限制** — 每页 ≤ X 个 fragment

## 特殊要求
（Logo、页码、公式支持等）
```

---

## Step 4: 用户确认

将生成的模板展示给用户，询问：
1. 配色是否准确？
2. 字体是否合适？（OOXML 字体名可能需要映射到 Web 安全字体）
3. 布局理解是否正确？
4. 是否需要调整？

用户确认后，保存模板到 `templates/` 目录。

---

## Step 5: 用新模板生成演示

模板确认后，按正常工作流程用这个模板生成演示。

---

## 常见问题

### Q: 用户提供的是 .ppt 格式怎么办？

.ppt 是旧格式，不如 .pptx 可靠。建议用户转换为 .pptx 后再提供。LibreOffice 可以转换：
```bash
libreoffice --headless --convert-to pptx <file.ppt>
```

### Q: OOXML 的 schemeClr 是什么意思？

`schemeClr` 是主题色引用（如 accent1、dk1），不是具体颜色值。脚本会提取主题色的实际定义（在 theme1.xml 中），你可以在 `extracted-style.json` 的 `colors` 字段看到映射后的 hex 值。

### Q: 提取的字体是 Windows 字体，怎么映射到 Web 字体？

| PPT 常见字体 | Web 安全替代 |
|-------------|-------------|
| Calibri | -apple-system, sans-serif |
| Cambria | Georgia, serif |
| Arial | Arial, sans-serif |
| Times New Roman | Times New Roman, serif |
| 微软雅黑 | PingFang SC, Microsoft YaHei, sans-serif |
| 宋体 | SimSun, serif |

### Q: 用户只给了截图没有 .pptx 怎么办？

可以只做 Step 2（视觉分析）+ Step 3（生成模板），跳过 Step 1。准确性会略低，但足够创建一个近似模板。
