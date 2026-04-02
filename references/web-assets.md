# Web Assets — 网络素材检索

Rule 6 的详细说明。全程自动，无需人工介入。

## 可用工具

`web_search`（搜索素材）、`web_fetch`（提取 URL）、`exec`（curl 下载到 assets/）。

## 推荐来源

| 类型 | 来源 | 特点 |
|------|------|------|
| 壁纸/背景 | Unsplash, Pexels | 免费，可商用，URL 参数控制尺寸 |
| 图标 | Lucide Icons | CDN 引入，零配置，开源 |
| 占位图 | Lorem Picsum | URL 即图片，seed 可复现 |
| 装饰 | CSS 渐变 / 内联 SVG | 纯代码，无外部依赖 |

**搜索技巧：** `web_search site:unsplash.com {关键词}` → 提取图片 ID → 构造直链。

## 设计注意

- 背景图叠加暗色遮罩保证文字可读
- 图片做 `object-fit: cover` 统一视觉

## 禁忌

- ❌ 不明版权的图片
- ❌ 需注册/登录/API Key 的来源
- ❌ 单张图片超过 2MB
