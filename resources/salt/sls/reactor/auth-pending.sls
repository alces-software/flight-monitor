{% if 'act' in data and data['act'] == 'pend' and data['id'].startswith('cnode') %}
  minion-add:
    wheel.key.accept:
      - match: {{ data['id'] }}

  slack-notif:
    runner.salt.cmd:
      - args:
        - fun: cmd.run
        - cmd: 'bash /opt/zabbix/srv/resources/salt/slack_notif.sh support-alerts-zabbix2 "Accepted new Salt key for {{ data['id'] }}"'
{% endif %}
