# Locations for project

SRCS		:= srcs
MARIADB		:= $(SRCS)/mariadb
NGINX		:= $(SRCS)/nginx
WORDPRESS	:= $(SRCS)/wordpress
SECRETS		:= $(SRCS)/.secrets
ENV_FILE	:= $(SRCS)/.env

# Location of persistent data

VOLUME				:= /home/$(USER)/data
VOLUME_MARIADB		:= $(VOLUME)/mariadb
VOLUME_WORDPRESS	:= $(VOLUME)/wordpress

DOCKER_COMPOSE	:= $(SRCS)/docker-compose.yml
DF				:= Dockerfile

RED			:= \033[31m
RESET		:= \033[0m

# command

RM	:= rm -rf

$(VOLUME):
	mkdir -p $(VOLUME)

$(VOLUME_MARIADB):
	mkdir -p $(VOLUME_MARIADB)

$(VOLUME_WORDPRESS):
	mkdir -p $(VOLUME_WORDPRESS)

all: up

up: $(ENV_FILE) $(DOCKER_COMPOSE) $(VOLUME) $(VOLUME_MARIADB) $(VOLUME_WORDPRESS)
	docker-compose -f $(DOCKER_COMPOSE) build

down: 
	docker-compose -f $(DOCKER_COMPOSE) down

clean: down
	$(RM) $(VOLUME_MARIADB) $(VOLUME_WORDPRESS)
	docker system prune -af
	docker volume prune -f

# Completely stop and delete all containers

fclean: clean
	docker stop $(docker ps -qa)
	docker rm $(docker ps -qa)
	docker rmi -f $(docker images -qa)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q)
#	2>/dev/null


re: down up

restart:

.PHONY: all env build clean fclean re restart