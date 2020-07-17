#!/bin/bash
# Script to setup pdsh / define genders

yum -y -e0 install pdsh pdsh-mod-genders -q

touch /etc/genders

cat << EOF > /etc/genders

node[x-x]   compute,cn
infra[x-x]  infra
login[x-x]  login
viz0[x-x]  login
master[x-x]  masters
mds[x-x]  storage
oss[x-x]  storage
nfs[x-x]  storage

EOF 

