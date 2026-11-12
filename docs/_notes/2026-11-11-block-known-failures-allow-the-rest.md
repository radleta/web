---
title: Block known failures, allow the rest
date: 2026-11-11
tag: agents
takeaway: An allowlist on an agent's shell also blocks every legitimate use nobody thought to list, so block the specific actions known to do lasting damage and let the rest through.
---

My 11 review agents each carried a hook on its shell that allowed only read-only git in the current folder. So a reviewer couldn't run git in a sub-repo, use a pipe, or run the tests and linters it was there to judge. Builds kept reporting environment blockers, and I never counted how many. Sub-repos got reviewed with no diff. Five issues had been filed about reviewers hitting that hook.

The one failure it could stop is destructive git wiping uncommitted work. I've never seen a reviewer try it, and builds now commit each green checkpoint, so there's little left to lose.

Yesterday I took the hook out of all 11 and deleted the script that kept the copies identical. A guard in an agent's own files is a reminder for the agent. Real limits live outside it. The agents' instructions now ban destructive git, and if one ever does lose work that way, I'll block it in the single guard script Claude Code runs before every tool call in every session. That script sits outside their files, where they can't skip it.

Don't block an agent's action until you've seen it do damage.
