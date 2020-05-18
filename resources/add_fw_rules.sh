# Script to add fw rules to login nodes (Sec changes May 2020)
hosts=(
91.196.70.109
149.156.26.227
149.156.26.56
159.226.234.29
51.77.135.89
51.15.177.65
51.75.52.118
51.75.144.43
51.79.53.139
51.79.86.181
212.83.166.62
159.226.88.110
159.226.62.107
159.226.170.127
202.120.32.231
159.226.161.107
)

#echo ${hosts[*]}

for host in "${hosts[@]}"; do
echo "Host is" $host
	firewall-cmd --add-rich-rule="rule family='ipv4' source address='$host' reject" --zone external
done
