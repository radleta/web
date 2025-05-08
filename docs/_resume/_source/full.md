## Professional Summary

{{ site.data.resume.basics.summary }}

## Experience

{% for job in site.data.resume.work %}
### {{ job.position }} | {{ job.name }}
{% include date-range.html startDate=job.startDate endDate=job.endDate parens=false %}

{{ job.summary }}

{% if job.highlights and job.highlights.size > 0 %}
{% for highlight in job.highlights %}
- {{ highlight }}
{% endfor %}
{% endif %}

{% if job.skills and job.skills.size > 0 %}
**Skills:** {% for skill in job.skills %}{% if forloop.first %}{{ skill.name }}{% else %}, {{ skill.name }}{% endif %}{% endfor %}
{% endif %}

{% endfor %}

## Education

{% for edu in site.data.resume.education %}
- **{{ edu.studyType }}** in {{ edu.area }}: {{ edu.institution }}{% if edu.gpa %} with a GPA of _{{ edu.gpa }}_{% endif %} ({% include date-range.html startDate=edu.startDate endDate=edu.endDate %})
{% endfor %}

## Certifications

{% for cert in site.data.resume.certificates %}
- {{ cert.name }}{% if cert.issuer %}, {{ cert.issuer }}{% endif %}{% if cert.date %} ({{ cert.date | date: '%b %Y'}}){% endif %}
{% endfor %}

## Projects

{% for project in site.data.resume.projects %}
- **{{ project.name }}**: {{ project.description }}{% if project.url %} ([Learn More]({{ project.url }})){% endif %}
  <br/>{% include date-range.html startDate=project.startDate endDate=project.endDate parens=true %}
{% endfor %}

## Skills

{% for skillGroup in site.data.resume.skills %}
### {{ skillGroup.name }}
{{ skillGroup.keywords | join: ", " }}
{% endfor %}

## References

{% for reference in site.data.resume.references %}
{% if reference.reference %}
> "{{ reference.reference }}"
> 
> — {{ reference.name }}, {{ reference.relationship }} ({{ reference.date | date: "%B %Y" }})
{% endif %}

{% unless forloop.last %}---{% endunless %}

{% endfor %}