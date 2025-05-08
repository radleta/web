{% assign positions_limit = 3 %}
{% assign companies = site.data.resume.work | group_by: "name" %}
{% assign companies_to_show = companies | slice: 0, positions_limit %}
{% assign remaining_companies = companies | slice: positions_limit, 100 %}
{% if site.data.resume.work.size > 0 %}
{% assign earliest_position = site.data.resume.work | last %}
{% assign earliest_year = earliest_position.startDate | date: "%Y" %}
{% endif %}
{% assign highlight_limit = 0 %}
{% assign cert_limit = 4 %}
{% if site.data.resume.certificates.size < cert_limit %}{% assign cert_limit = site.data.resume.certificates.size %}{% endif %}

## Professional Summary

{{ site.data.resume.basics.summary }}

## Experience

{% for company in companies_to_show %}
{% assign company_jobs = company.items | sort: "startDate" | reverse %}
{% assign most_recent_job = company_jobs | first %}
{% assign earliest_job = company_jobs | last %}

### {{ company.name }} ({% if company_jobs.size > 1 %}{% if most_recent_job.endDate %}{{ earliest_job.startDate | date: "%b %Y" }} - {{ most_recent_job.endDate | date: "%b %Y" }}{% else %}{{ earliest_job.startDate | date: "%b %Y" }} - Present{% endif %}{% else %}{% if most_recent_job.endDate %}{{ most_recent_job.startDate | date: "%b %Y" }} - {{ most_recent_job.endDate | date: "%b %Y" }}{% else %}{{ most_recent_job.startDate | date: "%b %Y" }} - Present{% endif %}{% endif %})
{% for job in company_jobs %}
- **{{ job.position }}** {% if job.endDate %}({{ job.startDate | date: "%b %Y" }} - {{ job.endDate | date: "%b %Y" }}){% else %}({{ job.startDate | date: "%b %Y" }} - Present){% endif %} - {{ job.summary }}
{% endfor %}

{% if most_recent_job.highlights.size > 0 %}
{% if highlight_limit > most_recent_job.highlights.size %}{% assign job_highlight_limit = most_recent_job.highlights.size %}{% else %}{% assign job_highlight_limit = highlight_limit %}{% endif %}
{% if job_highlight_limit > 0 %}
{% for i in (0..job_highlight_limit-1) %}
- {{ most_recent_job.highlights[i] }}
{% endfor %}
{% endif %}
{% endif %}
{% endfor %}

{% if remaining_companies.size > 0 %}
### Previous Experience

{% assign remaining_companies_count = remaining_companies.size %}
{% if remaining_companies_count > 0 %}
Positions at {{ remaining_companies_count }} more companies dating back to {{ earliest_year }} are available upon request.
{% endif %}
{% endif %}

## Education & Certifications

**Education:** {% for edu in site.data.resume.education %}_{{ edu.studyType }}_ in {{ edu.area }}{% unless forloop.last %}, {% endunless %}{% endfor %}

**Certifications:** {% for i in (0..cert_limit) %}{{ site.data.resume.certificates[i].name }}{% if site.data.resume.certificates[i].date %} ({{ site.data.resume.certificates[i].date | date: "%Y" }}){% endif %}{% unless forloop.last %}, {% endunless %}{% endfor %}

## Skills

{% for skill_category in site.data.resume.skills %}
**{{ skill_category.name }}**: {{ skill_category.keywords | join: ", " }}
{% endfor %}

{% if site.data.resume.references.size > 0 %}
## References

{% assign top_reference = site.data.resume.references | first %}
> "{{ top_reference.reference | truncate: 250 }}" [more]({{ site.url }}/resume/full#references)
> 
> — {{ top_reference.name }}, {{ top_reference.position }}

Read more references on the [full resume]({{ site.url }}/resume/full#references).
{% endif %}
