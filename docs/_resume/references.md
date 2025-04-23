---
layout: single
title: References
permalink: /resume/references/
---

{% for reference in site.data.resume.references %}
{% if reference.reference %}
> "{{ reference.reference }}"
> 
> — {{ reference.name }}, {{ reference.relationship }} ({{ reference.date | date: "%B %Y" }})
{% endif %}

{% unless forloop.last %}---{% endunless %}

{% endfor %}
