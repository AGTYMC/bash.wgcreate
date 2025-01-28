# WG create v.1.0.4
This script helps you create a config file and add a new peer into your server config file.

## Create New Peer

### How to do
1. Login as root and enter into wireguard directory. Like as:
```
#> sudo su
#> cd /etc/wireguard 
```
2. Download the script

```
#> wget https://raw.githubusercontent.com/AGTYMC/bash.wgcreate/refs/heads/master/wgcreatepeer.sh
```

3. Change permissions and mods
```
#> chmod 700 wgcreate.sh
```

4. Add PublicKey, Endpoint, AllowedIps and PersistentKeepalive into wgcreate.sh
```
#> nano wgcreate.sh
SERVER_PUBLIC_KEY=your_server_public_key
SERVER_ENDPOINT=your_server_and_port (182.201.26.45:21800)
SERVER_ALLOWED_IPS=allowed_ips (10.10.20.0/24, 0.0.0.0:/0)
SERVER_KEEPALIVE=in_seconds (20)
```
5. Run the script
```
#> ./wgcreate.sh
Server's config file (wg0, without '.conf'): wg0
Client name (new-client): my-new-client
Allowed IPs (10.10.20.101/32): 10.10.20.10/32
Insert new peer into wg0.conf
Create config file for the [my-new-client] client 
```
All files inserted into the "my-new-client" folder.
```
#> ls -lah my-new-client
-rw------- 1 root root   45 Jan 28 11:17 client_my-new-client_private.key
-rw------- 1 root root   45 Jan 28 11:17 client_my-new-client_public.key
-rw------- 1 root root  244 Jan 28 11:17 my-new-client.conf
```

There are keys client_my-new-client_private.key and client_my-new-client_public.key. 
Into my-new-client.conf set configuration for a client machine.
```
#> cat my-new-client/my-new-client.conf
[Interface]
PrivateKey = MMh7CeAkgfC/AjMPALbPAAEMyvhTr061GBbW36fPZnU=
Address = 10.10.20.10/32

[Peer]
PublicKey = your_server_public_key
Endpoint = 182.201.26.45:21800
AllowedIPs = 10.10.30.0/24, 0.0.0.0:/0
PersistentKeepalive = 20
```
At last into wg0.conf added new strings for the peer.
```
#> nano wg0.conf
[Interface]
PrivateKey = your_server_private_key
Address = 10.10.20.1/32
ListenPort = 21800
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens160 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o ens160 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens160 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o ens160 -j MASQUERADE

#new-client
[Peer]
PublicKey = nGY77tsBvFwPCDPqI17H8+XRDixAkysNy5MtkTwpxgI=
AllowedIPs = 10.10.20.10/32
```

6. Restart WG
```
#> systemctl restart wg-quick@wg0
OR
#> wg-quick down wg0 && wg-quick up wg0
```
### In the end
After all, copy the client config file into the client machine and add into WG-client program