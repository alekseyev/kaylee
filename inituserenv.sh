USER=`whoami`
PASSWORD=`sudo cat /etc/shadow | grep $USER | python -c "import sys; line=sys.stdin.read().split(':'); sys.stdout.write(line[1])"`

echo USER=$USER > userenv.sh
echo PASSWORD=$PASSWORD >>userenv.sh
