---
layout: static
title: Setting up Rclone and Kopia
parent: Backup
excerpt: How to set up a free 25Gb backup solution to Storj
---


1. Download and install rclone and kopia. I used [scoop](https://scoop.sh/) for installing rclone as it sets up all the paths, etc.

2. Find where rclone keeps it's config file by typing 

```shell
rclone config file 
```
Edit as shown below replacing S3_ACCESS_KEY and S3_SECRET_ACCESS_KEY with your Storj bucket credentials:

```shell
[storj]
type = s3
provider = Storj
access_key_id = S3_ACCESS_KEY
secret_access_key = S3_SECRET_ACCESS_KEY
endpoint = gateway.storjshare.io
chunk_size = 64Mi
disable_checksum: true
```

3. In a console window set up the bucket.

```shell
rclone mkdir storj:my-bucket
```