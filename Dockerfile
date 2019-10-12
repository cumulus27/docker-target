FROM tutum/lamp:latest
MAINTAINER Zhao Py <zhaopy4721@outlook.com>

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 1.2

# Preparation
RUN \
  rm -fr /app/* && \
  apt-get update && apt-get install -yqq wget unzip php5-gd && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://github.com/cumulus27/target-site/archive/v${VERSION}.zip && \
  unzip /v${VERSION}.zip && \
  rm -rf app/* && \
  cp -r /target-site-${VERSION}/* /app && \
  rm -rf /target-site-${VERSION} && \
  cp /app/config/config.inc.php.dist /app/config/config.inc.php && \
  sed -i "s/^\$_DVWA\[ 'db_user' \]     = 'root'/\$_DVWA[ 'db_user' ] = 'admin'/g" /app/config/config.inc.php && \
  echo "sed -i \"s/p@ssw0rd/\$PASS/g\" /app/config/config.inc.php" >> /create_mysql_admin_user.sh && \
  echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini && \
  sed -ri -e "s/^allow_url_include.*/allow_url_include = On/" /etc/php5/apache2/php.ini && \
  chmod a+w /app/hackable/uploads && \
  chmod a+w /app/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

EXPOSE 80 3306
CMD ["/run.sh"]
