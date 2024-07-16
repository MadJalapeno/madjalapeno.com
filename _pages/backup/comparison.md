---
layout: static
title: Different Backup Solutions
parent: Backup
excerpt: Comparisons and tests
---

## The Requirements

I wanted software that was reliable, secure, space efficient, easy to use, and had some kind of notification system for successful/unsuccesful backups.

It had to be multi-platform, as I was planning for the situation where the original machine had died, and that was why I was needing to do a restore.

## The Contenders

After reading online I chose the following to evaluate:
* Restic
* Borg
* Duplicacy
* Duplicati
* Kopia
* Cloudberry Backup

## The Testing

I installed each package onto my Unraid server as a docker package. I then backed up two folders to an S3 off-site machine and noted the size. I then tried downloading a folder from the upload on a Mac and a PC to check it was possible to safely recover files when all I had was the keys and passwords. 

Total size of the source folders was:

| Folder | Content | Size |
| --- |---|---|
| appdata | Mix of text, databases and binaries and images | 1.1GB |
| YouTube | MP4 video files | 798M |

Everything was done on my Unraid server, which has a Xeon CPU and 16Gb ram, backing up to a Storj repository via a 1Gb internet connection. I set up a new docker image for debian linux to have a common base for everything.

```bash
apt update && apt upgrade

apt autoremove
```

## Details

### Restic
Restic is a very well regarded backup program that handles deduplication, compression and encryption well. Although it is command line based there are some very nice GUI's available to simplify operation. The use of RClone allows a large variety of repositories to be used. I tried the CLI and a GUI called backrest.



```bash
apt install rclone restic

rclone config file 

nano /root/.config/rclone/rclone.conf
```

paste the following in, changing the S3_ACCESS_KEY and S3_SECRET_ACCESS_KEY for the real keys. 

```
[storj]
type = s3
provider = Storj
access_key_id = S3_ACCESS_KEY
secret_access_key = S3_SECRET_ACCESS_KEY
endpoint = gateway.storjshare.io
chunk_size = 64Mi
disable_checksum: true
```

test and create a repository

```bash
rclone mkdir storj:restic-test
```

If all goes well there should be a new bucket showing up on the Storj project page.

```bash
restic -r rclone:storj:restic-test init
```

