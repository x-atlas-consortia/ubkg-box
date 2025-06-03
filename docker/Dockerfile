# parent image: nginx web server
FROM nginx:1.27.3-alpine
# custom nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf
# guesdt static content
COPY hmtl/*.html /usr/share/nginx/html/
