#!/bin/bash
# Script to setup pdsh / define genders

cat << EOF > 

node[x-x]   compute,cn
infra[x-x]  infra
login[x-x]  login
viz0[x-x]  login
master[x-x]  master
mds[x-x]  storage
oss[x-x]  storage
nfs[x-x]  storage

EOF 

 
