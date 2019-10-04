# FiveM Server in Docker optimized for Unraid
With this Docker you can run FiveM (GTA V MOD SERVER) you only have to place the preffered fx.tar.xz in the main directory.
The Docker will automatically extract it and download all other required files (resources, server.cfg).
You can get fx.tar.xz from here: https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/
To run this container you must provide a valid Server Key (you can get them from here: https://keymaster.fivem.net/) and your prefered Server Name.

Update Notice: Simply place the new fx.tar.xz in the main directory and it will install it.

>**CONSOLE:** To connect to the console open up the terminal for this docker and type in: 'screen -xS FiveM' (without quotes).

## Env params
| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_CONFIG | The name of your server configuration file | server.cfg |
| SERVER_KEY | Place your server key obtained from: https://keymaster.fivem.net/ here | placeyourkeyhere |
| START_VARS | Enter your extra startup variables here if needed | |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name FiveM -d \
	-p 30110:30110 -p 30120:30120 \
    -p 30110:30110/udp -p 30120:30120/udp \
	--env 'GAME_CONFIG=server.cfg' \
	--env 'SERVER_KEY=placeyourkeyhere' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /mnt/user/appdata/fivem:/serverdata/serverfiles \
	ich777/fivemserver
```


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/