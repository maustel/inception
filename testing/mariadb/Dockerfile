FROM debian:bullseye

RUN apt-get update && \
	apt-get install -y && \
	apt-get install -y mariadb-server
	# mariadb-client \
	# && rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf etc/mysql/mariadb.conf.d/50-server.cnf

#adjust the file permissions to avoid that file is ignored due to security vulnarablity
RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chown mysql:mysql /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy scripts for entrypoint and initialization
COPY tools/entrypoint.sh /entrypoint.sh

# Make scripts executable
RUN chmod +x /entrypoint.sh

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
