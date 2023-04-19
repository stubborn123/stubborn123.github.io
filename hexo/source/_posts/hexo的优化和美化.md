title: hexo的优化和美化
author: ZP
date: 2023-04-19 17:13:17
tags:
---
因为之前的文章只是介绍hexo的相关改造，实际跟工程一样，开发只占20%到30%，剩下的大头成本主要是维护和优化。所以说hexo的优化和美化也是一个可以研究的，比如说扩展功能，调整主题，安装插件等，来丰富博客的功能。

### 主题设置
我这边选的是NEXT主题，我们知道有一个配置文件_config.yml。主题对应也有这个设置，用来设置布局样式，展示按钮等。以下是主题的配置文件位置，后面我们很多的主题设置都要修改这个文件

![主题配置文件位置](/images/hexo_next.png)


#### NEXT主页样式

next有四种风格,在站点配置文件搜索字段Scheme Settings可以看到，
```
scheme: Muse
#scheme: Mist
#scheme: Pisces
#scheme: Gemini
```

一般默认选择的是Muse，这里用的是四种：Gemini

#### menu开启与设置
设置完之后，发现整个博客是光秃秃的，看到别人的博客都有很多menu按钮。这些menu在哪里有呢，实际上在Next主题的配置文件具有对应的按钮在里面

```
# ---------------------------------------------------------------
# Menu Settings
# ---------------------------------------------------------------

# Usage: `Key: /link/ || icon`
# Key is the name of menu item. If the translation for this item is available, the translated text will be loaded, otherwise the Key name will be used. Key is case-senstive.
# Value before `||` delimiter is the target link, value after `||` delimiter is the name of Font Awesome icon.
# When running the site in a subdirectory (e.g. yoursite.com/blog), remove the leading slash from link value (/archives -> archives).
# External url should start with http:// or https://
menu:
  home: / || fa fa-home
  about: /about/ || fa fa-user
  tags: /tags/ || fa fa-tags
  categories: /categories/ || fa fa-th
  archives: /archives/ || fa fa-archive
  schedule: /schedule/ || fa fa-calendar
  sitemap: /sitemap.xml || fa fa-sitemap
  commonweal: /404/ || fa fa-heartbeat
```
里面有些没有展示出来，是被注释了，我们解开注释就可以了。

但是menu有了，但是点击报错跳到空白页面，这就需要我们自己设置，已分类和标签例子。

刚开始我们点击这两个按钮会报错“Cannot GET XXX”错误，问题的原因是我们没有初始化，初始化具体的步骤：<br>

1  创建对应的文件夹，可以通过命令在git bash 中输入以下代码创建相应的page：hexo new page "tags"hexo new page "categories"来创建文件夹。也可以手动创建文件夹，然后在里面创建index.md文件。



2  在第一步完成后会在source文件夹中出现tags和categories的文件夹，在各自的文件夹里打开index.md文件进行修改(多加上一个type属性),标签的tags的index.md里面添加type: "tags"
```js
---
title: tags
date: 2023-04-19 17:04:58
type: "tags"
---

```



### 文章设置
文件有很多属性，比如说tag标签，设置置顶文件等，一般来说这些属性都在对应的markdown文件的Front-matter部分。

#### 文章置顶
打开对应的文章文件，对应的目录是在source目录下面的_posts目录，里面保存的是我们的博客文章，文章也有对应的属性，在Front-matter里面设置的。我们通过设置sticky属性，设置为true即可置顶对应的这个文章。

```
title: Mockito实战
author: ZP
date: 2023-04-19 16:40:35
tags: Mockito
sticky: true
---
```
