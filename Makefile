include userenv.sh
PHONY: setup-user setup-ssh setup-docker

setup-user:
	echo "useradd $(USER) -p $(PASSWORD) -m -s /bin/bash -G sudo" | ssh root@$(HOST) ;\

setup-ssh:
	echo "rsync --archive --chown=$(USER):$(USER) ~/.ssh /home/$(USER)" | ssh root@$(HOST) ;\

setup-docker:
	cat install-docker.sh | ssh root@$(HOST) ;\
	echo "usermod -aG docker ${USER}" | ssh root@$(HOST) ;\
	echo "systemctl status docker" | ssh root@$(HOST) ;\

setup-server: setup-user setup-ssh setup-docker
