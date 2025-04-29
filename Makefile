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

DOCKER_COMPOSE	:= ./$(SRCS)/docker-compose.yml

# command

REMOVE	:= sudo rm -rf

$(VOLUME):
	mkdir -p $(VOLUME)

$(VOLUME_MARIADB):
	mkdir -p $(VOLUME_MARIADB)

$(VOLUME_WORDPRESS):
	mkdir -p $(VOLUME_WORDPRESS)

up: 
	docker-compose -f $(DOCKER_COMPOSE) --build -d

all: $(ENV_FILE) $(DOCKER_COMPOSE) $(VOLUME) $(VOLUME_MARIADB) $(VOLUME_WORDPRESS)
	up

down: 
	sudo docker-compose -f $(DOCKER_COMPOSE) down

clean: down
	docker system prune -af
	docker volume prune -f
	$(REMOVE) $(VOLUME_MARIADB)
	$(REMOVE) $(VOLUME_WORDPRESS)

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