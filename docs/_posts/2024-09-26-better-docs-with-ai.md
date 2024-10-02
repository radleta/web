---
layout: posts
title: "Build better documentation with AI"
date: 2024-09-26 10:00:00 -0500
categories: development
---

## tldr

- Use markdown to write documentation
  - AI uses markdown as its native input and output format
  - Easy to copy and paste to and from AI tools
  - Markdown is easy to write and read
  - Markdown can be converted to HTML, PDF, and other formats
- Using markdown tools
  - Use vscode to write markdown
    - Best extensions for markdown
      - markdownlint
        - markdownlint is a tool to check markdown syntax
      - markdown preview mermaid support
        - mermaid is a tool to generate diagrams in markdown in the preview
      - copilot
        - copilot is an AI tool to help write code (inline)
      - Copy Context
        - Copy Context is a tool to copy the a file or files to the clipboard to paste in ChatGPT or other AI tools
  - Use pandoc to convert markdown to other formats
    - pandoc is a tool to convert markdown to HTML, PDF, and other formats
      - install from `chocolatey` on windows (see [pandoc](https://pandoc.org/installing.html))
      - `choco install pandoc` and `choco install rsvg-convert python miktex`
    - mermaid-filter with pandoc to convert mermaid diagrams to images in the output
      - mermaid-filter on windows command prompt requires a workaround `-F mermaid-filter.cmd` to work when using the `npm` package
      - install from [npm](https://www.npmjs.com/package/@binpar/mermaid-filter)
