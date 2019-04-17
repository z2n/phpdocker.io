build-backend-php:
	docker build --target=deployment -t backend-php -f backend/docker/php-fpm/Dockerfile ./backend/

start:
	docker-compose up -d

stop:
	docker-compose kill

install-dependencies:
	cd ./frontend; yarn install
	cd ./admin; yarn install
	composer -o install --working-dir backend/

init: stop clean install-dependencies start load-fixtures

clean: stop
	docker-compose rm -f
	cd ./frontend; sudo rm -rf node_modules
	cd ./admin; sudo rm -rf node_modules

load-fixtures:
	cd ./backend; ./console doctrine:schema:update --force; ./console doctrine:fixtures:load -n

open-frontend:
	xdg-open http://localhost:5000

open-admin:
	xdg-open http://localhost:5001

open-content-api:
	xdg-open http://localhost:5002/content

open-mailhog:
	xdg-open http://localhost:5003/

open-api-profiler:
	xdg-open http://localhost:5002/_profiler/latest?limit=10