for filesystem in $(grep findmnt /opt/zabbix/conf/custom_checks/barkla_orig_user_params.conf |awk '{print $6}') ; do sed -i "s#findmnt -nr -o source -T $filesystem -O rw > /dev/null &&#mount |grep $filesystem > /dev/null#g" /opt/zabbix/conf/custom_checks/barkla_orig_user_params.conf ; done

