#!/bin/bash
if [ ! -f ${SERVER_DIR}/fiveminstalled ]; then
	if [ ! -f ${SERVER_DIR}/fx.tar.xz ]; then
    	echo "--------------------------------------------"
		echo "---Please put the Server file 'fx.tar.xz'---"
    	echo "---in the main directory and restart the----"
    	echo "---Docker, putting Server into sleep mode---"
    	echo "--------------------------------------------"
		sleep infinity
    fi
    echo "---File 'fx.tar.xz' found, installing...---"
    cd ${SERVER_DIR}
    tar -xf fx.tar.xz
    sleep 2
    rm -R fx.tar.xz
    if [ ! -f ${SERVER_DIR}/fiveminstalled ]; then
    	touch ${SERVER_DIR}/fiveminstalled
    fi
fi

if [ -f ${SERVER_DIR}/fiveminstalled ]; then
	echo "---Checking for new 'fx.tar.xz'---"
	if [ -f ${SERVER_DIR}/fx.tar.xz ]; then
    	echo "---New 'fx.tar.xz' found, installing...---"
        cd ${SERVER_DIR}
        tar -xf fx.tar.xz
        sleep 2
        rm -R fx.tar.xz
        if [ ! -f ${SERVER_DIR}/fiveminstalled ]; then
        	touch ${SERVER_DIR}/fiveminstalled
        fi
        echo "---Installation of new 'fx.tar.xz' complete---"
     else
     	echo "---No new 'fx.tar.xz' found---"
     fi
fi

if [ ! -d "${SERVER_DIR}/resources" ]; then
  echo "---SERVER-DATA not found, downloading...---"
  cd ${SERVER_DIR}
  wget -qO server-data.zip "http://github.com/citizenfx/cfx-server-data/archive/master.zip"
  unzip -q server-data.zip
  mv ${SERVER_DIR}/cfx-server-data-master/resources ${SERVER_DIR}/resources
  rm server-data.zip && rm -R cfx-server-data-master/
fi

echo "---Prepare Server---"
if [ ! -f "${SERVER_DIR}/server.cfg" ]; then
  echo "---No server.cfg found, downloading...---"
  cd ${SERVER_DIR}
  wget -qi server.cfg "https://raw.githubusercontent.com/ich777/docker-fivem-server/master/configs/server.cfg"
fi
chmod -R 770 ${DATA_DIR}
echo "---Checking for old logs---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;

if [ ! -f ${SERVER_DIR}/run.sh ]; then
	echo "------------------------------------"
	echo "---Something went wrong, couldn't---"
    echo "---find run.sh in main directory----"
    echo "---Putting server into sleep mode---"
    echo "------------------------------------"
    sleep infinity
fi

echo "---Starting Server---"
cd ${SERVER_DIR}
screen -S FiveM -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/run.sh +exec ${GAME_CONFIG} +sv_licenseKey ${SERVER_KEY} +sv_hostname ${SRV_NAME} ${START_VARS}
sleep 2
tail -f ${SERVER_DIR}/masterLog.0