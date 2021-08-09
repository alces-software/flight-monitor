## Brief instructions on how to configure bacula slack notifications


Update `/var/lib/pgsql/data/pg_hba.conf` to trust local connections to DB:
```
# TYPE DATABASE USER ADDRESS METHOD
local  all      all          trust
```

Restart postgres `systemctl restart postgresql`

Place `notif.conf` and `slack.sh` from this directory into `/opt/bacula/slack/` on your Bacula director

Configure `notif.conf` with your SLACK_TOKEN for the associated Slack bot

Modify `slack.sh` slack msg to send to the correct slack channel (Replace `XXXXX` with cluster name):
```
  "channel": "XXXXX",
```

Ensure that `slack.sh` is executable with relevant `chmod` command

Update message resource in `bacula-dir.conf`
```
Messages {
  Name = Standard
  mailcommand = "/opt/bacula/slack/slack.sh %i"
..
}
```

Reload bacula config and test
```
sudo -u bacula /opt/bacula/bin/bconsole
reload
run job=Example-Job
quit
```
