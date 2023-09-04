FROM docker.io/nginx

ARG VERSION

WORKDIR /usr/share/nginx/html/

COPY ./index.html index.html

RUN sed -i 's/version/${VERSION}/' index.html
