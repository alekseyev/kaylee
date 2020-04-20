include userenv.sh
PHONY: setup-user setup-ssh setup-docker deploy-update full-update

setup-user:
	echo "useradd $(USER) -p $(PASSWORD) -m -s /bin/bash -G sudo" | ssh root@$(HOST) ;\

setup-ssh:
	echo "rsync --archive --chown=$(USER):$(USER) ~/.ssh /home/$(USER)" | ssh root@$(HOST) ;\

setup-docker:
	cat install-docker.sh | ssh root@$(HOST) ;\
	echo "usermod -aG docker $(USER)" | ssh root@$(HOST) ;\
	echo "systemctl status docker" | ssh root@$(HOST) ;\

setup-server: setup-user setup-ssh setup-docker

deploy-update:
	( \
		echo "cd $(PROJECT)" ;\
		echo "git pull" ;\
		echo "docker-compose -f docker-compose-deploy.yml build $(SERVICES)" ;\
		echo "docker-compose -f docker-compose-deploy.yml stop $(SERVICES)" ;\
		echo "docker-compose -f docker-compose-deploy.yml up --no-deps -d $(SERVICES)" ;\
	) | ssh $(USER)@$(HOST) ;\

full-update:
	( \
		echo "cd $(PROJECT)" ;\
		echo "git pull" ;\
		echo "docker-compose -f docker-compose-deploy.yml build " ;\
		echo "docker-compose -f docker-compose-deploy.yml down " ;\
		echo "docker-compose -f docker-compose-deploy.yml up -d " ;\
	) | ssh $(USER)@$(HOST) ;\