enter a password (I used '987654321' for these tests, but you should make sure it's decent, and keep it somewhere safe.)


```bash
restic -r rclone:storj:restic-test --verbose backup /mnt/user/appdata
```

This will add a snapshot of all the files in /mnt/user/appdata to the restic-test repository

```bash
open repository
enter password for repository: 
repository 7c3e17aa opened (repository version 2) successfully, password is correct
created new cache in /root/.cache/restic
lock repository
no parent snapshot found, will read all files
load index files
start scan on [/mnt/user/appdata]
start backup on [/mnt/user/appdata]
...
Files:        8456 new,     0 changed,     0 unmodified
Dirs:         2950 new,     0 changed,     0 unmodified
Data Blobs:   8364 new
Tree Blobs:   2891 new
Added to the repository: 983.611 MiB (752.289 MiB stored)

processed 8456 files, 1.007 GiB in 0:23
snapshot 2692b903 saved

```

and for the YouTube folder:

```bash
restic -r rclone:storj:restic-test --verbose backup /mnt/user/backups/DiskStation_1522/music/YouTube
open repository
enter password for repository: 
repository 7c3e17aa opened (repository version 2) successfully, password is correct
lock repository
no parent snapshot found, will read all files
load index files
start scan on [/mnt/user/backups/DiskStation_1522/music/YouTube]
start backup on [/mnt/user/backups/DiskStation_1522/music/YouTube]
scan finished in 0.469s: 5 files, 797.954 MiB

Files:           5 new,     0 changed,     0 unmodified
Dirs:            6 new,     0 changed,     0 unmodified
Data Blobs:    532 new
Tree Blobs:      7 new
Added to the repository: 797.992 MiB (798.022 MiB stored)

processed 5 files, 797.954 MiB in 0:20
snapshot 987e0c03 saved
```
Files restored with no problem using Backrest on Windows

### Borg

Borg doesn't use S3, which makes things a little more complicated to compare, but here goes.

```bash
apt install borgbackup
```
I'll be running this to backup to a local folder

```bash
borg init --encryption=repokey /mnt/user/borg/borg-test
Enter new passphrase: 
Enter same passphrase again: 
Do you want your passphrase to be displayed for verification? [yN]: y
Your passphrase (between double-quotes): "987654321"
Make sure the passphrase displayed above is exactly what you wanted.

By default repositories initialized with this version will produce security
errors if written to with an older version (up to and including Borg 1.0.8).

If you want to use these older versions, you can disable the check by running:
borg upgrade --disable-tam /mnt/user/borg/borg-test

See https://borgbackup.readthedocs.io/en/stable/changes.html#pre-1-0-9-manifest-spoofing-vulnerability for details about the security implications.

IMPORTANT: you will need both KEY AND PASSPHRASE to access this repo!
If you used a repokey mode, the key is stored in the repo, but you should back it up separately.
Use "borg key export" to export the key, optionally in printable format.
Write down the passphrase. Store both at safe place(s)
```

and then the same test

```bash
borg create --stats /mnt/user/borg/borg-test::test /mnt/user/appdata /mnt/user/backups/DiskStation_1522/music/YouTube
```
results:
```bash
borg create --stats /mnt/user/borg/borg-test::test /mnt/user/appdata /mnt/user/backups/DiskStation_1522/music/YouTube
Enter passphrase for key /mnt/user/borg/borg-test: 
------------------------------------------------------------------------------
Repository: /mnt/user/borg/borg-test
Archive name: test
Archive fingerprint: a491f987acfeb9159f81c0809c7aa1a6de2ee484088d0c052b74abb414fd3f3c
Time (start): Tue, 2024-07-16 14:13:54
Time (end):   Tue, 2024-07-16 14:14:43
Duration: 49.28 seconds
Number of files: 8463
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:                1.92 GB              1.74 GB              1.69 GB
All archives:                1.92 GB              1.74 GB              1.69 GB

                       Unique chunks         Total chunks
Chunk index:                    8517                 8967
------------------------------------------------------------------------------
```
To restore I wanted to use Windows, but there is no windows version. Instead I tried my Mac, first mounting the server folder.

```bash
borg list /Volumes/borg/borg-test
Failed to create/acquire the lock /Volumes/borg/borg-test/ 
        lock.exclusive ([Errno 13] Permission denied: 
        '/Volumes/borg/borg-test/lock.exclusive.10wh7oi0.tmp').
Traceback (most recent call last):
  File "/opt/homebrew/Cellar/borgbackup/1.4.0/libexec/lib/
        python3.12/site-packages/borg/archiver.py", line 5391, in main
    exit_code = archiver.run(args)
                ^^^^^^^^^^^^^^^^^^
  File "/opt/homebrew/Cellar/borgbackup/1.4.0/libexec/lib/
        python3.12/site-packages/borg/archiver.py", line 5309, in run
    rc = func(args)
         ^^^^^^^^^^
  File "/opt/homebrew/Cellar/borgbackup/1.4.0/libexec/lib/
        python3.12/site-packages/borg/archiver.py", line 176, in wrapper
    with repository:
  File "/opt/homebrew/Cellar/borgbackup/1.4.0/libexec/lib/
        python3.12/site-packages/borg/repository.py", line 217, in __enter__
    self.open(self.path, bool(self.exclusive), lock_wait=self.lock_wait, lock=self.do_lock)
  File "/opt/homebrew/Cellar/borgbackup/1.4.0/libexec/lib/
        python3.12/site-packages/borg/repository.py", line 465, in open
    self.lock = Lock(os.path.join(path, 'lock'), exclusive, timeout=lock_wait).acquire()
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/homebrew/Cellar/borgbackup/1.4.0/libexec/lib/
        python3.12/site-packages/borg/locking.py", line 398, in acquire
    with self._lock:
  File "/opt/homebrew/Cellar/borgbackup/1.4.0/libexec/lib/
        python3.12/site-packages/borg/locking.py", line 121, in __enter__
    return self.acquire()
           ^^^^^^^^^^^^^^
  File "/opt/homebrew/Cellar/borgbackup/1.4.0/libexec/lib/
        python3.12/site-packages/borg/locking.py", line 143, in acquire
    raise LockFailed(self.path, str(err)) from None
borg.locking.LockFailed: Failed to create/acquire the lock 
        /Volumes/borg/borg-test/lock.exclusive ([Errno 13] 
        Permission denied: '/Volumes/borg/borg-test/lock.exclusive.10wh7oi0.tmp').

Platform: Darwin Mac-mini-M1.local 23.5.0 Darwin Kernel Version 23.5.0: 
    Wed May  1 20:16:51 PDT 2024; root:xnu-10063.121.3~5/RELEASE_ARM64_T8103 arm64
Borg: 1.4.0  Python: CPython 3.12.4 msgpack: 1.0.8 fuse: None [pyfuse3,llfuse]
PID: 53272  CWD: /Users/michaelcole
sys.argv: ['/opt/homebrew/bin/borg', 'list', '/Volumes/borg/borg-test']
SSH_ORIGINAL_COMMAND: None
```

This, combined with the lack of S3 support meant I no longer considered using BorgBackup.

```bash
apt remove borgbackup
```

### Duplicacy

Everything is done via the GUI.

Initial upload to Storj took 3m:45s for /mnt/user/appdata with a file size of 695MB

Initial upload to Storj took 3m:55s for /mnt/user/backups/DiskStation_1522/music/YouTube with a file size of 799MB

When installed on Windows it sets up a server and uses the same GUI.

Restoring worked fine, and only took a few seconds.


### Duplicati

Note: Backup size is larger with Duplicati and Cloudberry as I needed to install them both.

Everything is configured using a nice GUI, using version: 2.0.8.1_beta_2024-05-07. 

Backup took 3m:13s, and was a total of 1.52 GB.

One very nice feature is the ability to verify files easily in the GUI.

However many users report having problems with the database the program uses, so tempted to pass on Duplicati.


### Kopia

All setup done via GUI and rclone. Only change from defaults was adding pgzip compression.

Initial upload to Storj took 32s for /mnt/user/appdata with a file size of 1.1 GB

Initial upload to Storj took 35s for /mnt/user/backups/DiskStation_1522/music/YouTube with a file size of 799MB

Restoring is really nice as you can mount the backup as a drive to browse.

### Cloudberry

Note: Backup size is larger with Duplicati and Cloudberry as I needed to install them both.

Cloudberry on unraid works as a VM, with a VNC type connection to the GUI. All very pretty, but it means you can not copy/paste Access Keys into the window, and as they're long I decided this made it unuseable. 

It's a shame, as I've used Cloudberry for many years at work.

## Final Results

| Program | Bucket Size | Time | Ease of use | Recovery |
| --- | --- | --- | --- | --- |
| Restic | 1.63 GB | 43s | command line is pretty simple | restored files using Backrest on Windows with no problem | 
| Borg| 1.69 GB | 49s (local) | command line is pretty simple | No windows version. Permission issues on MacOS. |
| Duplicacy | 1.5 GB | 7m:40s | GUI is clear | Restored individual files easily on Windows |
| Duplicati | 1.5 GB | 3m:13s | Easy to use GUI | 
| Kopia | 1.9 GB | 67s | GUI is a little confusing at first, but easy to use once you get the hang of it | Very easy |
| Cloudberry | - | - | Could not use a container is set up to not allow copy/paste of keys | |



