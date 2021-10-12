{% if data['id'].startswith('cnode') %}

  state-apply:
    local.state.apply:
      - tgt: {{ data['id'] }}

  zabbix-frontend:
    runner.salt.cmd:
      - args:
        - fun: cmd.run
        - cmd: 'bash /opt/zabbix/srv/resources/salt/frontend_zab.sh {{ data['id'] }}'

  slack-notif:
    runner.salt.cmd:
      - args:
        - fun: cmd.run
        - cmd: 'bash /opt/zabbix/srv/resources/salt/slack_notif.sh hyperion "Adopted {{ data['id'] }}"'

  adoption-finished:
    local.cmd.run:
      - tgt: {{ data['id'] }}
      - arg:
        - 'touch /tmp/fcops_adopted'

{% endif %}
