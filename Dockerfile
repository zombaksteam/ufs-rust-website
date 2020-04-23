FROM vladimirok5959/nginx-php-fpm:1.0.0
MAINTAINER zombaksteam <zombaksteam@gmail.com>

ENV MYSQL_USER=root \
	MYSQL_PASS=root \
	MYSQL_BASE=ufssite \
	MYSQL_HOST=127.0.0.1

COPY --chown=www-data:www-data ./htdocs /var/www/html
