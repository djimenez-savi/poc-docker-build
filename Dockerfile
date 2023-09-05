FROM public.ecr.aws/docker/library/nginx:latest

ARG VERSION

WORKDIR /usr/share/nginx/html/

COPY ./index.html index.html

RUN sed -i "s/version/${VERSION}/" index.html
