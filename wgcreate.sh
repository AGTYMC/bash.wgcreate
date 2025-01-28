#!/usr/bin/env bash

SERVER_PUBLIC_KEY=
SERVER_ENDPOINT=
SERVER_ALLOWED_IPS=
SERVER_KEEPALIVE=

echo -n "Configfile (wg0, without '.conf'): "
read -r configFile

echo -n "Client name (new-client): "
read -r clientName

echo -n "Allowed IPs (10.10.20.101/32): "
read -r allowedIps

echo ${configFile}
echo ${clientName}
echo ${ip}

PRIVATE_KEY_FILE=client_${clientName}_private.key
PUBLIC_KEY_FILE=client_${clientName}_public.key

wg genkey | tee ${PRIVATE_KEY_FILE} | wg pubkey > ${PUBLIC_KEY_FILE}

PRIVATE_KEY=`cat ${PRIVATE_KEY_FILE}`
PUBLICK_KEY=`cat ${PUBLIC_KEY_FILE}`

echo "Insert new peer into ${configFile}.conf"

echo "" >> ${configFile}.conf
echo "#${clientName}" >> ${configFile}.conf
echo "[Peer]" >> ${configFile}.conf
echo "PublicKey = ${PUBLICK_KEY}" >> ${configFile}.conf
echo "AllowedIPs = ${allowedIps}" >> ${configFile}.conf

echo "Create config file for the [${clientName}] client"

echo "[Interface]" > ${clientName}.conf
echo "PrivateKey = ${PRIVATE_KEY}" >> ${clientName}.conf
echo "Address = ${allowedIps}" >> ${clientName}.conf
echo "" >> ${clientName}.conf
echo "[Peer]" >> ${clientName}.conf
echo "PublicKey = ${SERVER_PUBLIC_KEY}" >> ${clientName}.conf
echo "Endpoint = ${SERVER_ENDPOINT}" >> ${clientName}.conf
echo "AllowedIPs = ${SERVER_ALLOWED_IPS}" >> ${clientName}.conf
echo "PersistentKeepalive = ${SERVER_KEEPALIVE}" >> ${clientName}.conf