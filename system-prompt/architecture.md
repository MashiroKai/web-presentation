# Architecture — 分页架构详解

## index.html 职责

index.html 是总控文件，负责：

1. **页面加载** — 通过 fetch API 动态加载 `pages/*.html`
2. **Reveal.js 初始化** — 配置过渡效果、导航、快捷键
3. **全局样式注入** — 加载 `style.css`
4. **模板配置应用** — 从 `manifest.json` 读取模板参数

---

## 加载机制

```javascript
// index.html 核心加载逻辑
const PAGE_MANIFEST = [
  'pages/01-title.html',
  'pages/02-background.html',
  // ...
];

async function loadSlides() {
  const container = document.querySelector('.slides');
  for (const src of PAGE_MANIFEST) {
    const resp = await fetch(src);
    const html = await resp.text();
    container.insertAdjacentHTML('beforeend', html);
  }
  Reveal.initialize({
    hash: true,
    transition: 'fade',        // 全局过渡（推荐 fade）
    transitionSpeed: 'default',
    center: true,
    slideNumber: 'c/t',
    width: 1920,
    height: 1080,
    margin: 0.04,
  });
}

document.addEventListener('DOMContentLoaded', loadSlides);
```

---

## 本地预览

开发阶段用 `dev-server.py` 启动本地服务器（fetch 需要 HTTP 协议，不能直接双击 index.html）：

```bash
cd project-dir && python3 dev-server.py
# 打开 http://localhost:8000
```

`index.html` 通过 `PAGE_MANIFEST` 数组动态加载 `pages/*.html`，修改页面后刷新即可看到效果。

---

## 打包分发（可选）

如需生成独立可运行的单文件 HTML（双击即可打开，无需服务器）：

```bash
bash build.sh project-dir
```

此步骤仅用于**分发场景**，开发过程中不需要。

---

## 过渡效果

Reveal.js 内置过渡：`none`、`fade`、`slide`、`convex`、`concave`、`zoom`

可在 index.html 全局设置，也可在单个 `<section>` 上用 `data-transition` 覆盖：

```html
<!-- 本页使用淡入过渡（推荐） -->
<section data-transition="fade">
  <!-- ... -->
</section>
```

> 全局推荐 `fade` — 最克制、最不干扰阅读的过渡方式。

---

## 本地开发服务器

项目脚手架可选生成一个轻量 `dev-server.py`：

```python
#!/usr/bin/env python3
import http.server, socketserver, os, sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
os.chdir(os.path.dirname(os.path.abspath(__file__)))

print(f"🖥️  http://localhost:{PORT}")
socketserver.TCPServer(("", PORT), http.server.SimpleHTTPRequestHandler).serve_forever()
```
