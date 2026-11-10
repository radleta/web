---
title: Sort the keys before a judge reads them
date: 2026-11-10
tag: evals
takeaway: A model reads JSON as text, so the same fields in another order are a different input; put anything a judge or gate reads in a fixed order, or the same case can pass one run and fail the next.
---

[Amazon's Strands team posted yesterday](https://strandsagents.com/blog/amazon-saves-millions-replacing-sonnet-with-strands-decider/) about swapping Sonnet for a small decision model, and one line stopped me. Sending the same content with the JSON keys in a different order moved the model's output probabilities by up to 0.19. They now sort the keys on every request.

It's obvious once you say it out loud. A model never sees an object, only a string of tokens, so `{"a":1,"b":2}` and `{"b":2,"a":1}` are two different prompts. In code those two are equal, which is exactly why I stop thinking about it.

That matters most where a model passes or fails something. If a judge's input comes from a dict whose order drifts, a score can move with nothing real behind it, and I'd likely wave it off as run variance. Sorting won't make a judge right. It makes it repeatable, so a changed score means something changed.

The post is a vendor write-up with no accuracy numbers on this, only the 0.19 shift. It's still a one-line fix.

Put every input to a judge or gate in a fixed order: sorted keys, stable field order.
