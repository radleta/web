## Professional Summary

{{ site.data.resume.basics.summary }}

## Experience

{% for job in site.data.resume.work %}
### {{ job.position }} | {{ job.name }}
{% if job.endDate %}{{ job.startDate | date: "%b %Y" }} - {{ job.endDate | date: "%b %Y" }}{% else %}{{ job.startDate | date: "%b %Y" }} - Present{% endif %}

{{ job.summary }}

{% if job.highlights.size > 0 %}
{% for highlight in job.highlights %}
- {{ highlight }}
{% endfor %}
{% endif %}

{% if job.skills.size > 0 %}
**Skills:** {% for skill in job.skills %}{% if forloop.first %}{{ skill.name }}{% else %}, {{ skill.name }}{% endif %}{% endfor %}
{% endif %}

{% endfor %}

## Education

{% for edu in site.data.resume.education %}
### {{ edu.studyType }} in {{ edu.area }}
**{{ edu.institution }}** | {% if edu.endDate %}{{ edu.startDate | date: "%Y" }} - {{ edu.endDate | date: "%Y" }}{% else %}{{ edu.startDate | date: "%Y" }} - Present{% endif %}{% if edu.gpa %} | GPA: {{ edu.gpa }}{% endif %}
{% endfor %}

## Certifications

{% for cert in site.data.resume.certificates %}
- {{ cert.name }}{% if cert.issuer %}, {{ cert.issuer }}{% endif %}{% if cert.date %} ({{ cert.date | date: "%b %Y" }}){% endif %}
{% endfor %}

## Projects

{% for project in site.data.resume.projects %}
- **{{ project.name }}**: {{ project.description }}{% if project.url %} [Link]({{ project.url }}){% endif %}
{% endfor %}

## Skills

{% for skillGroup in site.data.resume.skills %}
### {{ skillGroup.name }}
{{ skillGroup.keywords | join: ", " }}
{% endfor %}

# References

{% for reference in site.data.resume.references %}
{% if reference.reference %}
> "{{ reference.reference }}"
> 
> — {{ reference.name }}, {{ reference.relationship }} ({{ reference.date | date: "%B %Y" }})
{% endif %}

{% unless forloop.last %}---{% endunless %}

{% endfor %}