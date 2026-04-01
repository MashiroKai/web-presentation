# Style Guide — 系统级审美与风格

## 设计哲学

**少即是多。内容为王，设计退后。**

每一像素都应服务于内容传达。没有装饰性元素，没有多余的线条、阴影、渐变。好的设计是透明的——用户感受不到它的存在，却无法离开它。

---

## 核心原则

### 1. 克制 · Restraint

> 克制不是偷懒，是选择。

- 每页只传达**一个**核心观点
- 动画 ≤ 2 个/页，仅用于逻辑展开
- 颜色 ≤ 3 种（主色 + 辅助 + 强调）
- 不用图标库，除非内容本身需要

### 2. 留白 · Whitespace

> 留白不是"空"，是呼吸感。

- 元素间距 ≥ 1.5em
- 页面内容面积 ≤ 60%
- 边距充足，内容不贴边
- 信息密度低 ≠ 内容少，是让每个字都有分量

### 3. 层次 · Hierarchy

> 读者应该在 0.5 秒内知道该看哪里。

- 标题一眼可辨（大小、粗细、颜色三重区分）
- 重点用 **加粗** 或颜色，不用下划线、不用过多强调
- fragment 动画服务于阅读节奏，不炫技
- 大标题 → 副标题 → 正文 → 注释，视觉权重递减

### 4. 一致性 · Consistency

> 一致性是信任的基础。

- 同一演示内，所有页的字体、间距、对齐方式一致
- 相同类型的页面（内容页、过渡页）结构相同
- 颜色语义固定：同一个颜色不跨语义使用
- 如果第 3 页的要点用了蓝色圆点，第 7 页也必须一样

---

## 配色系统

配色由模板定义，系统提示词不规定具体色值。模板需定义以下语义色：

| 语义 | 用途 | 说明 |
|------|------|------|
| 主色 Primary | 标题、导航、强调元素 | 模板的核心色调 |
| 辅助色 Secondary | 注释、页码、次要信息 | 与主色协调 |
| 强调色 Accent | 关键数据、高亮、警示 | 高对比度，谨慎使用 |
| 正文色 Text | 正文、列表文字 | 保证可读性 |
| 背景色 Background | 页面底色 | 通常白色或浅色 |
| 深色背景 Dark | 封面、结束页 | 深色，文字用浅色 |

### 配色铁律（通用）

- **颜色 ≤ 3 种主色**（主色 + 辅助 + 强调）
- **强调色每页 ≤ 2 处**
- **深色背景上的文字**用浅色（非纯白 `#FFFFFF`，推荐柔和浅灰）
- **禁用纯黑 `#000000`**（视觉疲劳，用深灰替代）
- **同一演示内语义一致**：主色不跨语义使用

---

## 字体系统

字体由模板定义，系统提示词只规定结构要求。

### 字体结构要求

每种模板需定义三类字体：

| 类型 | 用途 | 要求 |
|------|------|------|
| 标题字体 | h1, h2, h3 | 粗体，辨识度高 |
| 正文字体 | 段落、列表 | 清晰易读 |
| 代码字体 | 代码块 | 等宽字体 |

### 字号参考（基于 1920×1080）

| 元素 | 字号 | 字重 | 说明 |
|------|------|------|------|
| 大标题 h1 | 2.4em | 700 | 封面、结束页 |
| 页面标题 h2 | 1.6em | 700 | 内容页主标题 |
| 小标题 h3 | 1.0em | 600 | 段落标题 |
| 正文 | 0.9em | 400 | 主体内容 |
| 注释/页码 | 0.75em | 400 | 辅助信息 |
| 代码块 | 0.72em | 400 | 代码展示 |

### 字体铁律（通用）

- 标题 `letter-spacing: -0.02em`（更紧凑）
- 正文 `line-height: 1.8–2.0`（呼吸感）
- **不用斜体强调** — 用加粗或颜色替代

---

## 布局系统

### 居中铁律

**所有页面内容必须水平+垂直居中，四边留白均匀。**

每页 HTML 必须用居中容器包裹所有内容：

```html
<section>
  <div style="max-width:70%; margin:0 auto; text-align:center;">
    <!-- 所有页面内容放这里 -->
  </div>
</section>
```

**禁止直接在 `<section>` 下放置未包裹的内容。** 除非是封面/结束页等特殊设计。

- `max-width:70%` — 内容不超过画布宽度的 70%，左右各留 15%
- `margin:0 auto` — 水平居中
- `text-align:center` — 文字居中
- reveal.js `center: true` — 垂直居中
- CSS `padding: 5% 10%` — 额外安全边距

### 页面类型

| 类型 | 布局 | 场景 |
|------|------|------|
| **封面** | 居中 + 深色背景 | 第一页 |
| **内容页** | 居中容器 + 标题居中 + 列表居中对齐 | 主体内容 |
| **分栏页** | flex 左右分栏（内容居中） | 图文并排 |
| **过渡页** | 居中大字 | 章节切换 |
| **结束页** | 居中 + 深色背景 | 最后一页 |

### 间距系统

```css
/* 标题 → 内容 */
margin-bottom: 1em;

/* 要点之间 */
line-height: 2.0;

/* 页面边距 (Reveal.js) */
margin: 0.04;  /* ≈ 4% */
```

---

## 内容溢出防护

**每页内容必须严格在幻灯片画布内，不能溢出。** 这是硬性约束。

### CSS 防护

