app:
	cd docker/php/ && docker build -t local/enecsys-php:8.2 .

db:
	cd docker/mariadb/ && docker build -t local/enecsys-mariadb:10.6 .

