# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maustel <maustel@student.42heilbronn.de    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/05/23 13:32:23 by maustel           #+#    #+#              #
#    Updated: 2025/05/23 13:32:23 by maustel          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#########################################################
################## DOCKER COMPOSE #######################
#########################################################

up: #env folders credentials build
	@echo "$(GRN)* Creating containers...$(WHITE)";
	cd srcs && docker compose up;

down:
	@echo "$(GRN)* Removing containers...$(WHITE)";
	cd srcs && docker compose down;

start:
	@echo "$(GRN)* Starting containers...$(WHITE)";
	cd srcs && docker compose start;

stop:
	@echo "$(GRN)* Stopping containers...$(WHITE)";
	cd srcs && docker compose stop;

##################################################
################# CLEANING #######################
##################################################

clean_con:
	@if [ $$(docker ps -qa | wc -l) -ge 1 ]; then docker rm $$(docker ps -qa); \
		echo "$(GRN)* All containers removed$(WHITE)"; fi

clean_img:
	@if [ $$(docker images -qa | wc -l) -ge 1 ]; then docker rmi -f $$(docker images -qa); \
		echo "$(GRN)* All images removed$(WHITE)"; fi

clean_net:
	@if [ $$(docker network ls -q | wc -l) -gt 3 ]; then docker network rm $$(docker network ls -q); \
		echo "$(GRN)* All networks removed$(WHITE)"; fi

clean_vol:
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); \
		echo "$(GRN)* All volumes removed$(WHITE)"; fi

#clean database of standard wordpess
clean_wp:
	echo "$(GRN) *cleaning wordpress database... $(WHITE)";
	@sudo find /home/maustel/data/wordpress -mindepth 1 -type f -delete
	@sudo find /home/maustel/data/wordpress -mindepth 1 -type d -empty -delete
	@sudo find /home/maustel/data/wordpress -mindepth 1 -type d -delete

clean_mdb:
	echo "$(GRN) *cleaning mariadb database... $(WHITE)";
	@sudo find /home/maustel/data/mariadb -mindepth 1 -type f -delete
	@sudo find /home/maustel/data/mariadb -mindepth 1 -type d -empty -delete
	@sudo find /home/maustel/data/mariadb -mindepth 1 -type d -delete

clean: clean_con clean_img clean_net clean_vol
fclean: clean clean_wp clean_mdb


##################################################
################# DISPLAY #######################
##################################################

display:
	@echo "$(BLU)------------------------ IMAGES ------------------------$(WHITE)";
	@docker images -a;

	@echo "$(BLU)---------------------- CONTAINERS ----------------------$(WHITE)";
	@docker ps -a;

	@echo "$(BLU)------------------------ VOLUMES -----------------------$(WHITE)";
	@docker volume ls;

	@echo "$(BLU)------------------------ NETWORKS ----------------------$(WHITE)";
	@docker network ls;

################# COLORS #######################
GRN	=	\033[0;32m
YEL	=	\033[0;33m
BLU	=	\033[0;34m
RED	=	\033[0;31m
WHITE	=	\033[0m
N	=	\033[1;30m
