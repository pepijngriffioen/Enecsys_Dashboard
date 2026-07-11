FROM php:8.2-apache-trixie

ARG UID=1000
ARG GID=$UID
ARG NAME=pi

RUN docker-php-ext-install pdo_mysql mysqli sockets

RUN apt-get update && apt-get install -y cron \
  && apt autoremove -yqq --purge \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*


# Setup a non-root user
RUN groupadd --system --gid ${GID} ${NAME} \
 && useradd --system --gid ${GID} --uid ${UID} --create-home ${NAME}

COPY --chown=${UID}:${GID} ./src /var/www/html
RUN mkdir /var/www/html/backups/files/
RUN chmod 777 /var/www/html/backups/files

RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

RUN usermod -a -G www-data ${NAME}

COPY --chown=${UID}:${GID} ./entrypoint.sh /usr/local/bin/docker-php-entrypoint
RUN chmod 755 /usr/local/bin/docker-php-entrypoint

RUN chmod 777 /var/www/html/include/config.php

USER ${NAME}
