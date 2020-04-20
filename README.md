# kaylee
The friendly space mechanic will fix your spaceship and help managing your remote Docker Compose deployments

## Initial setup

Run `inituserenv.sh` to generate `userenv.sh` from local linux user (it will ask for sudo password)

Alternatively create `userenv.sh` like this:
```
USER=username
PASSWORD=encrypted-password
```

## Setting up a new server

Supposedly you created a new Ubuntu 18.04 VM (eg a Digital Ocean droplet) and have ssh access for root user via SSH key. 

`HOST=address make setup-user` will create a user (using data from `userenv.sh`) on remote server and add it to sudo group

`HOST=address make setup-ssh` will copy `.ssh` directory from root's home directory to your new user's home directory (in case you want to log in via ssh as this user)

`HOST=address make setup-docker` will install docker and docker-compose and add your user to the docker group

`HOST=address make setup-server` will do all of the above


## Managing docker-compose

Supposedly your project has `docker-compose-deploy.yml` and the files are in the directory `~/$PROJECT` at `$HOST`

`HOST=address PROJECT=project SERVICES="a b c" make deploy-update` will log in to the server as your user, cd into a directory of your project, run git pull, rebuild and restart your services.

`HOST=address PROJECT=project make full-update` will do the same with rebuilding and restarting all your services
