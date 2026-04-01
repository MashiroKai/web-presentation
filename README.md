# web-presentation

基于 reveal.js 的网页演示制作 Skill。用户说"做PPT"时，生成的是可直接浏览器打开的 HTML 演示文稿，不是 PowerPoint。

## 功能

- 📄 分页架构 — 每个页面独立 `pages/XX-name.html`，方便编辑
- 🎨 多模板支持 — 学术风 / 科技风 / 项目汇报 / 极简 / 自定义
- 📐 16:9 宽屏（默认），支持 4:3
- 📐 内容溢出防护 — CSS 约束内容不超出画布
- 📄 自动导出 PDF — 高分辨率（2x deviceScaleFactor）
- 🖥️ 本地预览 — 自动启动 dev-server 并打开浏览器
- ✍️ KaTeX 公式 + 代码语法高亮

## 快速使用

在对话中直接说：

```
帮我做一个关于"量子计算入门"的PPT
```

Agent 会：
1. 确认需求细节（目标受众、页数、关键内容）
2. 选择模板风格
3. 初始化项目，生成 `pages/*.html`
4. 自动启动本地服务器，打开浏览器预览
5. 完成后可导出 PDF

## 项目结构

```
projects/<project-name>/
├── index.html          ← 开发版（fetch 动态加载 pages）
├── dev-server.py       ← 本地预览服务器
├── manifest.json       ← 项目元数据 + 页面列表
├── project-index.md    ← 项目文档
├── style.css           ← 全局样式
├── assets/             ← 图片、数据等资源
├── pages/              ← 每个幻灯片页面
│   ├── 01-title.html
│   ├── 02-content.html
│   └── ...
└── build/              ← 构建产物（内联单文件，用于分发）
    └── index.html
```

最终交付：`output/<project-name>/` 下的 HTML + PDF。

## 预览

```bash
cd <project-dir>
python3 dev-server.py        # 默认 8000 端口
python3 dev-server.py 8080   # 自定义端口
```

浏览器打开 `http://localhost:8000`。

## 模板

| 模板 | 适用场景 | 风格 |
|------|----------|------|
| `academic` | 学术报告、论文答辩 | 白底深蓝，严谨 |
| `tech-talk` | 技术分享、演讲 | 深色背景，科技感 |
| `project-review` | 项目汇报、进度展示 | 灰白简洁 |
| `minimal` | 极简风格 | 无装饰 |
| `custom` | 自定义 | 完全自由 |

## 依赖

- Node.js ≥ 16（PDF 导出需要 puppeteer）
- Python 3（本地服务器）
- 现代浏览器

依赖检查：`bash scripts/check_deps.sh`

## 网络素材检索

内置自动化素材获取能力，全程无需人工参与：

| 素材类型 | 来源 | 方式 |
|----------|------|------|
| 壁纸/背景图 | Unsplash / Pexels | 直链引用，URL 参数控制尺寸 |
| 图标 | Lucide Icons | CDN 零配置引入 |
| 占位图 | Lorem Picsum | seed 参数可复现 |
| CSS/SVG 替代 | 内联 | 纯代码，无外部依赖 |

优先使用专业素材替代 emoji 占位，所有资源免费可商用。详见 SKILL.md 中的「网络素材检索」章节。

## 设计规范

参见 `system-prompt/style-guide.md`，核心原则：
- 每页 ≤ 4 个 fragment 动画
- 配色 ≤ 3 色（主色 + 辅助 + 强调）
- 内容不超出幻灯片画布
- 学术简约风，Apple 排版美学
- ❌ 不使用 emoji 作为 UI 图标

## License

内部使用。
