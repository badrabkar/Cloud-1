FROM debian:11


RUN apt update 
RUN apt upgrade -y 
RUN apt install nginx -y 
RUN apt install openssl -y 
RUN mkdir -p /etc/nginx/ssl 
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/example.key \
    -out /etc/nginx/ssl/example.crt \
    -subj "/C=aa/ST=ad/L=ta/O=as/OU=as/CN=as/emailAddress=as"

COPY tools/script.sh /etc
RUN chmod +x /etc/script.sh

# COPY conf/nginx.conf /etc/nginx/conf.d/nginx.conf

ENTRYPOINT [ "/etc/script.sh" ]