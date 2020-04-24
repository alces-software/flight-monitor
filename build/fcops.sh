#!/bin/bash


#Mount exports from fcm-exports.sh
####
#Setup /usr/local/sbin/fcmaintenancemode
cat << 'EOF' > /usr/local/sbin/fcmaintenancemode
#Check for arg
setupmaint_test () {
        #Setup PATHS
	#Mount Scripts
}

help () {
   # Display Help
   echo "A utility to enable/disable ops team commands"
   echo
   echo "Syntax: fcmaintenancemode [--on|--off]"
   echo "options:"
   echo "--on       Enables ops team commands/scripts"
   echo "--off      Disables ops team commands/scripts"
   echo "--help     Prints this Help"
   echo
}



while test $# -gt 0
do
    case "$1" in
        --on) echo "option on"
                setupmaint_test
            ;;
        --off) echo "option off"
            ;;
	--help) #Display Help
		help
	    ;;
        --*) echo "bad option $1"
            ;;
    esac
    shift
done
EOF

chmod +x /usr/local/sbin/fcmaintenancemode

#Set PATH with tools/cmds
#DailyCheck
