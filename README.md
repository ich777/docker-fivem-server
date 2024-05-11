# FiveM Server in Docker optimized for Unraid
With this Docker you can run FiveM (GTA V MOD SERVER) it will automatically download the latest version or if you want to updated it yourself set the 'Manual Updates' to 'true' (without quotes).
The Docker will automatically extract it and download all other required files (resources, server.cfg).
You can get fx.tar.xz from here: https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/
To run this container you must provide a valid Server Key (you can get them from here: https://keymaster.fivem.net/) and your prefered Server Name.

Update Notice: Simply restart the container and it will download the newest version or if you set 'Manual Updates' to 'true' place the new fx.tar.xz in the main directory and restart the container.

**WEB CONSOLE:** You can connect to the FiveM console by opening your browser and go to HOSTIP:9016 (eg: 192.168.1.1:9016) or click on WebUI on the Docker page within Unraid.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_CONFIG | The name of your server configuration file | server.cfg |
| SERVER_KEY | Place your server key obtained from: https://keymaster.fivem.net/ here | placeyourkeyhere |
| START_VARS | Enter your extra startup variables here if needed | |
| SRV_ADR | The master server adress for the FiveM server download | https://runtime.fivem.net/artifacts/fi... |
| MANUAL_UPDATES | Set to 'true' if you want to update the server manually (otherwise leave blank) | *blank* |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name FiveM -d \
    -p 30110:30110 -p 30120:30120 \
    -p 30110:30110/udp -p 30120:30120/udp \
    -p 9016:8080 \
    --env 'GAME_CONFIG=server.cfg' \
    --env 'SERVER_KEY=placeyourkeyhere' \
    --env 'SRV_ADR=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /path/to/fivem:/serverdata/serverfiles \
    --restart=unless-stopped \
    ich777/fivemserver
```


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/