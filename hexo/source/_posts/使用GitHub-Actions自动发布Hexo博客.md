---
title: 使用 GitHub Actions 自动发布 Hexo 博客
author: ZP
date: 2026-06-21 10:30:00
tags:
  - hexo
  - GitHub Actions
  - CI/CD
categories:
  - 博客搭建
---

之前这个博客最大的问题不是不能用，而是每次换电脑之后维护成本太高。

Hexo 本身是一个静态博客生成工具，文章是 Markdown，但是最终发布到 GitHub Pages 上的内容是 HTML、CSS、JS 这些静态文件。也就是说，中间需要有一个构建过程：

```text
Markdown 文章
↓
Hexo 构建
↓
HTML/CSS/JS 静态文件
↓
GitHub Pages 展示
```

以前这个构建过程主要在本地完成，所以换电脑时就需要重新安装 Node、Hexo、依赖包、主题配置等。只要本地环境不一致，就容易出现构建失败、依赖错误、部署命令不可用等问题。

这次改造的目标是把这一步交给 GitHub Actions。

### 以前的发布流程

以前大致是这样：

```text
本地写 Markdown
↓
本地运行 hexo clean
↓
本地运行 hexo generate
↓
生成 public 目录
↓
把生成后的静态文件推到 GitHub
↓
GitHub Pages 展示
```

这种方式的问题是，本地电脑既要负责写文章，也要负责构建和发布。只要换电脑，整套环境就要重新配置一遍。

### 现在的发布流程

现在改成：

```text
本地写 Markdown
↓
提交到 GitHub
↓
GitHub Actions 自动安装依赖
↓
GitHub Actions 自动运行 Hexo 构建
↓
GitHub Pages 发布生成结果
```

这样本地只需要关心 Markdown 文件本身。

文章放在：

```text
hexo/source/_posts/
```

比如这篇文章就是一个普通 Markdown 文件。提交并 push 到 `hexo` 分支之后，GitHub Actions 会自动执行构建。

### GitHub Actions 配置文件

GitHub Actions 的配置文件放在：

```text
.github/workflows/pages.yml
```

这是 GitHub 的约定目录。只要仓库里有：

```text
.github/workflows/*.yml
```

GitHub 就会把这些文件识别为自动化工作流。

这次的核心配置是：

```yaml
on:
  push:
    branches:
      - hexo
  workflow_dispatch:
```

意思是：

```text
当 hexo 分支有 push 时，自动运行这个 workflow。
也可以在 GitHub Actions 页面手动运行。
```

### 构建任务做了什么

workflow 里的 build 任务会做几件事。

第一步，下载仓库代码：

```yaml
uses: actions/checkout@v4
```

第二步，安装 Node.js：

```yaml
uses: actions/setup-node@v4
with:
  node-version: "20"
```

因为 Hexo 是 Node.js 生态里的工具，所以要先准备 Node 环境。

第三步，进入 Hexo 项目目录：

```yaml
defaults:
  run:
    working-directory: hexo
```

这个仓库的 Hexo 源码在 `hexo/` 目录下面，所以后面的 `npm` 命令都要在这个目录里执行。

第四步，安装依赖：

```yaml
run: npm ci
```

`npm ci` 会根据 `package-lock.json` 安装固定版本的依赖，适合在 CI 环境里使用。

第五步，构建博客：

```yaml
run: |
  npm run clean
  npm run build
```

而 `hexo/package.json` 里定义了：

```json
{
  "scripts": {
    "clean": "hexo clean",
    "build": "hexo generate"
  }
}
```

所以实际执行的是：

```bash
hexo clean
hexo generate
```

这一步会把 `hexo/source/_posts/` 里的 Markdown 文章生成到：

```text
hexo/public/
```

### 部署任务做了什么

构建完成后，workflow 会把 `hexo/public/` 上传为 GitHub Pages 的发布产物：

```yaml
uses: actions/upload-pages-artifact@v4
with:
  path: hexo/public
```

然后再执行：

```yaml
uses: actions/deploy-pages@v4
```

这一步会把生成好的静态文件发布到 GitHub Pages。

最终访问的地址还是：

```text
https://stubborn123.github.io
```

### 这次改造的意义

这次改造之后，博客的发布职责发生了变化：

```text
以前：本地负责写文章、构建博客、发布博客
现在：本地只负责写文章和提交，GitHub Actions 负责构建和发布
```

这样换电脑时就简单很多。只要能编辑 Markdown 并提交 Git，就可以更新博客。

后面如果和 Obsidian 结合，也可以形成一个更顺畅的流程：

```text
Obsidian 写笔记
↓
整理成 Hexo Markdown
↓
放入 hexo/source/_posts/
↓
提交并 push
↓
GitHub Actions 自动发布
```

这个流程比每次手动构建更稳定，也更适合长期维护自己的博客。
