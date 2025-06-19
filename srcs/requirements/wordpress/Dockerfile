FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y curl && \
	apt-get install less && \
    apt-get install -y php-fpm php-mysqli && \
    apt-get install -y mariadb-client

COPY ./tools/wp-setup.sh .
RUN chmod +x wp-setup.sh
# php configuration
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

#run script as main process of this container
# USER www-data
ENTRYPOINT ["./wp-setup.sh"]

