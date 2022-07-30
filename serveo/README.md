## WARNING

I'm not creator of `serveo.net`. All Your traffic can be eavesdropped by the owner of this server. **In case You have external IP I recommend to use DuckDNS or any other dynamic DNS service**. 

## About

This addon allows you to easly expose Your hassio to the internet using HTTPS thanks to [Serveo](https://serveo.net) service.

You **DO NOT** need to:

  * have external IP
  * make any router configuration (no need to forward any port)
  * create any logins (DuckDNS and others dynamic DNS services require all this hassle)
  * pay any fee

## Features:

 * use any subodomain of serveo.net that is not in use by other user
 * "secure" SSL reverse tunnel (see WARNING above)
 * HTTPS support out of the box (see WARNING above)
 * reconnecting after connection failures (both sides) thanks to supervisor (I've tried to use `autossh` or any way to pass `--restart=unless-stopped` to docker container running but failed) - it can take up to 5 minutes to drop previous port forwarding
 * forward up to 3 ports/services (eg. frontend, configurator and terminal/ssh)
 * support for own self-hosted serveo instance
 * support for own custom domian like described [here](https://serveo.net/#manual)

## Quick Install

1. Add `https://github.com/lechup/hassio-addons/` as described [here](https://www.home-assistant.io/hassio/installing_third_party_addons/) in hassio docs.
2. Fill in alias of Your choosing (be creative!), it will be Your subdomain (use letters + numbers + hyphen).
3. Start addon.
4. See if logs shows something like
```
2019-03-25 23:26:50,207 INFO exited: serveo (exit status 255; not expected)
2019-03-25 23:26:51,220 INFO spawned: 'serveo' with pid 26
2019-03-25 23:26:52,223 INFO success: serveo entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
Hi there
Forwarding HTTP traffic from https://myfancyalias.serveo.net
```
5. Open `https://myfancyalias.serveo.net` in Your browser, and be happy!
6. Consider [donating a BEER for me](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=VGVTUEX3BDKKN&source=url) and/or serveo.net creator.

## Config params

`alias` - subdomain of your choosing, required even if domain is defined

`private_key` - if you're using your own custom domain, then you need to supply a private key (as per the docs). Paste the literal key in here (string in form of: "-----BEGIN RSA PRIVATE KEY-----\nXXXXXXXXXXXXX\nXXXXXXXXXXXXX\n-----END RSA PRIVATE KEY-----"), and the file will be generated at runtime.

`server` - in case you are using your own serveo instance, put its hostname here

`ssh_port` - in case your custom serveo instance is running on port other than default ssh port (i.e. 22), put it here

`port1from` - local hassio port to forward from, default `8123` forwards frontend service

`port1to` - remote serveo port to forward to, default `80` translate to 443 (https) 

`port2from`/`port2to`, `port3from`/`port3to` - forward more services/addons like configurator etc. 

`domain` - in case You want to use custom domain feature of serveo.net, see their [docs](https://serveo.net)

`retry_time` - seconds to wait before retrying to reconnect to serveo in case of connection error, please be patient sometimes serveo.net can be down or Your provider can have problems with hostname resolution

## Example configuration

1. Easiest config, expose only frontend:

```json
{
    "alias": "myfancysubdomain",
    "private_key": "",
    "server": "serveo.net",
    "ssh_port": 22,
    "port1from": 8123,
    "port1to": 80,
    "port2from": 0,
    "port2to": 0,
    "port3from": 0,
    "port3to": 0,
    "domain": "",
    "retry_time": 15
}
```

2. Other examples can be added via PR's :)
