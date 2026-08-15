.PHONY: test backup-db backup-db-remote restore-db restore-db-remote clean-backups secure

test:
	docker run --rm petar1v/docker-baas:1.0 -c "ls -la scripts"

# make backup-db project=site1
backup-db:
	@if [ -z "$(project)" ]; then \
		echo "Usage: make backup-db project=site1"; \
		exit 1; \
	fi
	docker run --rm \
		--env-file ./configs/$(project).env \
		--network="host" \
		-v $(shell pwd)/ssh:/root/.ssh:ro \
		-v $(shell pwd)/backups:/var/www/backups \
		petar1v/docker-baas:1.0 \
		/app/scripts/backup_sql.sh

# make backup-db-remote project=site1
backup-db-remote:
	@if [ -z "$(project)" ]; then \
		echo "Usage: make backup-db-remote project=site1"; \
		exit 1; \
	fi
	docker run --rm \
		--env-file ./configs/$(project).env \
		--network="host" \
		-v $(shell pwd)/ssh:/root/.ssh:ro \
		-v $(shell pwd)/backups:/var/www/backups \
		petar1v/docker-baas:1.0 \
		/app/scripts/backup_sql_remote.sh

# make restore-db project=site1 backup-name=backup.tar.gz
restore-db:
	@if [ -z "$(project)" ] || [ -z "$(backup-name)" ]; then \
		echo "Usage: make restore-db project=site1 backup-name=mysql_backup_2026_08_14.tar.gz"; \
		exit 1; \
	fi
	docker run --rm \
		--env-file ./configs/$(project).env \
		-e BACKUP_NAME="$(backup-name)" \
		--network="host" \
		-v $(shell pwd)/ssh:/root/.ssh:ro \
		-v $(shell pwd)/backups:/var/www/backups \
		petar1v/docker-baas:1.0 \
		/app/scripts/restore_sql.sh

# make restore-db-remote project=site1 backup-name=backup.tar.gz
restore-db-remote:
	@if [ -z "$(project)" ] || [ -z "$(backup-name)" ]; then \
		echo "Usage: make restore-db-remote project=site1 backup-name=mysql_backup_2026_08_14.tar.gz"; \
		exit 1; \
	fi
	docker run --rm \
		--env-file ./configs/$(project).env \
		-e BACKUP_NAME="$(backup-name)" \
		--network="host" \
		-v $(shell pwd)/ssh:/root/.ssh:ro \
		-v $(shell pwd)/backups:/var/www/backups \
		petar1v/docker-baas:1.0 \
		/app/scripts/restore_sql_remote.sh

# make backup-files project=site1 backuped-dir=/home/user/media
backup-files:
	@if [ -z "$(project)" ] || [ -z "$(backuped-dir)"]; then \
		echo "Usage: make backup-files project=site1 backuped-dir=/home/user/media"; \
		exit 1; \
	fi
	docker run --rm \
		--env-file ./configs/$(project).env \
		-e BACKUPED_DIR="$(backuped-dir)" \
		--network="host" \
		-v $(shell pwd)/ssh:/root/.ssh:ro \
		-v $(shell pwd)/backups:/var/www/backups \
		petar1v/docker-baas:1.0 \
		/app/scripts/backup_files.sh

# make restore-files project=site1 restored-dir=/home/user/media backup-name=files_backup.tar.gz
restore-files:
	@if [ -z "$(project)" ] || [ -z "$(restored-dir)"] || [ -z "$(backup-name)" ]; then \
		echo "Usage: make restore-files project=site1 restored-dir=/home/user/media" backup-name=files_backup.tar.gz; \
		exit 1; \
	fi
	docker run --rm \
		--env-file ./configs/$(project).env \
		-e RESTORED_DIR="$(restored-dir)" \
		-e BACKUP_NAME="$(backup-name)" \
		--network="host" \
		-v $(shell pwd)/ssh:/root/.ssh:ro \
		-v $(shell pwd)/backups:/var/www/backups \
		petar1v/docker-baas:1.0 \
		/app/scripts/restore_files.sh

# make clean-backups project=site1
clean-backups:
	@if [ -z "$(project)" ]; then \
		echo "Usage: make clean-dir project=site1"; \
		exit 1; \
	fi
	docker run --rm \
	-v $(shell pwd)/backups:/var/www/backups \
	petar1v/docker-baas:1.0 \
	-c "rm -rf /var/www/backups/$(project)/*"

# make secure user=myadmin pass=secretpassword
secure:
	@mkdir -p ./nginx/conf.d
	@if [ -z "$(user)" ] || [ -z "$(pass)" ]; then \
		echo "Error: Please enter username and password!"; \
		echo "Example: make secure user=admin pass=mypass123"; \
		exit 1; \
	fi
	@echo "$(user):$$(echo "$(pass)" | openssl passwd -6 -stdin)" > ./nginx/conf.d/.htpasswd
	@echo "Done! File ./nginx/conf.d/.htpasswd is created for username '$(user)'."