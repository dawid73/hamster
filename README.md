
## Installation

```bash
git clone <this_repository>
cd hammster
chmod +x run_backup.sh
chmod +x run_sync.sh
```
Add to `/etc/hosts`:
```bash
# Example:
192.168.0.104 srv-backup
```
You must be able to access the remote server using an SSH key
```bash
ssh user@srv-backup
```
If this command does not connect to the server without a password, you must generate a public key and upload it to the remote server. Use: `ssh-keygen` and `ssh-copy-id`


## Test

You can generate random directories and files to test this script. Use

```bash
bash generate_random_files.sh <direcory>
```


## Usage/Examples

```bash
# Create directory where script will create archives:
mkdir /backups/

# Add task in cron
# In this example backup run every day. Create archive at 5:30 am and synchronize at 6:00 pm
# The file /tmp/hamster-runing  is to block the start of the next task if the previous one has not been completed

30 5 * * * flock /tmp/hamster-runing /<directory>/run_backup.sh /backup/ /var/www/html/ 3
0 6 * * * flock /tmp/hamster-runing /<directory>/run_sync.sh 1 /backup/ user srv-backup /home/user/backup
```

