{%capture download_note %}Available to download in
{% for format in include.file.formats %}{% if forloop.first %}[{{ format.format | upcase }}]({{ site.baseurl }}/{{ format.path }}){% elsif forloop.last %}, or [{{ format.format | upcase }}]({{ site.baseurl }}/{{ format.path }}){% else %}, [{{ format.format | upcase }}]({{ site.baseurl }}/{{ format.path }}){% endif %}{% endfor %}.{%endcapture%}
{% include note.html content=download_note %}
