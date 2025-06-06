# Locations for project

SRCS		:= srcs
ENV_FILE	:= $(SRCS)/.env
NETWORK		:= inslaption
MARIADB		:= mariadb
WORDPRESS	:= wordpress

# Location of persistent data

#VOLUME				:= /home/$(USER)/data
VOLUME				:= $(HOME)/data
VOLUME_MARIADB		:= $(VOLUME)/mariadb
VOLUME_WORDPRESS	:= $(VOLUME)/wordpress

COMPOSE			:= docker-compose -f
DOCKER_COMPOSE	:= $(SRCS)/docker-compose.yml

REMOVE	:= sudo rm -rf

all: checks up

checks:
	@if ! docker info > /dev/null 2>&1; then \
		echo "Error: Docker is not running."; \
		exit 1; \
	fi
	@if [ ! -f $(ENV_FILE) ]; then \
	echo "Error: no .env file found in location $(ENV_FILE)"; \
	exit 1; \
	fi

up:
	@mkdir -p $(VOLUME_MARIADB)
	@mkdir -p $(VOLUME_WORDPRESS)
	$(COMPOSE) $(DOCKER_COMPOSE) up --build -d

start:
	$(COMPOSE) $(DOCKER_COMPOSE) start

stop:
	$(COMPOSE) $(DOCKER_COMPOSE) stop

down: 
	$(COMPOSE) $(DOCKER_COMPOSE) down

clean: down
#	$(COMPOSE) $(DOCKER_COMPOSE) down
	docker network rm $(NETWORK)
	docker volume rm $(VOLUME_MARIADB) $(VOLUME_WORDPRESS)

re: down up

fullre: clean all

.PHONY: all env build clean fclean re restart down up