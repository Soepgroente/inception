# Locations for project

SRCS		:= srcs
ENV_FILE	:= $(SRCS)/.env
NETWORK		:= inslaption
MARIADB		:= mariadb
WORDPRESS	:= wordpress

# Location of persistent data

VOLUME				:= /home/$(USER)/data
VOLUME_MARIADB		:= $(VOLUME)/mariadb
VOLUME_WORDPRESS	:= $(VOLUME)/wordpress

DOCKER_COMPOSE	:= ./$(SRCS)/docker-compose.yml

REMOVE	:= sudo rm -rf

$(VOLUME_MARIADB):
	mkdir -p $(VOLUME_MARIADB)

$(VOLUME_WORDPRESS):
	mkdir -p $(VOLUME_WORDPRESS)

all: check_env up

check_env:
	if [ ! -f $(ENV_FILE) ]; then \
	echo "Error: no .env file found in location $(ENV_FILE)"; \
	exit 1; \
	fi

up: $(VOLUME_MARIADB) $(VOLUME_WORDPRESS)
	sudo docker-compose -f $(DOCKER_COMPOSE) up --build -d

start:
	sudo docker-compose -f $(DOCKER_COMPOSE) start

stop:
	sudo docker-compose -f $(DOCKER_COMPOSE) stop

down: 
	sudo docker-compose -f $(DOCKER_COMPOSE) down

clean:
	sudo docker-compose -f $(DOCKER_COMPOSE) down -v
	sudo docker system prune -af
	sudo docker volume prune -f
	$(REMOVE) $(VOLUME_MARIADB)
	$(REMOVE) $(VOLUME_WORDPRESS)

fclean: clean
	sudo docker volume rm $(MARIADB) $(WORDPRESS)
	sudo docker network rm $(NETWORK)
#	2>/dev/null

re: clean up

restart: fclean up

.PHONY: all env build clean fclean re restart