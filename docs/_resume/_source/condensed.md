{% assign positions_limit = 3 %}
{% assign companies = site.data.resume.work | group_by: "name" %}
{% assign companies_to_show = companies | slice: 0, positions_limit %}
{% assign remaining_companies = companies | slice: positions_limit, 100 %}
{% if site.data.resume.work.size > 0 %}
{% assign earliest_position = site.data.resume.work | last %}
{% assign earliest_year = earliest_position.startDate | date: "%Y" %}
{% endif %}
{% assign highlight_limit = 0 %}
{% assign cert_limit = 2 %}
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

{% assign all_skills = "" | split: "" %}
{% for job in company_jobs %}
{% for skill in job.skills %}
{% assign all_skills = all_skills | push: skill.name %}
{% endfor %}
{% endfor %}
{% assign unique_skills = all_skills | uniq | sort %}
{% if unique_skills.size > 0 %}**Skills:** {{ unique_skills | join: ", " }}{% endif %}
{% endfor %}

{% if remaining_companies.size > 0 %}
### Previous Experience

{% assign previous_companies_to_show = remaining_companies | slice: 0, 3 %}
{% for company in previous_companies_to_show %}
{% assign company_jobs = company.items | sort: "startDate" | reverse %}
{% assign most_recent_job = company_jobs | first %}
{% assign earliest_job = company_jobs | last %}
- **{{ company.name }}**: {% if company_jobs.size > 1 %}{{ company_jobs.size }} positions{% else %}{{ most_recent_job.position }}{% endif %} ({% if earliest_job.startDate %}{{ earliest_job.startDate | date: "%Y" }}{% endif %} - {% if most_recent_job.endDate %}{{ most_recent_job.endDate | date: "%Y" }}{% else %}Present{% endif %})
{% endfor %}

{% assign remaining_companies_count = remaining_companies.size | minus: 3 %}
{% if remaining_companies_count > 0 %}
**Additional Experience:** Positions at {{ remaining_companies_count }} more companies dating back to {{ earliest_year }} are available upon request.
{% endif %}
{% endif %}

## Education

{% for edu in site.data.resume.education %}
**{{ edu.studyType }}** in {{ edu.area }}, {{ edu.institution }} ({% if edu.endDate %}{{ edu.startDate | date: "%Y" }} - {{ edu.endDate | date: "%Y" }}{% else %}{{ edu.startDate | date: "%Y" }} - Present{% endif %})
{% endfor %}

## Certifications

{% for i in (0..cert_limit-1) %}
- {{ site.data.resume.certificates[i].name }}{% if site.data.resume.certificates[i].date %} ({{ site.data.resume.certificates[i].date | date: "%b %Y" }}){% endif %}
{% endfor %}