```css
.reveal .slides section {
  overflow: hidden !important;
  max-width: 100% !important;
  max-height: 100% !important;
  box-sizing: border-box !important;
}
.reveal .slides section > * {
  max-width: 100%;
  box-sizing: border-box;
}
.reveal pre {
  max-height: 70vh !important;
  overflow: auto !important;
}
```

### 内容上限

**16:9 / 1920×1080：**

| 元素 | 上限 |
|------|------|
| 标题 | ≤ 2 行 |
| 要点 | ≤ 6 条 |
| 正文行 | ≤ 8 行 |
| 代码块 | ≤ 15 行（超出用滚动） |
| 图表 | ≤ 画布 50% 面积 |

**4:3 / 1440×1080：**

内容区更窄，要点 ≤ 5 条，每行字数更少。

---

## 导航与进度条

### 底部居中导航按钮

reveal.js 默认箭头已隐藏，使用自定义底部居中圆形按钮。

```html
<div class="nav-controls">
  <button class="nav-btn" id="prevBtn" onclick="Reveal.prev()">‹</button>
  <button class="nav-btn" id="nextBtn" onclick="Reveal.next()">›</button>
</div>
```

```css
.nav-controls {
  position: fixed;
  bottom: 36px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 12px;
  z-index: 200;
}
.nav-btn {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  border: 1.5px solid var(--nav-color, #2E5C8A);
  background: rgba(255,255,255,0.92);
  color: var(--nav-color, #2E5C8A);
  font-size: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
}
.nav-btn:hover {
  background: var(--nav-color, #2E5C8A);
  color: #fff;
}
.nav-btn:disabled {
  opacity: 0.2;
  cursor: not-allowed;
}
```

**颜色自定义：** 通过 CSS 变量 `--nav-color` 和 `--nav-color-secondary` 控制，默认蓝灰色系。

### 进度条

底部渐变进度条，显示当前页码/总页码。

```html
<div class="progress-bar" id="progressBar"></div>
```

```css
.progress-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--nav-color, #2E5C8A), var(--nav-color-secondary, #5A7D9A));
  transition: width 0.4s ease;
  z-index: 200;
}
```

**JS 更新逻辑：**
```javascript
function updateUI() {
  var idx = Reveal.getIndices();
  var total = Reveal.getTotalSlides();
  var cur = idx.h + 1;
  document.getElementById('progressBar').style.width = (cur / total * 100) + '%';
  document.getElementById('prevBtn').disabled = (cur <= 1);
  document.getElementById('nextBtn').disabled = (cur >= total);
}
Reveal.on('slidechanged', updateUI);
Reveal.on('ready', updateUI);
```

---

## 动画系统

### 可用动画

| 动画 | 效果 | 用途 |
|------|------|------|
| `fragment fade-in` | 淡入 | 逐条展开（最常用） |
| `fragment highlight-red` | 红色高亮 | 关键数据强调 |
| `data-transition="fade"` | 页间淡入淡出 | 推荐全局过渡 |

### 动画铁律

- 每页 fragment ≤ 4 个
- **禁用** `grow`、`shrink`、`zoom` — 过于花哨
- 页间过渡全局用 `fade`，不用 `slide`、`convex`
- 速度用默认或 `slow`，不用 `fast`
- 动画是为内容服务的，不是用来炫技的

---

## 深色背景页

用于封面和结束页，营造仪式感和呼吸感。

```html
<section data-transition="fade" data-background-color="var(--bg-dark, #1D1D1F)">
  <h1 style="color:var(--text-on-dark, #F5F5F7); font-size:2.4em;">标题</h1>
  <p style="color:var(--text-secondary, #86868B); font-size:1.0em;">副标题</p>
</section>
```

**规则：**
- 背景：`#1D1D1F`（近黑）
- 标题：`#F5F5F7`（浅灰白）
- 副标题：`#86868B`（灰）
- **不在深色页上放代码块或图表** — 可读性差

---

## 代码展示

```html
<pre><code class="language-python" data-trim data-noescape>
def example():
    return "hello"
</code></pre>
```

- 代码字体：SF Mono / Menlo
- 语法高亮主题：monokai（与浅色背景对比度高）
- 代码字号比正文小 1–2 级
- 过长代码截断，只展示关键部分
- 关键行可用 `highlight` 标记

---

## 公式

使用 KaTeX：行内 `$...$`，块级 `$$...$$`

- 公式字号与正文一致
- 不单独为公式设置样式
- 公式颜色继承正文色
- 复杂公式拆成多步，配合 fragment 逐行展示

---

## 资源管理

`assets/` 存放演示中直接引用的资源文件：

| 资源类型 | 示例 | 说明 |
|----------|------|------|
| 图片 | `assets/figures/diagram.png` | 插图、照片、截图 |
| SVG 图 | `assets/icons/wave.svg` | 矢量图、图解 |
| 数据文件 | `assets/data/chart-data.json` | 图表数据源 |
| 字体 | `assets/fonts/custom.woff2` | 自定义字体（非必须） |
| 视频 | `assets/media/demo.mp4` | 嵌入视频（非必须） |

### 使用规则

- **图片优先 SVG** — 矢量、清晰、体积小
- 位图用 PNG（图表）或 WebP（照片），**不用 JPG**
- 图片尺寸适配 1280×720，不超分
- 所有资源通过相对路径引用：`src="assets/figures/xxx.png"`
- 不在 assets 里放代码或 HTML

### 命名规范

- 小写英文 + 连字符：`bloch-sphere.svg`
- 按类型建子目录：`assets/figures/`、`assets/icons/`
- **不用中文文件名**
