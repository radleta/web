---
title: Stored eval cases raise the cost of every change
date: 2026-10-13
tag: evals
takeaway: Agents add eval cases for anything they touch, so a stored suite grows until every change pays for it in tokens; run evals on request instead of gating on them.
---

Nine days ago I put a testing standard on my skills: a change had to beat a no-skill run on the eval's mean score, with no case scoring worse than before. It came with 43 stored cases. Today there are 61, 354 files and 2.0 MB across 22 skills. Agents add edge cases and more tests for anything they do, and every new case raised the token cost of every later change.

The scores were a huge waste to maintain. Yesterday a build was flagged on four cases a few hundredths below the old version, 0.89 against 0.96 at the widest. Each flag was a question to me, and I ruled all four run variance.

So today I deleted all 61 cases. The tooling stays for a run I ask for. Evals are a one off way to check things, not a form to dev against.
