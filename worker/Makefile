name = GitLab runner

NO_COLOR=\033[0m		# Color Reset
COLOR_OFF='\e[0m'       # Color Off
OK_COLOR=\033[32;01m	# Green Ok
ERROR_COLOR=\033[31;01m	# Error red
WARN_COLOR=\033[33;01m	# Warning yellow
RED='\e[1;31m'          # Red
GREEN='\e[1;32m'        # Green
YELLOW='\e[1;33m'       # Yellow
BLUE='\e[1;34m'         # Blue
PURPLE='\e[1;35m'       # Purple
CYAN='\e[1;36m'         # Cyan
WHITE='\e[1;37m'        # White
UCYAN='\e[4;36m'        # Cyan

all:
	@printf "$(OK_COLOR)==== Launch configuration ${name}...\n... ====$(NO_COLOR)\n"
	@printf "Command:$(WARN_COLOR)sudo gitlab-runner start$(NO_COLOR)\n"
	@sudo gitlab-runner start

help:
	@printf "$(OK_COLOR)==== All commands of ${name} configuration ====$(NO_COLOR)\n"
	@printf "$(WARN_COLOR)- make				: Launch configuration$(NO_COLOR)\n"
	@printf "$(WARN_COLOR)- make build			: Create new runner$(NO_COLOR)\n"
	@printf "$(WARN_COLOR)- make down			: Stopping configuration$(NO_COLOR)\n"
	@printf "$(WARN_COLOR)- make ps			: View configuration$(NO_COLOR)\n"
	@printf "$(WARN_COLOR)- make re			: Restart configuration$(NO_COLOR)\n"
	@printf "$(WARN_COLOR)- make clean			: Destroy configuration$(NO_COLOR)\n"
	@printf "$(WARN_COLOR)- make  fclean			: Forced destroy all$(NO_COLOR)"

build:
	@printf "$(OK_COLOR)==== Building configuration ${name}... ====$(NO_COLOR)\n"
	@printf "Command:$(WARN_COLOR)gitlab-ci-multi-runner register$(NO_COLOR)\n"
	@gitlab-ci-multi-runner register

down:
	@printf "$(ERROR_COLOR)==== Stopping configuration ${name}... ====$(NO_COLOR)\n"
	@printf "Command:$(WARN_COLOR)sudo gitlab-runner stop$(NO_COLOR)\n"
	@sudo gitlab-runner stop
	@sudo gitlab-runner status

ps:
	@printf "$(BLUE)==== View configuration ${name}... ====$(NO_COLOR)\n"
	@printf "Command:$(WARN_COLOR)gitlab-runner list$(NO_COLOR)\n"
	@gitlab-runner list

re:
	@printf "$(OK_COLOR)==== Restart configuration ${name}... ====$(NO_COLOR)\n"
	@printf "Command:$(WARN_COLOR)sudo systemctl restart gitlab-runner$(NO_COLOR)\n"
	@sudo systemctl restart gitlab-runner
	@sudo gitlab-runner status

clean:
	@printf "$(ERROR_COLOR)==== Destroy configuration ${name}... ====$(NO_COLOR)\n"
	@sudo gitlab-runner stop
	@sudo gitlab-runner status
	@sudo systemctl disable gitlab-runner

fclean:
	@printf "$(ERROR_COLOR)==== Force destroy configurations ====$(NO_COLOR)\n"
	@sudo gitlab-runner stop
	@sudo gitlab-runner status
	@sudo apt-get remove gitlab-runner
	@sudo rm -rf /etc/gitlab-runner
	@sudo rm -rf /usr/local/bin/gitlab-runner
	@sudo userdel gitlab-runner
	@sudo rm -rf /home/gitlab-runner/
	@sudo systemctl disable gitlab-runner
	@sudo systemctl daemon-reload

.PHONY	: all help build down re ps clean fclean