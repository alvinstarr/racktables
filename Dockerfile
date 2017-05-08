FROM centos/systemd


RUN yum install -y epel-release && yum -y update && yum -y clean all
RUN yum install -y mysql mysql-server php php-mysqlnd php-pdo php-gd php-mbstring php-bcmath httpd tar RackTables


ADD rc.local /etc/rc.local
ADD init.sql /usr/share/RackTables/init.sql
ADD racktables.conf /etc/httpd/conf.d/racktables.conf
ADD secret.php /etc/RackTables/secret.php

RUN chmod 700 /etc/rc.local
RUN chown apache:apache /etc/RackTables/secret.php
RUN chmod 440 /etc/RackTables/secret.php

RUN chown mysql.mysql /var/log/mariadb
RUN chmod 750 /var/log/mariadb
RUN sed --in-place -e "s/log-error/#log-error/g" /etc/my.cnf
RUN sed -ri 's!^(\s*CustomLog)\s+\S+!\1 "|$/usr/bin/cat >\&1"!g; s!^(\s*ErrorLog)\s+\S+!\1 "|$/usr/bin/cat >\&2"!g;' /etc/httpd/conf/httpd.conf




ADD start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start
ADD stop.sh /usr/local/bin/stop
RUN chmod +x /usr/local/bin/stop
RUN systemctl enable mariadb.service
RUN systemctl enable httpd.service
RUN systemctl enable rc-local.service

EXPOSE 80
EXPOSE 3306

CMD ["/usr/sbin/init"]
