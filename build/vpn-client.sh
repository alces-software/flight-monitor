#!/bin/bash

echo "Installing openvpn"
yum install epel-release -y -q
yum install openvpn -y -q

cat << EOF > /etc/openvpn/fcmonitor.conf
client
dev tun0
proto tcp
remote gateway.alces-flight.com 2005
resolv-retry infinite
nobind
persist-key
persist-tun
<ca>
-----BEGIN CERTIFICATE-----
MIIE3TCCA8WgAwIBAgIJALkwLvje8YdBMA0GCSqGSIb3DQEBCwUAMIGgMQswCQYD
VQQGEwJVSzEUMBIGA1UECAwLT3hmb3Jkc2hpcmUxDzANBgNVBAcMBk94Zm9yZDEZ
MBcGA1UECgwQQWxjZXMgRmxpZ2h0IEx0ZDEXMBUGA1UECwwOSW5mcmFzdHJ1Y3R1
cmUxETAPBgNVBAMMCENoYW5nZU1lMSMwIQYJKoZIhvcNAQkBFhRzc2xAYWxjZXMt
ZmxpZ2h0LmNvbTAeFw0yMDAyMDYxNjU1NTRaFw0zMDAyMDMxNjU1NTRaMIGgMQsw
CQYDVQQGEwJVSzEUMBIGA1UECAwLT3hmb3Jkc2hpcmUxDzANBgNVBAcMBk94Zm9y
ZDEZMBcGA1UECgwQQWxjZXMgRmxpZ2h0IEx0ZDEXMBUGA1UECwwOSW5mcmFzdHJ1
Y3R1cmUxETAPBgNVBAMMCENoYW5nZU1lMSMwIQYJKoZIhvcNAQkBFhRzc2xAYWxj
ZXMtZmxpZ2h0LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMSm
kQhLgB2qWQ3sL1Q2GwLvdmylR0u8zaUc+vLE966c2Pyd6DcZw30v/KjvguF9otXj
Z835LShSnPTeOZiy3t2L/p0colJML2pECFkjneKl3Tk0Xyns897vnBQTwgU0+qI8
brgeoq4CTokBw6uskLXQ9WBA+eMk5hYe4uh+ga5x716N4HH13Bqp9qCj5IEcPV2C
Jfl3hTQxqKMYAlfrsGyxZ+KEG8QEkA7d9kXmqyrGBzM25ANY/b9LQG2U7geLnhSa
ZDysaOiodksoWaKgi8fqoWUmBcQUCHc6cDsOVx4cBEncmy4JOtYeWz6RkczItIkT
8PqkTT2pXUEOxF/UfI0CAwEAAaOCARYwggESMB0GA1UdDgQWBBStiZw19XmYwnFv
dR06Pe6sJiPqhDCB1QYDVR0jBIHNMIHKgBStiZw19XmYwnFvdR06Pe6sJiPqhKGB
pqSBozCBoDELMAkGA1UEBhMCVUsxFDASBgNVBAgMC094Zm9yZHNoaXJlMQ8wDQYD
VQQHDAZPeGZvcmQxGTAXBgNVBAoMEEFsY2VzIEZsaWdodCBMdGQxFzAVBgNVBAsM
DkluZnJhc3RydWN0dXJlMREwDwYDVQQDDAhDaGFuZ2VNZTEjMCEGCSqGSIb3DQEJ
ARYUc3NsQGFsY2VzLWZsaWdodC5jb22CCQC5MC743vGHQTAMBgNVHRMEBTADAQH/
MAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOCAQEAHuEL/hOZVN4Rkt/Tkxp2
/miWerlRbSBTKbFt0TA1MX+ecGerQ5Zpcdx5kYswJzvYfRDVSy/u2Wkw+euYNUpl
ojEu/iF1Vo3RR3fyj3BuVBrCfaNdTyBj9X3OXs6cOD/zpOos+yXVojnFr1lTtjn0
zQo7RpNVvKnatPKirh6nNI0sPEEX1dR6+P5Tb+mt9BL5pIA9y/qU5ibC4AGsJFVq
A++V1PiI35cxNI1VPasWcNR6WQnSxfwZXry7M2bosQe1PwPFb2c4JL2xjc5GryI/
5uGoC1ghA/g030xNc8LNWmeXM8FPyzPweiRseJ+Sdi9Vjx9NekN3QFBitO2Xf5cZ
bQ==
-----END CERTIFICATE-----
</ca>
auth-user-pass auth.fcmonitor
ns-cert-type server
comp-lzo
verb 3
EOF

echo -n "Enter your fcops VPN Username: "; read CLUSTERNAME
echo -n "Enter your fcops VPN Password: "; read PASSWORD
cat << EOF > /etc/openvpn/auth.fcmonitor
${CLUSTERNAME}
${PASSWORD}
EOF

chmod 600 /etc/openvpn/auth.fcmonitor

systemctl start openvpn@fcmonitor
systemctl enable openvpn@fcmonitor

#Add hub to local hosts
echo "10.178.0.1   hub.fcops.alces-flight.com hub" >> /etc/hosts


sleep 15 #Gives openvpn a chance to start up before below test!

#Testing openvpn is setup
if  ping -c 1 10.178.0.1 ; then
        echo "openvpn setup tested with success"
	echo -e "\033[0;32m==== VPN SETUP COMPLETE ====\033[0m"
	echo "Now VPN is enabled, please run script /tmp/fcm-fcops_webserver.sh to complete setup"
else
	echo -e "\033[0;31m==== VPN SETUP INCOMPLETE ====\033[0m"
	echo "please re-run script and check credentials"
fi
