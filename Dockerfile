
FROM alpine:latest

RUN apk add --no-cache curl jq

COPY entrypoint.sh /entrypoint.sh
COPY cleanup.sh /cleanup.sh

ENTRYPOINT ["/entrypoint.sh"]
