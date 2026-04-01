---
name: web-presentation
description: "Create web-based slide presentations using HTML with reveal.js. Triggers on: PPT, slides, presentation, demo, talk, report, 做PPT, 做ppt, 做演示, 演示文稿, 幻灯片, 网页展示. IMPORTANT: When user says '做PPT' or 'PPT', they mean web-based HTML presentation, NOT PowerPoint. Supports academic, tech-talk, project-review, and custom styles via template system. Output is a folder with index.html plus separate page files for easy per-page editing. Auto-exports PDF after completion."
---

# Web Presentation

Build HTML presentations that look and feel like PPT. Pure web, no PowerPoint.

**重要：用户说"做PPT"或"PPT"时，默认指网页演示，不是 Microsoft PowerPoint。**

---

## ⚠️ MANDATORY RULES — DO NOT SKIP

**这些规则必须在每次制作前执行，跳过任何一条都是错误。**

### Rule 1: 幻灯片尺寸

**默认 16:9 (1920×1080)**，不需要询问用户。

如果用户明确提到 **4:3**，则使用 4:3 (1440×1080)。
否则一律使用 16:9，无需确认。

### Rule 2: 主动提问，确认方案后才动手

**核心原则：先沟通，再动手。** 不要直接开始制作，必须先理解并确认用户的真实需求。

**提问流程：**

```
用户提出需求
    ↓
分析需求完整度
    ↓
需求模糊？→ 主动提问（见下表）
    ↓
需求明确？→ 呈现方案供确认
    ↓
用户确认 → 开始制作
```

**必须问清楚的内容（需求模糊时）：**
| 问题 | 目的 |
|------|------|
| 核心主题/论文是什么？ | 确定内容方向 |
| 目标受众是谁？ | 确定难度和语言风格 |
| 演讲时长多少？ | 确定页数 |
| 必须包含的关键点？ | 不遗漏重要内容 |
| 参考材料有没有？ | 充实内容 |
| 风格偏好？ | 模板选择 |

**需求明确时也要呈现方案：**
即使用户需求很清晰，也要在动手前展示：
1. 选用的模板及理由
2. 内容大纲（每页做什么）
3. 布局/动画的初步想法

让用户确认方案后再执行。如果用户说"你看着办"，可以跳过确认直接制作，但做完后要展示结果。

### Rule 3: 内容不超画布

所有页面内容必须严格在幻灯片画布内，不能溢出。文字不能太小（可读性），也不能太大（不能滚动）。

### Rule 4: 布局自由度

**居中布局是推荐的默认方案**（大多数场景都合适），但不是铁律。根据模板偏好和内容类型，可以使用左对齐、分栏、全幅背景等布局。

```html
<!-- 推荐：居中方案（安全、通用） -->
<section>
  <div style="max-width:70%; margin:0 auto; text-align:center;">
    <!-- 内容 -->
  </div>
</section>
```

- 模板有明确布局偏好的 → 优先遵循模板
- 用户有明确偏好的 → 优先用户需求
- 没有特殊要求 → 默认居中

**唯一铁律：** 内容不超出画布，且视觉上整洁有序。

### Rule 5: 必须生成最终交付物

完成页面制作后，**必须执行以下两步**，不能跳过：

```bash
# 1. 生成双击可打开的 index.html（内联所有页面，不覆盖源文件）
bash <SKILL_DIR>/scripts/build.sh <project-dir>

# 2. 导出 PDF（自动先 build，输出到 <project-dir>/presentation.pdf）
bash <SKILL_DIR>/scripts/export-pdf.sh <project-dir>
```

**最终交付清单（缺一不可）：**
- `<project-dir>/pages/*.html` — 可编辑的源页面文件
- `<project-dir>/build/index.html` — 双击可打开的独立 HTML（需联网加载 CDN 资源）
- `<project-dir>/presentation.pdf` — PDF 版本

---

## Project Paths

| 类型 | 相对路径 | 用途 |
|------|----------|------|
| 工程目录 | `/projects/<project-name>/` | 开发中的项目文件 |
| 交付目录 | `/output/<project-name>/` | 成品 HTML + PDF |

