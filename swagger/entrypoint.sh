#!/bin/sh
envsubst < /usr/share/nginx/html/swagger-server-url.js.template > /usr/share/nginx/html/swagger-server-url.js
exec /docker-entrypoint.sh nginx -g 'daemon off;'