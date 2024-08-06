---
layout: static
title:  Kopia/Restic Notifications
parent: Backup
excerpt: Notifications please
---


### A Cunning Plan

I just worked out that I can install restic in the kopia docker package which should at least help simplify things during testing.

```bash 
apk add restic 
``` 
so now have one minimal package with both applications using the same rclone config.

What could possibly go wrong?

<img src="https://upload.wikimedia.org/wikipedia/en/7/79/Roll_Safe_meme.jpg">

## Notification Programs

| Name | Website | Comments |
|---|---|---|
| Promethus | [link](https://github.com/prometheus/prometheus) | monitoring system and time series database |
| Uptime Kuma | [link](https://uptime.kuma.pet/) | Available as a Docker package on Unraid. Can use its own notification system (includes Apprise, Home Assistant and Signal) and detect lots of different statuses. |
| Apprise | [link](https://github.com/caronc/apprise)| A wrapper for lots of services for sending notifications. Available as a Docker package on Unraid |
| Notifiarr | [link](https://github.com/Notifiarr/notifiarr) | Sends notifications via Discord |
| Healthchecks | [link](https://healthchecks.io/)  |  Simple and Effective Cron Job Monitoring  |
| Shoutrrr | [link](https://github.com/containrrr/shoutrrr) | Notification library for gophers and their furry friends. |
| Howler | [link](https://github.com/Zggis/howler) | Log file monitor |
| Splunk | [link](https://www.splunk.com/)  | a Cisco company 😞 |
| iGotify | [link](https://github.com/androidseb25/iGotify-Notification-Assistent) | Send notifications to the Gotify iPhone app. |
| Ntfy | [link](https://ntfy.sh) | send notifications to ntfy app via scripts from any computer |
| Slackbot | [link](https://github.com/rockymadden/slack-cli?tab=readme-ov-file) | Create a slack bot |

## Backup Software

### Kopia

```bash
root@kopia:/# kopia --version
20240713.0.0- build:  from:
```

[Actions](https://kopia.io/docs/advanced/actions/)

### Restic

```bash
root@kopia:/# restic version
restic 0.16.5 compiled with go1.22.5 on linux/amd64
```

I've been playing with a wrapper for restic called [resticprofile](https://creativeprojects.github.io/resticprofile/). It lets you easily write a yaml script for restic, and includes scheduling and notifications via command hooks and http hooks.

```bash
resticprofile version
resticprofile version 0.27.1 commit eb130039b794e944223c7192673ccb04814347ca
```

My basic yaml is below (anything inside <> has been changed to protect my information).

```yaml
version: "1"

default:
  repository: "rclone:backblaze:<repository>"
  password-file: "password.txt"

  backup:
    verbose: true
    source:
      - "/home/me"
      - "/var/www/"

    schedule: "22:00"

    send-before:
      - method: POST
        url: <link to uptime kuma>

    run-before: '<link to apprise>'

    run-after: '<link to apprise>'

    run-after-fail: '<link to apprise>'
```

#### Restic Profile

https://creativeprojects.github.io/resticprofile/

#### Restic Exporter

https://github.com/ngosang/restic-exporter

#### Restic Shell Script

https://drwho.virtadpt.net/archive/2020-04-15/migrating-to-restic-for-offsite-backups/

#### Restic Exit Codes

https://forum.restic.net/t/restic-example-gists/1751/2