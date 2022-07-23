GO_SERVICE_NAME:=isuports.service

.PHONY: initmysql
initmysql:
	cat sql/admin/10_schema.sql sql/admin/90_data.sql | mysql -pisucon

.PHONY: deploy
deploy:
	bash ./deploy.sh

.PHONY: log
log:
	sudo journalctl -u ${GO_SERVICE_NAME} -n10 -f

.PHONY: analyze
analyze:
	bash ./analyze.sh > analyze_result

.PHONY: pprof
pprof:
	docker compose -f docker-compose-go.yml run webapp go tool pprof -http=0.0.0.0:1080 http://localhost:6060/debug/pprof/profile

.PHONY: setup
setup:
	wget https://github.com/tkuchiki/alp/releases/download/v1.0.9/alp_linux_amd64.zip;
	sudo apt install unzip;
	unzip alp_linux_amd64.zip;
	sudo install ./alp /usr/local/bin;sudo apt update;sudo apt install -y percona-toolkit graphviz
	rm -f alp alp_linux_amd64.zip;

.PHONY: conf
conf:
	cp /etc/nginx/nginx.conf ./nginx1.conf
	cp /etc/nginx/nginx.conf ./nginx2.conf
	cp /etc/nginx/nginx.conf ./nginx3.conf
	cp /etc/mysql/mysql.conf.d/mysqld.cnf ./mysqld.cnf
