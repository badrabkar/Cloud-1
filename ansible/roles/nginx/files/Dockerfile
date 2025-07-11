FROM debian:11


RUN apt update 
RUN apt upgrade -y 
RUN apt install nginx -y 
RUN apt install openssl -y 
RUN mkdir -p /etc/nginx/ssl 


COPY tools/script.sh /etc
RUN chmod +x /etc/script.sh

COPY conf/nginx.conf /etc/nginx/conf.d/nginx.conf

ENTRYPOINT [ "/etc/script.sh" ]