**所有项目统一放在 `/projects/` 下。**

---

## Quick Start

### 1. Check Dependencies

```bash
bash <SKILL_DIR>/scripts/check_deps.sh
```

Checks git, python3, curl, node. Missing deps auto-installed.

### 2. Initialize Project

```bash
bash <SKILL_DIR>/scripts/init_project.sh <project-name> <template> [output-dir]
```

Creates project with index.html, pages/, style.css, project-index.md, manifest.json.

### 3. Build (Self-Contained)

After editing pages, build a standalone index.html that works by double-clicking (no server needed):

```bash
bash <SKILL_DIR>/scripts/build.sh <project-dir>
```

Inlines all pages + CSS into a single index.html.

### 4. Export PDF

Export presentation as PDF (each slide with all animations revealed):

```bash
bash <SKILL_DIR>/scripts/export-pdf.sh <project-dir> [output.pdf]
```

Requires node + puppeteer (auto-installed).

## Workflow

Adapt to user's starting point:

| User brings... | Start from... |
|---|---|
| Just an idea | Full workflow |
| Content outline | Template matching |
| Partial content | Fill gaps |
| Existing project | Edit pages |
| **Existing .pptx file** | **Extract template → Generate** |

**Full workflow:**

1. **需求沟通** — 主题、受众、时长、关键内容、风格偏好。**需求不明确时必须提问。**
2. **幻灯片尺寸** — 默认 16:9 (1920×1080)。仅当用户明确提到 4:3 时使用 4:3。
3. **选择模板** — 从 `templates/` 中匹配最合适的模板。
4. **方案呈现** — 向用户展示：模板选择 + 内容大纲 + 布局/动画思路。**等待确认。**
5. **确认后动手** — 用户确认方案后才开始生成页面。
6. **Build** — 生成 pages/*.html + index.html。每个页面独立 `pages/XX-name.html`。更新 `PAGE_MANIFEST`。
7. **Preview** — 启动本地服务器并自动打开浏览器：
   ```bash
   cd <project-dir> && python3 dev-server.py &
   ```
   然后用浏览器打开 `http://localhost:8000`。如果端口被占用，换 8001/8002 等。
8. **Polish** — 动画、单页调整、内容溢出检查。风格和动画遵循模板偏好，模板未指定时参考 `system-prompt/style-guide.md`。
9. **Export PDF** — **必须执行：** `bash <SKILL_DIR>/scripts/export-pdf.sh <project-dir>` → 生成 `presentation.pdf`
10. **Deliver** — 确认交付清单完整：
    - `<project-dir>/pages/*.html` — 可编辑源文件
    - `<project-dir>/build/index.html` — 双击可打开的独立 HTML
    - `<project-dir>/presentation.pdf` — PDF 版本

**注意：开发预览用 dev-server.py（HTTP 服务器），不需要 build.sh 内联。** build.sh 仅用于需要单文件离线分发的场景，且输出到 `build/` 目录，不覆盖源文件。

### 自动预览（必须执行）

任务完成后，**必须自动启动服务器并打开浏览器**：

```bash
# 在项目目录启动 dev server（后台运行）
cd <project-dir> && python3 dev-server.py &
```

然后打开 `http://localhost:8000` 让用户直接看到效果。

如果端口被占用（Address already in use），换一个端口：
```bash
python3 dev-server.py 8001 &
```

### Slide Size Rules
- **默认 16:9** (1920×1080)，无需询问
- 仅当用户明确提到 4:3 时，使用 4:3 (1440×1080)
- All page content **MUST fit within** the slide canvas — no overflow
- Set `SLIDE_RATIO=4:3` when calling `init_project.sh`（默认 16:9 不需要设置）

### Active Questioning
When requirements are unclear, **stop and ask** before building. Use structured questions:
- Core message / thesis?
- Target audience and their background?
- Duration / number of slides?
- Key sections or must-include content?
- Any reference materials or existing content?
- Style preference (formal academic / modern tech / minimal)?

Present options clearly and wait for confirmation.

## Project Structure

```
project/
├── project-index.md    # Project map (READ THIS FIRST)
├── manifest.json       # Metadata
├── index.html          # Build output (self-contained) or controller
├── pages/              # One file per slide (development)
│   ├── 01-title.html
│   └── ...
├── style.css           # Global styles
├── presentation.pdf    # PDF export (after export-pdf.sh)
└── assets/             # Images, charts
```

## Project Index (Critical)

**Always read `project-index.md` first.** It maps every file, purpose, and edit frequency.

## Editing Pages

Each page is a `<section>` in its own HTML file. Edit one without touching others:

```html
<!-- pages/03-method.html -->
<section>
  <h2>Page Title</h2>
  <ul>
    <li class="fragment">Point one</li>
    <li class="fragment">Point two</li>
  </ul>
</section>
```

Rules:
- One `<section>` per file
- `class="fragment"` for step-by-step reveal
- No framework code — index.html handles everything

## Design Principles

设计优先级：**用户需求 > 模板偏好 > 系统默认参考**

详见 `system-prompt/style-guide.md`，它定义了最低美学标准和设计参考，但不强制具体设计选择。模板和用户需求才是最终指南。

## Templates

See `<SKILL_DIR>/templates/`. All templates inherit from the style guide.

| Template | Scenario |
|---|---|
| academic.md | Academic presentations |
| tech-talk.md | Tech sharing, dark theme |
| project-review.md | Project progress |
| minimal.md | Clean, minimal |

### Custom Template Creation

用户可以创建自己的模板。详见 `<SKILL_DIR>/templates/CUSTOM-TEMPLATE-GUIDE.md`。

**当用户表达想要自定义风格时，Agent 应主动引导：**

1. 了解用户的审美偏好（色调、氛围、布局倾向）
2. 推荐最接近的内置模板作为起点
3. 逐步引导用户完善每个部分（配色、字体、布局、动画）
4. 生成模板文件保存到 `templates/` 目录
5. 用户确认后，后续演示可直接引用

**引导话术示例：**
```
想创建自己的模板？我来帮你。

先告诉我几个关键信息：
1. 你喜欢什么色调？（暖色/冷色/暗色/亮色）
2. 整体氛围是什么感觉？（严肃、活泼、科技感、文艺……）
3. 有参考的设计吗？（某个网站、App、或者你喜欢的风格）
4. 布局偏好？（居中为主 / 左对齐为主 / 自由）

我会根据你的描述生成一个模板，你可以逐项调整。
```

See `system-prompt/templates-guide.md` for custom templates.

### Extract Template from Existing PPT

用户可以提供已有的 .pptx 文件，Agent 提取其设计风格生成模板。

**触发表达：** "参考这个 PPT 的风格"、"照着这个做"、"帮我提取模板"

**工作流程：**

```
用户提供 .pptx 文件
    ↓
1. 运行提取脚本（配色、字体、布局、动画）
    ↓
2. 视觉分析（截图观察 + Agent 判断）
    ↓
3. 生成模板.md（综合数据 + 视觉判断）
    ↓
4. 用户确认模板
    ↓
5. 用新模板生成演示
```

**关键步骤：**

1. **运行脚本** 提取结构化数据：
   ```bash
   python3 <SKILL_DIR>/scripts/extract_pptx.py <file.pptx> <output-dir>
   ```
   输出 `extracted-style.json`，包含配色方案、字体方案、布局类型、每页动画/元素分析。

2. **视觉补充** — 脚本无法捕获完整视觉效果。需要截图辅助：
   - 让用户至少提供封面、内容页、图表页、结束页的截图
   - 或用 LibreOffice 转图片：`libreoffice --headless --convert-to png <file.pptx>`
   - Agent 观察截图判断：整体氛围、对齐方式、留白程度、标题装饰等

3. **生成模板** — 综合 Step 1 + Step 2，按 `templates/` 目录格式生成模板.md
   - 配色：从 theme 的 accent1-6 中选 2-3 个最突出的
   - 字体：映射 OOXML 字体名到 Web 安全字体栈
   - 布局：从截图判断对齐/分栏方式
   - 动画：从 slide_analyses 的 animation_count 判断克制/丰富

4. **用户确认** → 保存到 `templates/` 目录

详细操作指南见 `<SKILL_DIR>/templates/EXTRACT-FROM-PPT.md`。

## Page Types

See `system-prompt/page-types.md` for all page type HTML structures.

## Architecture

See `system-prompt/architecture.md` for index.html internals and loading mechanism.

## Bilingual

All templates and page types support Chinese and English.

---

## 🌐 网络素材检索 (Web Asset Sourcing)

**从互联网检索专业视觉素材，全程自动化，无需人工介入。**

### 核心原则

1. **全自动** — 所有素材获取必须是 Agent 可独立完成的，不依赖人工注册/登录/浏览器操作
2. **直链优先** — 优先使用可直接引用的 URL，零配置零下载
3. **免费可商用** — 仅使用明确标明免费商用的资源
4. **性能意识** — 图片尺寸适中，加载速度优先
5. **不要用 emoji 占位** — 没有合适的素材时，用 CSS 图形/渐变/SVG 内联代替，绝不退化为 emoji

### 自动化检索方式

Agent 有以下工具可用，**按优先级**使用：

| 优先级 | 工具 | 适用场景 | 说明 |
|--------|------|----------|------|
| 1️⃣ | `web_search` | 搜索图片资源 | 在 Unsplash/Pexels 等站内搜索，从结果 URL 提取直链 |
| 2️⃣ | `web_fetch` | 抓取素材页面 | 提取图片 URL 列表，用于批量获取 |
| 3️⃣ | `exec` (curl) | 下载素材到本地 | `curl -o assets/xxx.jpg <url>` |
| 4️⃣ | 已知直链 | 直接引用 | 下文预置的常用素材 URL，可直接用 |

---

### 素材来源（仅限全自动化）

#### 1. 壁纸 / 背景图 — Unsplash & Pexels（直链引用）

两者均为免费可商用，URL 参数控制尺寸，无需注册，直接在 HTML/CSS 中引用。

**Unsplash 格式：**
```
https://images.unsplash.com/photo-{ID}?w={width}&h={height}&fit=crop
```

**常用科技风直链（直接可用）：**

| 风格 | URL |
|------|-----|
| 暗色网络拓扑 | `https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1920&h=1080&fit=crop` |
| 科技数据流 | `https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=1920&h=1080&fit=crop` |
| 编程暗色 | `https://images.unsplash.com/photo-1504639725590-34d0984388bd?w=1920&h=1080&fit=crop` |
| 赛博朋克 | `https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=1920&h=1080&fit=crop` |

**Pexels 格式：**
```
https://images.pexels.com/photos/{id}/pexels-photo-{id}.jpeg?auto=compress&w={width}
```

**常用科技风直链（直接可用）：**

| 风格 | URL |
|------|-----|
| 抽象科技 | `https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&w=1920` |
| 蓝色数据 | `https://images.pexels.com/photos/1108101/pexels-photo-1108101.jpeg?auto=compress&w=1920` |
| 暗色抽象 | `https://images.pexels.com/photos/355952/pexels-photo-355952.jpeg?auto=compress&w=1920` |

**发现新素材：** 用 `web_search` 搜索 `site:unsplash.com {关键词}` 或 `site:pexels.com {关键词}`，从结果中提取 photo ID 构造直链。

#### 2. 图标 — Lucide Icons（CDN，零配置）

开源 ISC 协议，CDN 直接引入，无需下载、无需注册。

```html
<!-- 引入 CDN（在 index.html 或页面中添加一次即可） -->
<script src="https://unpkg.com/lucide@latest"></script>

<!-- 使用图标 -->
<i data-lucide="workflow"></i>
<i data-lucide="code-2"></i>

<!-- 初始化 -->
<script>lucide.createIcons();</script>
```

**常用图标速查：**

| 类别 | 图标名称 |
|------|----------|
| 开发 | `code-2`, `terminal`, `git-branch`, `variable` |
| 流程 | `workflow`, `layers`, `git-merge`, `arrow-right` |
| 数据 | `bar-chart-2`, `pie-chart`, `database`, `table` |
| 安全 | `shield-check`, `lock`, `key` |
| 通用 | `zap`, `rocket`, `sparkles`, `eye`, `check`, `x`, `globe`, `search`, `download`, `external-link`, `monitor` |
| UI | `menu`, `chevron-down`, `settings`, `palette`, `layout` |

**更多图标：** 用 `web_search` 搜索 `lucide icons {图标名}` 查找完整图标名列表。

#### 3. 随机占位图 — Lorem Picsum（极简 API）

无需注册，URL 即图片，适合快速原型。

```
https://picsum.photos/1920/1080          # 随机全屏图
https://picsum.photos/seed/{任意字符串}/1920/1080  # 基于种子生成固定图片（推荐，可复现）
```

#### 4. CSS/SVG 替代方案（无需外部资源）

当不需要照片类素材时，优先用纯代码实现：

**渐变背景：**
```css
background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
background: radial-gradient(circle at 20% 50%, #2E5C8A22 0%, transparent 50%);
```

**几何装饰（纯 CSS）：**
```css
/* 半透明圆形装饰 */
.deco-circle {
  position: absolute;
  width: 300px; height: 300px;
  border-radius: 50%;
  background: rgba(46, 92, 138, 0.15);
  border: 1px solid rgba(46, 92, 138, 0.2);
}
```

**内联 SVG 图标（无 CDN 依赖）：**
```html
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/>
</svg>
```

---

### 自动化检索流程

```
接到设计任务
 ↓
