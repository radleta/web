---
title: The terminal output style was shaping Claude's writing
date: 2026-10-13
tag: agents
takeaway: Any writing a person will read should come from a sub-agent whose context never held your terminal output style.
---

My terminal output style was leaking into everything Claude wrote for me. It asks for one idea per sentence, short paragraphs and no idioms; my voice rule asks for varied rhythm, light idioms and humor. The two are for different audiences, and the style was winning.

The output style is loaded in the main session, so I can't rely on the main session to draft copy. Three sub-agents asked to quote the style from their own context all reported it absent, while all three quoted my personal instructions file correctly. That's the agents' own report, unchecked against the harness, and a sub-agent draft did read much more natural.

So letters, emails, replies, posts, READMEs, PR descriptions and docs now go to a drafting sub-agent, with a separate reviewer agent cold-reading each draft. The main session shows the draft as written and sends any change back to the drafter.
