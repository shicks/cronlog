# cronlog

A simple tool to give more visibility into cron jobs

## Basic Usage

The basic usage is to prefix any jobs in your crontab with `cronlog`.  All output will be sent to `journalctl` or can be easily browsed via the webserver running at `localhost:5678`.

### .cronlog.env

Cronlog will source ~/.cronlog.env before running anything, so this would be a good place to augment the path as necessary (since `cron` typically has a very limited path).  For example:

```sh
cat > ~/.cronlog.env <<<EOF
PATH=$HOME/local/bin:$PATH
EOF
```

## Easy Install

Running `./install.sh` should take care of everything, but it does require entering a password for sudo.

### Manual Install

Copy `cronlog` to `/usr/bin` (one of the few locations generally available to cron via the limited PATH).  Note that it may be useful to add additional PATH entries to the top of the crontab file (e.g. via `PATH=/home/user/bin:/usr/bin:/bin`; the current PATH can be determined with a simple `* * * * * echo $PATH > /tmp/path` in the crontab).

To install the webserver, copy `cronlog.service` into `/etc/systemd/system`, replacing `USER` with your username, and then enable the service.

```sh
sed "s/USER/$(whoami)/" cronlog.service | sudo sponge /etc/systemd/system/cronlog.service
sudo systemctl daemon-reload
sudo systemctl enable cronlog
sudo service cronlog start
```

## Uninstall

To uninstall, run `./install.sh -u`, which expands to the following:

```sh
sudo service cronlog stop
sudo systemctl disable cronlog
sudo rm /usr/bin/cronlog /etc/systemd/system/cronlog.service
```
