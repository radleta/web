---
title: A small change still gets the full review
date: 2026-11-11
tag: agents
takeaway: Size is a bad reason to skip design and review; a one-file fix that went the full route ended up touching six files and a test, and the reviewers caught three bugs that would have shipped.
---

My agent setup had two routes for a change. The full one researches, has me review a design, then sends reviewer and verifier agents over the build. The quick one, for a small contained change, checked only its own work. Four places in my instructions offered it as an equal choice, so small changes could skip design and review.

Yesterday the agent recommended the quick route for a one-file fix, and I took the full one. The design touched six skill files and a test, and the fix as filed would have closed the bug in only one of the places it showed up. Before review, the agent found other gaps, like two instruction files that were already at their size limit, and a missing test. The reviewers found four problems, three of them bugs that would have shipped.

That cost about 45 minutes and ten sub-agent runs before the build. It's one case, and I haven't counted how often the quick route shipped bugs. The quick route skips exactly what caught these, so it's gone as a choice. I'll bring back a lighter route when I need one.

Don't let size decide whether a change gets designed and reviewed.
