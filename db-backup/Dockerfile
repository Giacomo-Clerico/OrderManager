FROM alpine:latest

RUN apk add --no-cache \
    postgresql-client \
    bash \
    gzip \
    curl \
    aws-cli \
    cronie \
    tzdata

COPY backup.sh /backup.sh
COPY crontab /etc/crontabs/root

RUN chmod +x /backup.sh

CMD ["crond", "-f"]

