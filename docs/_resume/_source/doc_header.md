{{ site.author.bio }}

_Location:_ {{ site.author.location }}
{% for link in site.author.links %}
{% if link.url contains 'http' %}
* _{{ link.label }}:_ [{{ link.url }}]({{ link.url }})
{% else %}
* _{{ link.label }}:_ [{{ site.url }}{{ link.url }}]({{ site.url }}{{ link.url }})
{% endif %}
{% endfor %}
