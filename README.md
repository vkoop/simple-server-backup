# Simple backup
Bash scripts to backup servers using rsync.

## Configuration
```
BASEBACKUPFOLDER - path to the backup directory
SSHPASSFILE - ssh key used for authentication
SSHUSERNAME - ssh username
SERVERHOST - ip/name of the server
SERVERNAME - name that should be used for the server (used to name directories)
REMOTESRC - data path on the server
DB_USERNAME - db username
DB_PASSWORD - db password
DB_NAME - db name
EXCLUDES - path to exclude during rsync e.g.: 

EXCLUDES=("logs" "system/tmp")
```

## Supported tasks
### Backup data
Backup server data with a given config

```
backup_server.sh <PATH_TO_THE_CONFIG>
```

### Restore data

### Backup db
Backup db with a given config.

```
backup_db.sh <PATH_TO_THE_CONFIG>
```

### Restore db

### Backup all servers
Looks through the config folder and starts the db and data backup for all configured servers.

```
backup_all_servers.sh
```