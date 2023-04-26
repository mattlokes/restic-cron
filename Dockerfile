FROM alpine:3.15

ENV RESTIC_VERSION=0.15.1
ENV RESTIC_BIN=restic_${RESTIC_VERSION}_linux_amd64
ENV RESTIC_BZ2=${RESTIC_BIN}.bz2
ENV RESTIC_URL=https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/${RESTIC_BZ2}

# - Directory to backup to Restic Repo
ENV ARG_BACKUP_DIR=
# - Restic Repo URL
ENV ARG_BACKUP_REPO=
# - Restic Repo Password
ENV ARG_BACKUP_PASSWD=
# - Restic Options
ENV ARG_BACKUP_OPTS=

####################################  IMPORTANT  #####################################################
# a BIND_MOUNT to ARG_BACKUP_DIR must be made e.g:
# --mount type=bind,source=<ARG_BACKUP_DIR>,target=<ARG_BACKUP_DIR> -e ARG_BACKUP_DIR=<ARG_BACKUP_DIR>
######################################################################################################

# Install required packages
RUN apk add --update --no-cache bash dos2unix wget

RUN mkdir /restic
RUN cd /restic && \
    wget ${RESTIC_URL} && \
    bzip2 -d ${RESTIC_BZ2} && \
    chmod +x ${RESTIC_BIN} && \
    ln -s /restic/${RESTIC_BIN} /bin/restic

WORKDIR /usr/scheduler
VOLUME /var/logs

# Copy files
COPY setup.sh .

# Fix execute permissions
RUN find . -type f -iname "*.sh" -exec chmod +x {} \;

# Run cron on container startup
CMD ["./setup.sh"]
