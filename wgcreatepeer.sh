#!/usr/bin/env bash

SERVER_PUBLIC_KEY=
SERVER_ENDPOINT=
SERVER_ALLOWED_IPS=
SERVER_KEEPALIVE=

echo -n "Server's config file (wg0, without '.conf'): "
read -r configFile

echo -n "Client name (new-client): "
read -r clientName

echo -n "Allowed IPs (10.10.20.101/32): "
read -r allowedIps

mkdir "${clientName}"

PRIVATE_KEY_FILE=${clientName}/client_${clientName}_private.key
PUBLIC_KEY_FILE=${clientName}/client_${clientName}_public.key

wg genkey | tee ${PRIVATE_KEY_FILE} | wg pubkey > ${PUBLIC_KEY_FILE}

PRIVATE_KEY=`cat ${PRIVATE_KEY_FILE}`
PUBLICK_KEY=`cat ${PUBLIC_KEY_FILE}`

echo ""

echo "Insert the new peer into ${configFile}.conf"
echo "" >> ${configFile}.conf
echo "#${clientName}" >> ${configFile}.conf
echo "[Peer]" >> ${configFile}.conf
echo "PublicKey = ${PUBLICK_KEY}" >> ${configFile}.conf
echo "AllowedIPs = ${allowedIps}" >> ${configFile}.conf

echo "Create the config file for the [${clientName}] client"
echo "[Interface]" > ${clientName}/${clientName}.conf
echo "PrivateKey = ${PRIVATE_KEY}" >> ${clientName}/${clientName}.conf
echo "Address = ${allowedIps}" >> ${clientName}/${clientName}.conf
echo "" >> ${clientName}/${clientName}.conf
echo "[Peer]" >> ${clientName}/${clientName}.conf
echo "PublicKey = ${SERVER_PUBLIC_KEY}" >> ${clientName}/${clientName}.conf
echo "Endpoint = ${SERVER_ENDPOINT}" >> ${clientName}/${clientName}.conf
echo "AllowedIPs = ${SERVER_ALLOWED_IPS}" >> ${clientName}/${clientName}.conf
echo "PersistentKeepalive = ${SERVER_KEEPALIVE}" >> ${clientName}/${clientName}.conf

chmod -R 600 ${clientName}

echo -e "\nDONE\n"
echo "Restart WG-server if all right"
echo -e "\n\t systemctl restart wg-quick@${configFile}"
echo -e "\t OR"
echo -e "\t wg-quick down ${configFile} && wg-quick up ${configFile}"
echo ""