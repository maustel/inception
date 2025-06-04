FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y curl && \
	apt-get install less && \
    apt-get install -y php-fpm php-mysqli && \
    apt-get install -y mariadb-client

# FROM ubuntu
CMD ["tail", "-f", "/dev/null"]