分析素材需求
 ├─ 壁纸/背景图 → 查下文预置直链 或 web_search 搜索新素材
 ├─ 图标 → Lucide Icons CDN（零配置）
 ├─ 占位图 → Lorem Picsum（seed 可复现）
 └─ 无合适素材 → CSS 渐变/SVG 内联替代
 ↓
获取素材（全程自动）
 ├─ 直链可用 → 直接在 HTML/CSS 中引用 URL
 ├─ 需要本地文件 → curl -o 下载到 assets/
 └─ 需要 SVG → 内联 SVG 或 Lucide CDN
 ↓
应用到设计
 ├─ 图片 → <img src="url" loading="lazy" alt="desc">
 ├─ 图标 → Lucide CDN
 ├─ 背景 → CSS background-image + 渐变叠加
 └─ 装饰 → 纯 CSS 几何/SVG
```

**全流程无需人工参与。**

---

### 设计最佳实践

#### 图片处理
- **Hero 背景**：图片 + `filter: brightness(0.4-0.6)` + 渐变叠加层
- **卡片图片**：`object-fit: cover` + 固定高度
- **装饰图**：降低 opacity，不抢视觉焦点

#### 壁纸叠加层模板
```css
.wallpaper-section {
  position: relative;
}
.wallpaper-section::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, rgba(10,10,15,0.3), rgba(10,10,15,0.9));
}
```

#### 禁忌
- ❌ 不要使用 emoji 作为 UI 图标或占位
- ❌ 不要使用不明版权的图片
- ❌ 不要使用过大的图片（单张超过 2MB）
- ❌ 不要使用需要注册/登录/API Key 的素材源（Pixabay API、iconfont.cn 等）
- ❌ 不要使用需要浏览器手动操作的素材源（wallhaven.cc、Storyset 等）

#### 搜索关键词

| 场景 | web_search 关键词 |
|------|-----------|
| 科技感 | `site:unsplash.com dark technology` |
| 抽象背景 | `site:unsplash.com abstract gradient dark` |
| 自然 | `site:pexels.com dark landscape` |
| 商务 | `site:pexels.com office minimal dark` |

---

*网络素材检索 v1.1 | 2026-04-01 | 全自动化，零人工介入*
