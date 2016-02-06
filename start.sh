#!/bin/sh
SCRIPTPATH=/usr/games/minecraft
SERVERPATH=/var/games/minecraft
SERVERNAME=default
SPIGOTFILE=spigot-1.8.8.jar
CONSOLE=$SCRIPTPATH/mineos_console.js
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
    sudo touch $SCRIPTPATH/.initialized
fi

# Generate SSL certificates
$SCRIPTPATH/generate-sslcert.sh

# Create default server
cd $SCRIPTPATH
sudo chmod ugo+x $CONSOLE
sudo $CONSOLE -s $SERVERNAME create 1000:1000
sudo -u $USER $CONSOLE -s $SERVERNAME accept_eula
sudo -u $USER cp $SERVERPATH/profiles/spigot_1.8.8/$SPIGOTFILE $SERVERPATH/servers/$SERVERNAME/
sudo -u $USER $CONSOLE -s $SERVERNAME modify_sc java jarfile $SPIGOTFILE
sudo -u $USER $CONSOLE -s $SERVERNAME start

# Starting Supervisor
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
