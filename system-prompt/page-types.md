# Page Types — 页面类型参考

> 每种页面类型是一个结构化骨架。在此基础上填充内容，保持风格一致。

---

## 1. 标题页 · Title

封面是第一印象。深色背景、居中、信息克制。

```html
<section data-background-color="var(--bg-dark, #1D1D1F)">
  <h1 style="color:var(--text-on-dark, #F5F5F7);">演示标题</h1>
  <p style="color:var(--text-secondary, #86868B);">副标题或一句话说明</p>
  <p style="color:var(--text-secondary, #86868B);"><small>作者姓名 · 2026.03</small></p>
</section>
```

---

## 2. 内容页 · Content

最常用的页面类型。外层居中容器包裹所有内容。

```html
<section>
  <div style="max-width:70%; margin:0 auto; text-align:center;">
    <h2 style="color:var(--color-primary, #2E5C8A); border-bottom:2px solid var(--color-primary, #2E5C8A); padding-bottom:12px; margin-bottom:30px;">
      页面标题
    </h2>
    <ul style="list-style:none; padding:0; text-align:left; display:inline-block;">
      <li class="fragment" style="font-size:1.05em; line-height:2.0; margin-bottom:16px; padding-left:24px; position:relative;">
        <span style="position:absolute; left:0; top:10px; width:6px; height:6px; background:var(--color-primary, #2E5C8A); border-radius:50%;"></span>
        要点一
      </li>
    </ul>
  </div>
</section>
```

**关键：** 所有内容必须包裹在 `<div style="max-width:70%; margin:0 auto;">` 中，确保视觉居中。

---

## 3. 过渡页 · Section

章节呼吸点。一个标题，一个副标题，大量留白。

```html
<section>
  <h2 style="font-size:2.0em;">第二章</h2>
  <p style="color:var(--text-secondary, #86868B);">章节副标题</p>
</section>
```

---

## 4. 图文并排页 · Split

左文右图，或左图右文。flex 布局，gap ≥ 2em。

```html
<section>
  <div style="display:flex; gap:2em; align-items:center;">
    <div style="flex:1">
      <h2>标题</h2>
      <ul>
        <li class="fragment">要点一</li>
        <li class="fragment">要点二</li>
      </ul>
    </div>
    <div style="flex:1">
      <img src="assets/figures/diagram.png" alt="描述" style="max-height:400px">
    </div>
  </div>
</section>
```

---

## 5. 图表页 · Chart

数据驱动。图表面积 ≥ 50%，结论写在标题里。

```html
<section>
  <h2>Q1 收入同比增长 23%</h2>
  <canvas id="chart-01" width="800" height="400"></canvas>
  <script>
    new Chart(document.getElementById('chart-01'), {
      type: 'bar',
      data: { /* ... */ }
    });
  </script>
</section>
```

---

## 6. 代码页 · Code

代码为主角。标题简短，代码占据大部分画布。

```html
<section>
  <h2>核心算法</h2>
  <pre><code class="language-python" data-trim data-noescape>
def detect(signal, threshold=0.5):
    """信号探测 — 超过阈值返回 True"""
    return signal > threshold
  </code></pre>
</section>
```

---

## 7. 公式页 · Formula

KaTeX 渲染，配合 fragment 逐步揭示变量含义。

```html
<section>
  <h2>探测效率</h2>
  <p>$$\varepsilon = \frac{N_{\text{det}}}{N_{\text{inc}}} \times 100\%$$</p>
  <p class="fragment" style="color:var(--text-secondary, #86868B);">
    $N_{\text{det}}$ — 探测计数 &nbsp;|&nbsp; $N_{\text{inc}}$ — 入射粒子数
  </p>
</section>
```

---

## 8. 结束页 · Ending

与封面呼应。深色背景，留下联系方式或一个开放性问题。

```html
<section data-background-color="var(--bg-dark, #1D1D1F)">
  <h2 style="color:var(--text-on-dark, #F5F5F7);">谢谢</h2>
  <p style="color:var(--text-secondary, #86868B);">Q & A</p>
  <p style="color:var(--text-secondary, #86868B);"><small>email@example.com</small></p>
</section>
```

---

## Fragment 动画速查

| class | 效果 | 场景 |
|---|---|---|
| `fragment fade-in` | 淡入 | 默认，逐条展开 |
| `fragment fade-out` | 淡出 | 临时提示后消失 |
| `fragment highlight-red` | 红色高亮 | 关键数据、风险项 |
| `fragment highlight-green` | 绿色高亮 | 完成项、正向数据 |
| `fragment grow` | 放大 | ⚠️ 禁用（过于花哨） |
| `fragment shrink` | 缩小 | ⚠️ 禁用（过于花哨） |

## 页内过渡覆盖

```html
<section data-transition="zoom" data-transition-speed="fast">
  <!-- 本页使用快速缩放过渡（仅在特殊场景使用） -->
</section>
```

> 全局默认 `fade`，仅在需要特殊效果时覆盖单页过渡。
