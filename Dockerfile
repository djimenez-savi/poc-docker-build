FROM docker.io/nginx

ARG VERSION=1.0.0

WORKDIR /usr/share/nginx/html/

COPY ./index.html index.html

RUN sed -i "s/version/${VERSION}/" index.html
