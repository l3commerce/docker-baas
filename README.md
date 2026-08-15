# Docker BaaS (Backup as a Service)

A lightweight and flexible system for local and remote backups (databases and files) and project management, powered by Docker and Make.

---

## Project Structure

* **backups/** - Directory for storing generated archives

* **configs/** - Configuration files (.env) for each project

* **nginx/** - Nginx configurations and protected spaces

* **ssh/** - SSH keys for remote host access
* **scripts** - directory containing scripts. It is automatically baked in the image during build. And scripts are run directly from the container itself. If you made changes to those, you should rebuild the imige for the changes to take effect.
---

## Requirements

* **Docker** & **Docker Compose**

* **Make**

---

## Setup

* Copy the example configuration file into the configs/ directory and rename it according to your project (e.g., vagrant.env):
cp configs/example.env configs/vagrant.env

* Fill in the required database parameters and remote SFTP/SSH storage settings in your created .env file.

* Place the corresponding SSH keys into the ssh/ directory and set the proper security permissions (e.g., chmod 600 for private keys).
* build the image for the executing container:
```bash
docker build -t petar1v/docker-baas:1.0
```

* make new user and password for the web
```bash
make secure user=admin pass=password
```
* up the web server to serve your backups
```bash
docker compose up -d
```

---

## Usage (Make Commands)

All operations are managed via Make. Here are the available targets and usage examples:

* Test scripts inside the container:
```bash
make test
```

* Create a local SQL backup:
```bash
make backup-db project=vagrant
```

* Create a remote SQL backup:
```bash
make backup-db-remote project=vagrant
```

* Create a remote files backup:
```bash
make backup-files project=vagrant
```

* Restore a local database:
```bash
make restore-db project=vagrant backup-name=mysql_backup_2026_08_15.tar.gz
```

* Restore a database from a remote archive:
```bash
make restore-db-remote project=vagrant backup-name=mysql_backup_2026_08_15.tar.gz
```

* Restore arbitrary folders/files:
```bash
make restore-files project=vagrant restored-dir=/home/vagrant backup-name=files_backup_2026_08_15.tar.gz
```

* Clean up backups for a given project:
```bash
make clean-backups project=vagrant
```

* Generate an .htpasswd file for Nginx protection:
```bash
make secure user=admin pass=secretpassword
```