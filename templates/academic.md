# 模板：学术汇报

## 场景
学术会议、组会汇报、论文答辩、研究报告

## 设计语言
严谨、克制、值得信赖。用大量留白和清晰的层次传达学术的庄重感。避免任何装饰性元素，让数据和逻辑自己说话。

## 配色

| 语义 | 色值 | 用途 |
|------|------|------|
| 主色 | `#2E5C8A` | 标题、导航按钮、强调 |
| 辅助色 | `#5A7D9A` | 注释、页码、次要信息 |
| 强调色 | `#E74C3C` | 关键数据、警示 |
| 正文色 | `#2C3E50` | 正文、列表 |
| 正文浅色 | `#5A6C7D` | 副标题、说明文字 |
| 背景 | `#FFFFFF` | 页面底色 |
| 浅灰背景 | `#F8F9FA` | 表格底色、代码块 |
| 深色背景 | `#2E5C8A` | 封面、结束页（渐变） |

**CSS 变量设置：**
```css
:root {
  --nav-color: #2E5C8A;
  --nav-color-secondary: #5A7D9A;
}
```

## 字体

| 元素 | 字体 | 字重 |
|------|------|------|
| 标题 | Helvetica Neue Bold, Arial Bold, PingFang SC | 700 |
| 正文 | Helvetica Neue, Arial, PingFang SC | 400 |
| 代码 | SF Mono, Menlo, Consolas | 400 |
| 公式 | KaTeX（继承正文色） | — |

## 布局偏好

- **封面** — 大标题 + 副标题 + 作者 + 日期，居中，深色渐变背景
- **内容页** — 左对齐标题（带底部边框）+ 3–5 要点
  - 标题样式：`color: #2E5C8A; border-bottom: 2px solid #2E5C8A; padding-bottom: 12px;`
  - 内容区域：`padding: 60px 100px; max-width: 1300px; margin: 0 auto;`
  - 列表项：自定义圆点（主色小圆点），`font-size: 21px; line-height: 1.9;`
- **公式页** — 公式居中，解释文字在下方，fragment 逐步揭示
- **过渡页** — 章节标题居中，字号 2.0em，极简
- **结束页** — "Q & A" 大字 + 渐变深色背景

## 动画风格
- **进入** — 淡入 (fade-in)
- **强调** — `fragment highlight-red` 用于关键数据
- **页间过渡** — 全局 fade
- **限制** — 每页 ≤ 4 个 fragment，不使用 grow/shrink/zoom

## 特殊要求
- 支持 LaTeX 公式 (KaTeX)
- 支持代码高亮 (monokai 主题)
- 底部居中圆形导航按钮（‹ ›），渐变进度条
- 页码右下角，辅助色 `#5A7D9A`，0.75em
- Logo 右上角（如提供）
