#!/bin/bash

systemctl start httpd
systemctl start mysqld

if [ -e /usr/local/share/racktables/init.sql ]
then
    cat /usr/local/share/racktables/init.sql | mysql -u root
    rm -f /usr/local/share/racktables/init.sql
fi

cat <<EOF >~/.bashrc trap
'/usr/local/bin/stop; exit 0' TERM
EOF

exec /bin/bash
