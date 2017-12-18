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

LOCAL_DATA_TARGET - local path that should be used when syncing server with local data with sync_data
```

## Supported tasks

### Setup

Executes ssh-keyscan for configured servers and adds them to known_hosts.

```bash
setup_ssh.sh
```

### Backup all servers

Looks through the config folder and starts the db and data backup for all configured servers.

```bash
backup_all_servers.sh
```

### Backup data

Backup server data with a given config

```bash
backup_server.sh <PATH_TO_THE_CONFIG>
```

### Restore data to server from backup direcotry

```bash
sync_data <PATH_TO_CONFIG> -d <DATE_TO_BE_RESTORED> --btos
```

### Sync local data to server

```bash
sync_data <PATH_TO_CONFIG> --ltos
```

### Sync server data to local

```bash
sync_data <PATH_TO_CONFIG> --stol
```

### Backup db

Backup db with a given config.

```bash
backup_db.sh <PATH_TO_THE_CONFIG>
```

### Restore db from backup directory

```bash
sync_db <PATH_TO_CONFIG> -d <DATE_TO_BE_RESTORED> --btos
```


### Sync local db to server

```bash
sync_db <PATH_TO_CONFIG> --ltos
```

### Sync server db to local

```bash
sync_db <PATH_TO_CONFIG> --stol
```
