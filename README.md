# Skadhook
## Caddy automation with the git plugin using a webhook

**Usage:**

* Install [Caddy](https://caddyserver.com)
* Clone skadhook
* Make necessary changes with the Caddyfile
   ie: Change the skadoosh branch, secret keys, url, and point it to your modification of skadoosh.
       Also change the variables in checkdiff/checkdiff.sh
* Create a webhook on github/gitlab/wherever pointing it to your url/_skadoosh
   eg: https://skadoosh.regalstreak.me:6969/_skadoosh
* Check if the webhook works by pushing a different compress.bash
* Test whole automation!

Enjoy using this!