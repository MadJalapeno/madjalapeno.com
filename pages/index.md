---
title: Pages
layout: static
source: pages
---
{% assign parents = '' | split: ',' %}
{% assign pages = site.pages %}
{% for page in pages %}
{% assign parents = parents | push: page.parent | push: page.parent | uniq %}
{% endfor %}

{% for item in parents %}

<h2>{{ item }}</h2>

{% for page in pages %}
{% if page.parent == item %}
<div class="card">
  <div class="card-body">
<a href="{{page.url}}">{{ page.title }}</a>

{{ page.excerpt }}

    </div>
</div>
{% endif %}
{% endfor %}

{% endfor %}