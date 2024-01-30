# Variables -------------------------------------------------------------------

NAME		= inception
SRCS		= ./srcs
COMPOSE		= $(SRCS)/docker-compose.yml
HOST_URL	= vegret.42.fr

# Rules -----------------------------------------------------------------------

all: $(NAME)

$(NAME): up

# Ajoute l'url puis demarre les containers
up: create_dir
	@sudo hostsed add 127.0.0.1 $(HOST_URL) > $(HIDE) && echo " $(HOST_ADD)"
	@docker compose -p $(NAME) -f $(COMPOSE) up --build || (echo " $(FAIL)" && exit 1)
	@echo " $(UP)"

# Stop les containers
down:
	@docker compose -p $(NAME) down
	@echo " $(DOWN)"

create_dir:
	@mkdir -p ~/data/database
	@mkdir -p ~/data/wordpress_files

# Fait une sauvegarde des du dossier contenant les donnees
backup:
	@if [ -d ~/data ]; then sudo tar -czvf ~/data.tar.gz -C ~/ data/ > $(HIDE) && echo " $(BKP)" ; fi

# Stop les containers puis supprime les fichiers
clean:
	@docker compose -f $(COMPOSE) down -v
	@if [ -n "$$(docker ps -a --filter "name=nginx" -q)" ]; then docker rm -f nginx > $(HIDE) && echo " $(NX_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=wordpress" -q)" ]; then docker rm -f wordpress > $(HIDE) && echo " $(WP_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=mariadb" -q)" ]; then docker rm -f mariadb > $(HIDE) && echo " $(DB_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=redis" -q)" ]; then docker rm -f redis > $(HIDE) && echo " $(RD_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=adminer" -q)" ]; then docker rm -f adminer > $(HIDE) && echo " $(AM_CLN)" ; fi

# Sauvegarde les fichiers avant de les supprimer
fclean: clean backup
	@sudo rm -rf ~/data
	@if [ -n "$$(docker image ls $(NAME)-nginx -q)" ]; then docker image rm -f $(NAME)-nginx > $(HIDE) && echo " $(NX_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-wordpress -q)" ]; then docker image rm -f $(NAME)-wordpress > $(HIDE) && echo " $(WP_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-mariadb -q)" ]; then docker image rm -f $(NAME)-mariadb > $(HIDE) && echo " $(DB_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-redis -q)" ]; then docker image rm -f $(NAME)-redis > $(HIDE) && echo " $(RD_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-adminer -q)" ]; then docker image rm -f $(NAME)-adminer > $(HIDE) && echo " $(AM_FLN)" ; fi
	@sudo hostsed rm 127.0.0.1 $(HOST_URL) > $(HIDE) && echo " $(HOST_RM)"

status:
	@clear
	@echo "\nCONTAINERS\n"
	@docker ps -a
	@echo "\nIMAGES\n"
	@docker image ls
	@echo "\nVOLUMES\n"
	@docker volume ls
	@echo "\nNETWORKS\n"
	@docker network ls --filter "name=$(NAME)_all"
	@echo ""

# Supprime tout les containers et leurs fichiers
prepare:
	@echo "\nPreparing to start with a clean state..."
	@echo "\nCONTAINERS STOPPED\n"
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa) ;	fi
	@echo "\nCONTAINERS REMOVED\n"
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa) ; fi
	@echo "\nIMAGES REMOVED\n"
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa) ; fi
	@echo "\nVOLUMES REMOVED\n"
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q) ; fi
	@echo "\nNETWORKS REMOVED\n"
	@if [ -n "$$(docker network ls -q) " ]; then docker network rm $$(docker network ls -q) 2> /dev/null || true ; fi 
	@echo ""

re: fclean all

# Customs ----------------------------------------------------------------------

HIDE		= /dev/null 2>&1

RED			= \033[0;31m
GREEN		= \033[0;32m
RESET		= \033[0m

MARK		= $(GREEN)✔$(RESET)
ADDED		= $(GREEN)Added$(RESET)
REMOVED		= $(GREEN)Removed$(RESET)
STARTED		= $(GREEN)Started$(RESET)
STOPPED		= $(GREEN)Stopped$(RESET)
CREATED		= $(GREEN)Created$(RESET)
EXECUTED	= $(GREEN)Executed$(RESET)

# Messages --------------------------------------------------------------------

UP			= $(MARK) $(NAME)		$(EXECUTED)
DOWN		= $(MARK) $(NAME)		$(STOPPED)
FAIL		= $(RED)✔$(RESET) $(NAME)		$(RED)Failed$(RESET)

HOST_ADD	= $(MARK) Host $(HOST_URL)		$(ADDED)
HOST_RM		= $(MARK) Host $(HOST_URL)		$(REMOVED)

NX_CLN		= $(MARK) Container nginx		$(REMOVED)
WP_CLN		= $(MARK) Container wordpress		$(REMOVED)
DB_CLN		= $(MARK) Container mariadb		$(REMOVED)
RD_CLN		= $(MARK) Container redis		$(REMOVED)
AM_CLN		= $(MARK) Container adminer		$(REMOVED)

NX_FLN		= $(MARK) Image $(NAME)-nginx	$(REMOVED)
WP_FLN		= $(MARK) Image $(NAME)-wordpress	$(REMOVED)
DB_FLN		= $(MARK) Image $(NAME)-mariadb	$(REMOVED)
RD_FLN		= $(MARK) Image $(NAME)-redis	$(REMOVED)
AM_FLN		= $(MARK) Image $(NAME)-adminer	$(REMOVED)

BKP			= $(MARK) Backup at $(HOME)	$(CREATED)

# Phony -----------------------------------------------------------------------

.PHONY: all up down create_dir clean fclean status backup prepare re