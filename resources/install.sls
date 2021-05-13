zabbix_agent:
  file.managed:
    - name: /opt/zabbix/zabbix_agent.tgz
    - source: salt://zabbix_agent.tgz
    - makedirs: True
cd /opt/zabbix ; sudo tar -zxvf /opt/zabbix/zabbix_agent.tgz:
  cmd.run
zabbix-agent.service:
  file.managed:
    - name: /usr/lib/systemd/system/zabbix-agent.service
    - source: salt://zabbix-agent.service
    - makedirs: True
user_params:
  file.managed:
    - name: /opt/zabbix/conf/custom_checks/user_params.conf
    - source: salt://user_params.conf
    - makedirs: True
cd /opt/zabbix/scripts ; wget -r -nH --cut-dirs=3 --no-parent --reject="index.html*" --no-check-certificate http://fcgateway/resources/zabbix/custom_zabbix_checks:
  cmd.run
agentd:
  file.managed:
    - name: /opt/zabbix/conf/zabbix_agentd.conf
    - source: salt://zabbix_agentd.conf
    - makedirs: True
