FROM nginx:latest
COPY ./default.nginx.conf /etc/nginx/conf.d/default.conf
