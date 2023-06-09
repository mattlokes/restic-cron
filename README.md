[![Publish Docker image](https://github.com/mattlokes/restic-cron/actions/workflows/publish-docker-image.yaml/badge.svg)](https://github.com/mattlokes/restic-cron/actions/workflows/publish-docker-image.yaml) [![Docker Pulls](https://img.shields.io/docker/pulls/mattlokes/restic-cron.svg?maxAge=604800)](https://hub.docker.com/r/mattlokes/restic-cron/)

# restic-cron

Docker image to do Restic backups of a specific directory on a crontab schedule

## Container Environment Arguments
### Mandatory
* `ARG_BACKUP_DIR`     - Directory to backup to Restic Repo
* `ARG_BACKUP_REPO`    - Restic Repo
* `ARG_BACKUP_PASSWD`  - Restic Repo Password
* `ARG_BACKUP_CRONTAB` - Crontab to run backup on

### Optional
* `ARG_BACKUP_OPTS`     - Restic Options
* `ARG_BACKUP_HOSTNAME` - Hostname to use for the backup

## Container Volumes
* `/var/logs`       - Log directory
* `<DIR_TO_BACKUP>` - Directory to backup must be mounted either as bind or volume

> **Warning**
> The mount for `DIR_TO_BACKUP` must match the Env variable `ARG_BACKUP_DIR` or bad things will happen

## Docker Compose Example
``` yaml
version: "3.3"
services:
  restic-cron:
    container_name: restic-cron
    image: mattlokes/restic-cron:latest
    restart: unless-stopped
    volumes:
      - type: bind
        source: /srv/docker
        target: /srv/docker
    environment:
      ARG_BACKUP_HOSTNAME : ratchet
      ARG_BACKUP_DIR      : /srv/docker
      ARG_BACKUP_REPO     : rest:https://matt:blahblah1234@127.0.0.1
      ARG_BACKUP_PASSWD   : helloworld
      ARG_BACKUP_CRONTAB  : '0 2 * * *' # 2am everyday
```
