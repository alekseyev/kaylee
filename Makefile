include userenv.sh
PHONY: setup-user setup-ssh setup-docker setup-guest deploy-update full-update

setup-user:
	echo "useradd $(USER) -p $(PASSWORD) -m -s /bin/bash -G sudo" | ssh root@$(HOST) ;\

setup-ssh:
	echo "rsync --archive --chown=$(USER):$(USER) ~/.ssh /home/$(USER)" | ssh root@$(HOST) ;\

setup-guest:
	scp guest.py root@$(HOST): ;\

setup-docker:
	( \
		cat install-docker.sh ;\
		echo "usermod -aG docker $(USER)" ;\
	) | ssh root@$(HOST) ;\

setup-server: setup-user setup-ssh setup-guest setup-docker

setup-proxy:
	( \
		echo "python3 guest.py $(APP_HOST) $(APP_PORT)" ;\
		echo "service nginx restart" ;\
	) | ssh root@$(HOST) ;\


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
		echo "docker-compose -f docker-compose-deploy.yml build --no-cache" ;\
		echo "docker-compose -f docker-compose-deploy.yml down " ;\
		echo "docker-compose -f docker-compose-deploy.yml up -d " ;\
	) | ssh $(USER)@$(HOST) ;\

logs:
	( \
		echo "cd $(PROJECT)" ;\
		echo "docker-compose -f docker-compose-deploy.yml logs -f --tail=100" ;\
	) | ssh $(USER)@$(HOST) ;\
