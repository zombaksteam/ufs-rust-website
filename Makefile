docker-build:
	@-docker rmi ufs-web-server:latest
	docker build -t ufs-web-server:latest ./

docker-export:
	@-rm ./build/ufs-web-server.tar
	docker save ufs-web-server:latest > ./build/ufs-web-server.tar

docker-import:
	@-docker rmi ufs-web-server:latest
	docker load < ./build/ufs-web-server.tar

docker-test:
	docker run --rm \
		--network host \
		--name ufs-web-server-test \
		-e MYSQL_USER="root" \
		-e MYSQL_PASS="root" \
		-e MYSQL_BASE="ufssite" \
		-e MYSQL_HOST="127.0.0.1" \
		-v /etc/timezone:/etc/timezone:ro \
		-it ufs-web-server:latest

dev:
	docker run --rm \
		--network host \
		--name ufs-web-server-dev \
		-e MYSQL_USER="root" \
		-e MYSQL_PASS="root" \
		-e MYSQL_BASE="ufssite" \
		-e MYSQL_HOST="127.0.0.1" \
		-v /etc/timezone:/etc/timezone:ro \
		-v ${UFS_RUST_WEBSITE}/htdocs:/var/www/html \
		-it ufs-web-server:latest
