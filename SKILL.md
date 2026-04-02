---
name: web-presentation
description: "Create web-based slide presentations using HTML with reveal.js. Triggers on: PPT, slides, presentation, demo, talk, report, 做PPT, 做ppt, 做演示, 演示文稿, 幻灯片, 网页展示. IMPORTANT: When user says '做PPT' or 'PPT', they mean web-based HTML presentation, NOT PowerPoint. Supports academic, tech-talk, project-review, and custom styles via template system. Output is a folder with index.html plus separate page files for easy per-page editing. Auto-exports PDF after completion."
---

# Web Presentation

Build HTML presentations that look and feel like PPT. Pure web, no PowerPoint.

**重要：用户说"做PPT"或"PPT"时，默认指网页演示，不是 Microsoft PowerPoint。**

---

## ⚠️ MANDATORY RULES

### Rule 1: 幻灯片尺寸

默认 **16:9 (1920×1080)**，无需询问。仅当用户明确提到 4:3 时使用 1440×1080。

### Rule 2: 先沟通再动手

需求不明确时必须提问（主题、受众、时长、关键内容、风格）。需求明确时也要呈现方案（模板选择 + 内容大纲 + 布局思路）等待确认。用户说"你看着办"可跳过确认。

### Rule 3: 内容不超画布

所有内容严格在画布内，不能溢出。文字保证可读性。

### Rule 4: 布局灵活但有度

默认居中布局（安全通用），但允许左对齐、分栏、全幅背景等。优先级：**用户需求 > 模板偏好 > 默认居中**。铁律：内容不超出画布，视觉整洁有序。

### Rule 5: 必须生成交付物

完成后必须执行：

```bash
# 1. 构建独立 index.html
bash <SKILL_DIR>/scripts/build.sh <project-dir>

# 2. 导出 PDF
bash <SKILL_DIR>/scripts/export-pdf.sh <project-dir>
```

**交付清单：** `src/pages/*.html` + `index.html` + `presentation.pdf`，缺一不可。

### Rule 6: 优先使用网络素材

用专业图标/背景/渐变提升视觉品质，少用 emoji。详见 `<SKILL_DIR>/references/web-assets.md`。

---

## Project Paths

| 类型 | 路径 | 用途 |
|------|------|------|
| 工程目录 | `/projects/<project-name>/` | 开发中的项目 |
| 交付目录 | `/output/<project-name>/` | 成品 |

---

## Workflow

```
需求沟通 → 选择模板 → 方案呈现 → 用户确认 → 制作页面 → Build → Preview → Export PDF → 交付
```

### 详细步骤

1. **Check deps** — `bash <SKILL_DIR>/scripts/check_deps.sh`
2. **Init project** — `bash <SKILL_DIR>/scripts/init_project.sh <name> <template>`
3. **Edit pages** — 每个 `<section>` 独立文件在 `src/pages/`，更新 `PAGE_MANIFEST`
4. **Preview** — `cd <project-dir> && python3 dev-server.py &` → 打开 `http://localhost:8000/src/`
5. **Build** — `bash <SKILL_DIR>/scripts/build.sh <project-dir>`
6. **Export PDF** — `bash <SKILL_DIR>/scripts/export-pdf.sh <project-dir>`

### Preview 注意

开发用 dev-server.py（从 src/ 加载），不需要 build。build 将所有页面内联输出到根目录 `index.html`。

**完成后必须自动启动预览并打开浏览器让用户看到效果。** 端口占用时换 8001/8002。

---

## Project Structure

```
project/
├── src/                # 源码（开发编辑区）
│   ├── index.html      # 开发版（fetch 动态加载 pages）
│   ├── pages/          # 每个幻灯片页面
│   └── style.css       # 全局样式
├── index.html          # 构建产物（双击可打开）
├── manifest.json       # 元数据 + 页面列表
├── project-index.md    # 项目文档（必先阅读）
├── dev-server.py       # 本地预览服务器
├── assets/             # 图片、数据等资源
└── presentation.pdf    # PDF 导出
```

## Editing Pages

每个页面是一个 `<section>` 独立 HTML 文件，用 `class="fragment"` 做逐步揭示。

## Templates

| Template | Scenario |
|---|---|
| academic | 学术汇报、论文答辩 |
| tech-talk | 技术分享，暗色主题 |
| project-review | 项目进度汇报 |
| minimal | 极简通用 |

模板定义配色/字体/动画偏好，按场景选择。详见 `<SKILL_DIR>/references/templates-guide.md`。

### Custom Template & Extract from PPT

- **创建自定义模板** → 详见 `<SKILL_DIR>/references/custom-template.md`
- **从已有 .pptx 提取模板** → 详见 `<SKILL_DIR>/references/extract-from-ppt.md`

## Design References

按需加载，不要一次全读：

| 文件 | 用途 | 何时加载 |
|------|------|----------|
| `references/style-guide.md` | 配色/字体/布局/动画系统 | 制作页面时 |
| `references/page-types.md` | 各类页面 HTML 骨架 | 设计具体页面时 |
| `references/architecture.md` | index.html 加载机制 | 调试/定制架构时 |
| `references/web-assets.md` | 网络素材检索指南 | 需要素材时 |
| `references/templates-guide.md` | 模板选择与应用 | 选择模板时 |
| `references/custom-template.md` | 自定义模板创建 | 用户要自定义风格时 |
| `references/extract-from-ppt.md` | 从 PPT 提取模板 | 用户提供 .pptx 时 |

## Bilingual

所有模板和页面类型支持中英文。
