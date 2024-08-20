---
layout: page
title: Home
id: home
permalink: /
---

# Welcome! This is Sociology Theories Garden 🌱

<p style="padding: 3em 1em; background: #f5f7ff; border-radius: 4px;">
  这里包含了 主要的现代，古典社会学理论 并标识了 专有名词的韩语版本<small style="background-color:rgba(218, 247, 166, 0.7);padding:3px;border-radius:5px;color:black">한국어 버전</small> 翻译<br>
  并且，本网站启用了 <span style="font-weight: bold">双向链接</span> 技术， 您可以点击链接跳转到各词条的详情部分，轻松发现各理论，知识条目之间的关联。
</p>



<strong>古典社会学理论</strong><small style="background-color:rgba(218, 247, 166, 0.7);padding:3px;border-radius:5px;color:black">고전사회학 이론</small>

<ul>
  {% assign classical_notes = site.notes | where_exp: "item", "item.path contains '/Classical'" | sort: "last_modified_at" | reverse %}
  {% for note in classical_notes limit: 10 %}
    <li>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>

<strong>现代社会学理论</strong><small style="background-color:rgba(218, 247, 166, 0.7);padding:3px;border-radius:5px;color:black">현대사회학 이론</small>

<ul>
  {% assign classical_notes = site.notes | where_exp: "item", "item.path contains '/Temporary'" | sort: "last_modified_at" | reverse %}
  {% for note in classical_notes limit: 10 %}
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
