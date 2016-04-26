# raspberry-spy
A script to take photos from a raspberry pi camera and sync them to google drive.

## installing
**Nota Bene:** For now, the script is hardwired to live in `$HOME`. This should change as the script is refined.
- clone or copy the script to `$HOME`
- create the local sync dir: `mkdir -p $HOME/monitor/snaps`
- [install](https://github.com/prasmussen/gdrive#installation) `gdrive` (follow the linked instructions making sure you get the 'arm' version for the raspberry pi)
- run `gdrive about` to connect `gdrive` to your Google Drive account
- copy/symlink the `gdrive` executable to `$HOME/.bin/`
- create the remote sync dir: `gdrive mkdir <YOUR NAME HERE>`
- copy the resulting file id to `PARENT_ID` at the top of the script
- *optional:* create cron jobs to take photos at intervals
- *required:* sit back and watch your drive for shiny new photos from your pi

## helpful cron jobs
### a photo every minute
`* * * * * <path/to/file>/snap-n-upload.sh [> <path/to/optional/logfile>.log]`
### reboot to unstick your jobs
`@reboot rm -rf <path/to/lockdir> # This makes sure you begin fresh on startup.`
