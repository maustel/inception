FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y &&\
	apt-get install -y nginx &&\
	apt-get install openssl

COPY ./tools/maustel.conf /etc/nginx/conf.d/maustel.conf
# RUN rm -rf /etc/nginx/sites-enabled/default

RUN openssl req \
	-x509 \
	-nodes \
	-days 365 \
	-subj "/C=IT/ST=Lecco/O=maustelcompany/CN=localhost" \
	-newkey rsa:2048 \
	-keyout "/etc/ssl/private/maustel.42.fr.key" \
	-out "/etc/ssl/certs/maustel.42.fr.crt";

ENTRYPOINT [ "/usr/sbin/nginx" ]
CMD [ "-g", "daemon off;" ]

#-------------------------------- explanations ---------------------------------

#maustel.conf is copied into /etc/nginx/conf.d/ because all files in this directory
#(and /etc/nginx/sites-enabled) are included in /etc/nginx/nginx.conf
#this is why it is good practice to remove all default files in these directories

# openssl req: Generate a self-signed certificate request
# x509: Create a self-signed certificate (instead of a certificate signing request)
# nodes:
# days 365: Set certificate validity period to one year
# subj:	params "/C=country/ST=state/O=company/CN=sitename"
# newkey rsa:2048 Generate a new RSA private key with 2048-bit length
# keyout: Output filename for the generated private key
# out: Output filename for the generated self-signed certificate

#ENTRYPINT [ "/usr/sbin/nginx" ]: sets nginx as main process (PID 1)
#ensures nginx alway runs as primary process in this container

#CMD [ "-g", "daemon off;" ]: keeps nginx  in the forground
#enables proper signal handling for container lifecycle events
