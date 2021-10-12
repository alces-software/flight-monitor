/opt/zabbix:
  file.directory:
    - user: fcops
    - group: fcops
/opt/zabbix/run:
  file.directory:
    - user: fcops
    - group: fcops
/opt/zabbix/scripts:
  file.directory:
    - user: fcops
    - group: fcops
/opt/zabbix/logs:
  file.directory:
    - user: fcops
    - group: fcops
/opt/zabbix/conf:
  file.directory:
    - user: fcops
    - group: fcops
/opt/zabbix/conf/custom_checks:
  file.directory:
    - user: fcops
    - group: fcops
/var/log/zabbix:
  file.directory:
    - user: fcops
    - group: fcops
zabbix_agent:
  file.managed:
    - name: /opt/zabbix/zabbix_agent.tgz
    - source: salt://fcops/zabbix_agent.tgz
    - makedirs: True
cd /opt/zabbix ; sudo tar -zxvf /opt/zabbix/zabbix_agent.tgz:
  cmd.run
zabbix-agent.service:
  file.managed:
    - name: /usr/lib/systemd/system/zabbix-agent.service
    - source: salt://fcops/zabbix-agent.service
    - makedirs: True
user_params:
  file.managed:
    - name: /opt/zabbix/conf/custom_checks/user_params.conf
    - source: salt://fcops/user_params.conf
    - makedirs: True
cd /opt/zabbix/scripts ; wget -r -nH --cut-dirs=3 --no-parent --reject="index.html*" --no-check-certificate http://fcgateway/resources/zabbix/custom_zabbix_checks:
  cmd.run
agentd:
  file.managed:
    - name: /opt/zabbix/conf/zabbix_agentd.conf
    - source: salt://fcops/zabbix_agentd.conf
    - makedirs: True
zabbix-agent:
  service.running:
    - enable: True
