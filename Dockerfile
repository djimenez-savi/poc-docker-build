FROM docker.io/nginx

WORKDIR /usr/share/nginx/html/

COPY ./index.html index.html
COPY ./version.txt version.txt

RUN sed -i "s/version/$(cat ./version.txt)/" index.html
