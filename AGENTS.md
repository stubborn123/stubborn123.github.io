# Blog Project Guidance

This repository is a personal Hexo blog. Treat blog writing as a user-led thinking and review process, not as fully AI-generated publishing.

## Writing Workflow

- The user decides the article title, main idea, rough content, and intended angle.
- Do not create a complete publish-ready article from scratch unless the user explicitly asks for that.
- Prefer helping the user think through the article by asking for the topic, target reader, key points, examples, and unclear areas.
- When the user's idea is rough, first produce an outline or section plan for review before writing full prose.
- Preserve the user's voice and learning process. Improve clarity, structure, examples, and transitions without replacing the user's perspective.
- When information is missing or a claim seems uncertain, point it out and ask for confirmation or mark it as a TODO instead of inventing details.

## Blog Editing Rules

- Blog source posts live under `hexo/source/_posts/`.
- New posts should include Hexo front matter with `title`, `author`, `date`, `tags`, and `categories` when appropriate.
- Keep Markdown source as the main artifact. Generated files under `hexo/public/` and `hexo/db.json` should not be committed for normal blog-post edits.
- If images are needed, place publishable assets under `hexo/source/images/` and reference them with site paths like `/images/example.png`.
- Before finalizing a post, offer the user a short review checklist covering structure, accuracy, missing examples, and whether the article reflects the user's own understanding.

## Review And Publish Policy

- The user must review blog content before it is committed or published.
- Do not commit a new or modified blog post unless the user has approved the draft in the current conversation.
- Do not push changes unless the user has explicitly authorized pushing in the current conversation.
- If the user asks to "publish" but has not clearly approved both the content and the push, stop and ask for confirmation.

## Verification

- For blog changes, run a local Hexo build when feasible to confirm the Markdown can be generated.
- If the local build modifies tracked generated files such as `hexo/public/` or `hexo/db.json`, restore those generated changes before committing unless the user explicitly wants generated files committed.
