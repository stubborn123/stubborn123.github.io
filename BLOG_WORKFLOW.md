# Blog publishing workflow

This repository publishes the Hexo source in `hexo/` to GitHub Pages with GitHub Actions.

## Add a post

1. Create or copy a Markdown post into:

   ```text
   hexo/source/_posts/
   ```

2. Add Hexo front matter:

   ```md
   ---
   title: Example title
   author: ZP
   date: 2026-06-18 20:00:00
   tags:
     - Java
     - Spring Boot
   categories:
     - 后端工程
   ---
   ```

3. Commit and push to the `hexo` branch.

GitHub Actions will install dependencies, run `hexo clean && hexo generate`, and deploy `hexo/public` to GitHub Pages.

## Obsidian workflow

Use Obsidian as the writing source. When a note is ready to publish, convert or copy it to `hexo/source/_posts/` with Hexo front matter, then commit the generated Markdown file.

For notes with images, put public blog images under `hexo/source/images/` and reference them with absolute site paths, for example:

```md
![screenshot](/images/example.png)
```

## First-time GitHub setting

In GitHub, open repository settings:

```text
Settings -> Pages -> Build and deployment -> Source -> GitHub Actions
```

After that, every push to the `hexo` branch can update the blog automatically.
