# web-presentation

基于 reveal.js 的网页演示制作 Skill。用户说"做PPT"时，生成的是可直接浏览器打开的 HTML 演示文稿，不是 PowerPoint。

## 设计理念

**最低标准，最大自由。**

系统提示词提供最低美学基线（可读性、不溢出、一致性），确保每份演示都有基本的专业品质。但不强制具体的布局、配色、动画——这些由**模板**和**用户需求**决定。

设计优先级：`用户需求 > 模板偏好 > 系统默认参考`

## 功能

- 📄 分页架构 — 每个页面独立 `pages/XX-name.html`，方便编辑
- 🎨 多模板支持 — 学术风 / 科技风 / 项目汇报 / 极简 / 自定义
- 📐 16:9 宽屏（默认），支持 4:3
- ✅ 内容溢出防护 — 内容不超出画布
- 📄 自动导出 PDF — 高分辨率（2x deviceScaleFactor）
- 🖥️ 本地预览 — 自动启动 dev-server 并打开浏览器
- ✍️ KaTeX 公式 + 代码语法高亮
- 🤝 主动沟通 — 制作前确认方案，不盲目动手

## 快速使用

在对话中直接说：

```
帮我做一个关于"量子计算入门"的PPT
```

Agent 会：
1. 确认需求细节（目标受众、页数、关键内容）
2. 匹配模板，呈现方案供确认
3. 确认后初始化项目，生成 `pages/*.html`
4. 自动启动本地服务器，打开浏览器预览
5. 完成后导出 PDF

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

模板定义视觉风格（配色、字体、布局偏好），但不锁死设计。你可以创建自己的模板。

## 依赖

- Node.js ≥ 16（PDF 导出需要 puppeteer）
- Python 3（本地服务器）
- 现代浏览器

依赖检查：`bash scripts/check_deps.sh`

## 系统提示词说明

| 文件 | 职责 |
|------|------|
| `system-prompt/style-guide.md` | 最低审美标准 + 设计参考（非强制） |
| `system-prompt/page-types.md` | 页面类型骨架（参考，鼓励变体） |
| `system-prompt/architecture.md` | 技术架构说明 |
| `system-prompt/templates-guide.md` | 模板系统说明 |

系统提示词**不锁死设计**。它确保底线品质，但不限制创意。

## License

MIT License — 自由使用、修改、分发。

详见 [LICENSE](LICENSE)。

---

*Made with ❤️ by Pony 📊*
