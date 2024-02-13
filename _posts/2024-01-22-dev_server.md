---
date: 2024-01-22 19:45:00
author: mikee
mood: frustrated
title: Dev Server Issues?
tags: ["themes", "daisyui", "tailwindcss"]
excerpt_separator: <!--more-->

---
Just posted to Discord:

I'm working on my personal site, and am using 11ty with Tailwind and DaisyUI, and have a frustrating problem.

Most pages and posts call on `default.njk`, which is my main layout.

I'm trying a lot of small variations in the styling at the moment due to how Tailwind works, but the changes to `default.njk` are not coming through to /_site.

<!--more-->

The dev server is seeing the file change, and thinks it has overwritten the file.

```
[11ty] [11ty] File changed: src/_layouts/default.njk 
...
[11ty] [11ty] Writing _site/index.html from ./src/index.njk
...
[11ty] [11ty] Benchmark    242ms  73%   676× (Configuration) "slugify" Nunjucks Filter
[11ty] [11ty] Copied 2 files / Wrote 44 files in 0.33 seconds (7.5ms each, v2.0.1)
[11ty] [11ty] Watching...
```

but nothing changes in the html. I've checked the generated html via nano, so know it's not caching in FireFox. If I delete the /_site folder and restart 11ty it all works fine. 

I've checked all the permissions, and everything looks OK.

11ty version is 2.0.1, running on my debian 12 server.
```
npm doctor
Check                               Value   Recommendation/Notes
npm ping                            ok
npm -v                              ok      current: v10.3.0, latest: v10.3.0
node -v                             ok      current: v20.11.0, recommended: v20.11.0
npm config get registry             ok      using default registry (https://registry.npmjs.org/)
git executable in PATH              ok      /usr/bin/git
global bin folder in PATH           ok      /usr/local/bin
Perms check on cached files         ok
Perms check on local node_modules   ok
Perms check on global node_modules  ok
Perms check on local bin folder     ok
Perms check on global bin folder    ok
npm WARN verifyCachedFiles Content garbage-collected: 162 (64655765 bytes)
npm WARN verifyCachedFiles Cache issues have been fixed
Verify cache contents               ok      verified 4259 tarballs
```
package.json contains:

```
"main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start-run-old": "npm-run-all -p dev:*",
    "start": "concurrently \"npm run dev:*\"",
    "dev:11ty": "eleventy --serve --port=4004",
    "dev:tw": "tailwindcss -i src/assets/css/tailwind.css -c tailwind.config.js -o _site/assets/css/tw-style.css --watch",
    "build": "ELEVENTY_PRODUCTION=true eleventy && NODE_ENV=production npx tailwindcss -i src/assets/css/tailwind.css -c tailwind.config.js -o _site/assets/css/tw-style.css --minify"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "@11ty/eleventy": "^2.0.1",
    "@11ty/eleventy-plugin-syntaxhighlight": "^5.0.0",
    "@tailwindcss/typography": "^0.5.10",
    "autoprefixer": "^10.4.16",
    "concurrently": "^8.2.2",
    "daisyui": "^4.6.0",
    "npm-run-all": "^4.1.5",
    "postcss": "^8.4.33",
    "tailwindcss": "^3.4.1"
  }

  ```

  Even just running `npm run dev:11ty` isn't changing when I change comments in the `default.njk`.