# raspberry-spy
A script to take photos from a raspberry pi camera and sync them to google drive.

## helpful cron jobs
### a photo every minute
`* * * * * <path/to/file>/snap-n-upload.sh [> <path/to/optional/logfile>.log]`
### reboot to unstick your jobs
`@reboot rm -rf <path/to/lockdir> # This makes sure you begin fresh on startup.`
