# Simple Backup

Bash scripts to simplify server backups and data synchronization using rsync and database dump tools.

## Getting Started

1. **Create Configuration File(s):**
   * Copy the `config.example` file to a new file for each server you want to back up (e.g., `cp config.example config/my_server.conf`).
   * It's recommended to store these configuration files in a dedicated directory, for example, `config/`. The `backup_all_servers.sh` script typically looks for configurations in this `config/` subdirectory.
   * Edit your new configuration file (e.g., `config/my_server.conf`) and populate it with the necessary parameters. Refer to the comments within `config.example` for details on each parameter.

2. **Setup SSH Access:**
   * Ensure your SSH key (specified by `SSHPASSFILE` in the config) allows passwordless login to the remote server(s).
   * Run the SSH setup script. This script usually iterates through servers defined in your configuration files (e.g., in the `config/` directory) and adds their host keys to `~/.ssh/known_hosts`.

     ```bash
     ./setup_ssh.sh
     ```

   * *Note: Ensure `setup_ssh.sh` has execution permissions (`chmod +x setup_ssh.sh`). This applies to all scripts.*

3. **Perform Backups:**
   * **Backup all configured servers (data and databases):**

     ```bash
     ./backup_all_servers.sh
     ```

   * **Backup a specific server's data:**

     ```bash
     ./backup_server.sh path/to/your_server.conf
     ```

   * **Backup a specific server's database:**

     ```bash
     ./backup_db.sh path/to/your_server.conf
     ```

## Configuration Details

To configure the backup scripts for a server:

1. Copy the provided `config.example` file to a new name (e.g., `cp config.example config/my_server.conf`).
2. Edit your newly created configuration file, uncommenting and setting values for all required parameters.

All parameters are documented directly within the `config.example` file, which indicates whether each setting is required or optional and provides example values.

## Available Scripts and Operations

All scripts should be run from the directory where they are located. Ensure they have execute permissions (e.g., `chmod +x *.sh`).

### 1. Setup

* **`setup_ssh.sh`**:
  * Prepares SSH connections by adding host keys of configured servers to `~/.ssh/known_hosts`.
  * It typically discovers servers from configuration files (e.g., in a `config/` directory).
  * **Usage:** `./setup_ssh.sh`

### 2. Full Backup

* **`backup_all_servers.sh`**:
  * Automates backups for all servers defined in configuration files (usually in a `config/` directory).
  * For each server, it performs both data backup (like `backup_server.sh`) and database backup (if DB details are configured, like `backup_db.sh`).
  * **Usage:** `./backup_all_servers.sh`

### 3. Data Operations

* **`backup_server.sh <CONFIG_FILE>`**:
  * Backs up data from the remote server specified in the `<CONFIG_FILE>` using rsync.
  * **Usage:** `./backup_server.sh path/to/your_server.conf`
* **`sync_data <CONFIG_FILE> [OPTIONS]`**:
  * Synchronizes data between the backup storage, your local machine, and the remote server.
  * **Options:**
    * `-d <YYYY-MM-DD>`: Specifies the date of the backup to use for restoration.
    * `--btos`: Restore **B**ackup **to** **S**erver.
    * `--ltos`: Sync **L**ocal data **to** **S**erver.
    * `--stol`: Sync **S**erver data **to** **L**ocal.
  * **Usage Examples:**
    * Restore data to server: `./sync_data path/to/config.conf -d 2023-10-26 --btos`
    * Sync local data to server: `./sync_data path/to/config.conf --ltos`
    * Sync server data to local: `./sync_data path/to/config.conf --stol`

### 4. Database Operations

* **`backup_db.sh <CONFIG_FILE>`**:
  * Backs up the database from the remote server specified in `<CONFIG_FILE>`.
  * Requires `DB_USERNAME`, `DB_PASSWORD`, and `DB_NAME` to be set in the config.
  * **Usage:** `./backup_db.sh path/to/your_server.conf`
* **`sync_db <CONFIG_FILE> [OPTIONS]`**:
  * Synchronizes a database between the backup storage, your local machine, and the remote server.
  * **Options:** (Same as `sync_data`)
    * `-d <YYYY-MM-DD>`
    * `--btos`
    * `--ltos`
    * `--stol`
  * **Usage Examples:**
    * Restore DB to server: `./sync_db path/to/config.conf -d 2023-10-26 --btos`
    * Sync local DB to server: `./sync_db path/to/config.conf --ltos`
    * Sync server DB to local: `./sync_db path/to/config.conf --stol`
