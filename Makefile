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

all: env build

env:
	if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED)Error: environment variable not found at $(ENV_FILE)!"$(RESET); \
		exit 1; \
	fi

build: $(DOCKER_COMPOSE)
	@echo "Building containers..."
	@docker-compose -f $(DOCKER_COMPOSE) build

up: build

clean:

# Completely stop and remove all containers

fclean: clean

re:

restart:

.PHONY: all env build clean fclean re restart