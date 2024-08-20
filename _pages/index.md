---
layout: page
title: Home
id: home
permalink: /
---

# Welcome! This is a wiki about Sociology theories 🌱

<p style="padding: 3em 1em; background: #f5f7ff; border-radius: 4px;">
  这里包含了 社会学理论 以及其 专有名词的韩语对照 翻译<br>
  并且，本网站启用了 <span style="font-weight: bold">双向链接</span> 技术， 您可以轻松发现各理论，知识条目之间的关联。
</p>



<strong>Recently updated notes</strong>

<ul>
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes limit: 5 %}
    <li>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>

<style>
  .wrapper {
    max-width: 46em;
  }
</style>
