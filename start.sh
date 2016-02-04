#!/bin/sh
SCRIPTPATH=/usr/games/minecraft
USER=minecraft

echo 
echo
echo  MINEOS CONTAINER - starting services...
echo
echo

# Changing password
if [ ! -f $SCRIPTPATH/.initialized ]; then
    if [ "$PASSWORD" = "" ]; then
        PASSWORD=`pwgen 10 1`
        echo "Login password is \"$PASSWORD\""
    fi
    echo "$USER:$PASSWORD" | chpasswd
    sudo -u $USER touch $SCRIPTPATH/.initialized
fi

# Generate SSL certificates
$SCRIPTPATH/generate-sslcert.sh

# Starting Supervisor
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

