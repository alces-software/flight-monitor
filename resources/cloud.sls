zabbix-server:
  file.replace:
  - name: /opt/zabbix/conf/zabbix_agentd.conf
  - pattern: 'Server=fcgateway'
  - repl: 'Server=cfcgateway'

{# Fixes signal 11 every ~30 seconds if Server!=ServerActive #}
zabbix-active-server:
  file.replace:
  - name: /opt/zabbix/conf/zabbix_agentd.conf
  - pattern: 'ServerActive=fcgateway'
  - repl: 'ServerActive=cfcgateway'
