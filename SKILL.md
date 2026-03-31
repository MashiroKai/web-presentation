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

### Rule 2: 主动提问，完善需求

用户需求模糊时（只有主题没有细节），**必须先提问再动手**，不能直接开始制作。

**必须问清楚的内容：**
| 问题 | 目的 |
|------|------|
| 核心主题/论文是什么？ | 确定内容方向 |
| 目标受众是谁？ | 确定难度和语言风格 |
| 演讲时长多少？ | 确定页数 |
| 必须包含的关键点？ | 不遗漏重要内容 |
| 参考材料有没有？ | 充实内容 |

**确认方案后才开始制作。** 呈现选项等用户选择。

### Rule 3: 内容不超画布

所有页面内容必须严格在幻灯片画布内，不能溢出。文字不能太小（可读性），也不能太大（不能滚动）。

### Rule 4: 内容居中

**所有页面内容必须水平+垂直居中，四边留白均匀。** 每页 HTML 必须用居中容器包裹：

```html
<section>
  <div style="max-width:70%; margin:0 auto; text-align:center;">
    <!-- 所有内容放这里 -->
  </div>
</section>
```

- `max-width:70%` — 内容不超过画布 70%，左右各留 15%
- `margin:0 auto` — 水平居中
- **禁止直接在 `<section>` 下放内容**（封面/结束页除外）

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

**Full workflow:**

1. **Requirements** — topic, audience, scenario
2. **Slide size** — 默认 16:9 (1920×1080)。仅当用户明确提到 4:3 时使用 4:3 (1440×1080)。**不需要询问。**
3. **Clarify** — if the user's idea is vague or incomplete, **actively ask questions** to help them refine: What's the core message? Who's the audience? How long is the talk? What key points must be covered? Do NOT start building until the plan is confirmed.
4. **Template** — select style from `templates/`
5. **Outline** — Markdown outline → page list
6. **Confirm** — outline + template + slide size approval
7. **Build** — generate pages/*.html + index.html (set `SLIDE_RATIO` env var when calling `init_project.sh`). Each page is a separate `pages/XX-name.html` file. Update `PAGE_MANIFEST` in index.html.
8. **Preview** — 启动本地服务器并自动打开浏览器：
   ```bash
   cd <project-dir> && python3 dev-server.py &
   ```
   然后用浏览器打开 `http://localhost:8000`。如果端口被占用，换 8001/8002 等。
9. **Polish** — 动画、单页调整、内容溢出检查
10. **Export PDF** — **必须执行：** `bash <SKILL_DIR>/scripts/export-pdf.sh <project-dir>` → 生成 `presentation.pdf`（自动先 build，不覆盖源 index.html）
11. **Deliver** — 确认交付清单完整：
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

See `system-prompt/style-guide.md` for the complete aesthetic and style system — colors, typography, layout, animation, dark mode, code display, and assets folder usage. Follow it on every page you create.

## Templates

See `<SKILL_DIR>/templates/`. All templates inherit from the style guide.

| Template | Scenario |
|---|---|
| academic.md | Academic presentations |
| tech-talk.md | Tech sharing, dark theme |
| project-review.md | Project progress |
| minimal.md | Clean, minimal |

See `system-prompt/templates-guide.md` for custom templates.

## Page Types

See `system-prompt/page-types.md` for all page type HTML structures.

## Architecture

See `system-prompt/architecture.md` for index.html internals and loading mechanism.

## Bilingual

All templates and page types support Chinese and English.
