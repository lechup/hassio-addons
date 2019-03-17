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
 * forward up to 3 ports/services (eg. forntend, configurator and terminal/ssh)
 * support for own self-hosted serveo instance
 * support for own custom domian like described [here](https://serveo.net/#manual)

## Installation

1. add 

## Example configuration

1. Easiest config, expose only frontend:

```json
{
    "alias": "myfancysubdomain",
    "server": "serveo.net",
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
