---
date: 2024-01-13 07:59:00
author: mikee
mood: why is it still raining and so windy?
title: Sorted!
tags: 11ty
---
Got the front page to only show the most recent content by adding the following to my .eleventy.js file

```js
  eleventyConfig.addCollection("front", function(collectionAPI) {
    return collectionAPI.getFilteredByTag("posts").sort(function(a, b) {
        return b.date - a.date;
      }).slice(0, 5);
    });
```

and then the loop in index.njk is

```js
{% raw %}
  {% for post in collections.front %} 
    {% include "homeplate.njk" %} 
  {% endfor %} 
{% endraw %}
````

links: [how to escape code in markdown](https://github.com/11ty/eleventy/issues/1086)