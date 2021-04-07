#!/bin/bash
CUR_V="$(find ${SERVER_DIR} -name fiveminstalled-* | cut -d '-' -f 2,3)"
LAT_V="$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | head -n -1 | cut -d '"' -f 2 | cut -d '-' -f 1 | cut -c3-)"
DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | head -n -1 | cut -d '"' -f 2 | cut -c3-)"

if [ "${MANUAL_UPDATES}" == "true" ]; then
    if [ "$CUR_V" == "manual" ]; then
    	if [ -f ${SERVER_DIR}/fx.tar.xz ]; then
            echo "---File 'fx.tar.xz' found, installing...---"
            if [ -f ${SERVER_DIR}/fiveminstalled-* ]; then
                rm ${SERVER_DIR}/fiveminstalled-*
            fi
            cd ${SERVER_DIR}
            tar -xf fx.tar.xz
            sleep 2
            rm -R fx.tar.xz
            touch fiveminstalled-manual
            echo "---Installation of new 'fx.tar.xz' complete---"
        else
    		echo "---FiveM found---"
        fi
	elif [ ! -f ${SERVER_DIR}/fx.tar.xz ]; then
		echo "-------------------------------------------------------------------------"
        echo "-------------------!!!Manual updates enabled!!!--------------------------"
		echo "----------Please put the Server file 'fx.tar.xz' in the main-------------"
		echo "-----------------directory, you can get it from:-------------------------"
		echo "---https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/---"
		echo "----------and restart the Docker, putting Server into sleep mode---------"
		echo "-------------------------------------------------------------------------"
		sleep infinity
    else
		echo "---File 'fx.tar.xz' found, installing...---"
        if [ -f ${SERVER_DIR}/fiveminstalled-* ]; then
        	rm ${SERVER_DIR}/fiveminstalled-*
        fi
		cd ${SERVER_DIR}
		tar -xf fx.tar.xz
		sleep 2
		rm -R fx.tar.xz
    	touch fiveminstalled-manual
		echo "---Installation of new 'fx.tar.xz' complete---"
    fi
else
    if [ ! -f ${SERVER_DIR}/fiveminstalled-* ]; then
        if [ "${LAT_V}" == "" ]; then
            if [ ! -f ${SERVER_DIR}/fx.tar.xz ]; then
                echo "-------------------------------------------------------------------------"
                echo "--------Could not get latest game version from master server-------------"
                echo "----------please put the Server file 'fx.tar.xz' in the main-------------"
                echo "-----------------directory, you can get it from:-------------------------"
                echo "---https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/---"
                echo "----------and restart the Docker, putting Server into sleep mode---------"
                echo "-------------------------------------------------------------------------"
                sleep infinity
            else
                echo "---File 'fx.tar.xz' found, installing...---"
                cd ${SERVER_DIR}
                tar -xf fx.tar.xz
                sleep 2
                rm -R fx.tar.xz
                touch ${SERVER_DIR}/fiveminstalled-manual
                echo "---Installation of new 'fx.tar.xz' complete---"
            fi
        elif [ "$LAT_V" != "" ]; then
            echo "---FiveM not found, downloading!---"
            cd ${SERVER_DIR}
            if wget -q -nc --show-progress --progress=bar:force:noscroll $DL_URL ; then
                  echo "---Download complete---"
            else
                  echo "---Something went wrong, can't download FiveM, putting server in sleep mode---"
                  sleep infinity
            fi
            tar -xf fx.tar.xz
            rm -R fx.tar.xz
            touch ${SERVER_DIR}/fiveminstalled-$LAT_V
            echo "---Installation of new 'fx.tar.xz' complete---"
            CUR_V="$(find ${SERVER_DIR} -name fiveminstalled-* | cut -d '-' -f 2,3)"
         fi
    fi
    echo "---Version Check---"
    if [ "$CUR_V" == "manual" ]; then
        echo "---------------------------------------------------------------"
        echo "---Manual installed version found, if you want to autoupdate---"
        echo "------and there is no Captcha check on the FiveM download------"
        echo "---server delte the file 'fiveminstalled-manual' in the main---"
        echo "-----------------directory of the container--------------------"
        sleep 5
    else
        if [ "$LAT_V" == "" ]; then
            echo "-------------------------------------------------------"
            echo "----Could not get latest version from master server----"
            echo "---please check manualy if there is a newer version---"
            echo "---and place the file manualy in the main directory---"
            echo "-------------------------------------------------------"
            if [ -f ${SERVER_DIR}/fx.tar.xz ]; then
                echo "---File 'fx.tar.xz' found, installing...---"
        		if [ -f ${SERVER_DIR}/fiveminstalled-* ]; then
                    rm ${SERVER_DIR}/fiveminstalled-*
                fi
                cd ${SERVER_DIR}
                tar -xf fx.tar.xz
                sleep 2
                rm -R fx.tar.xz
                touch ${SERVER_DIR}/fiveminstalled-manual
                echo "---Installation of new 'fx.tar.xz' complete---"
            fi
        elif [ "$LAT_V" != "$CUR_V" ]; then
            echo "---Newer version found, installing!---"
    		if [ -f ${SERVER_DIR}/fiveminstalled-* ]; then
                rm ${SERVER_DIR}/fiveminstalled-*
            fi
            cd ${SERVER_DIR}
            if wget -q -nc --show-progress --progress=bar:force:noscroll $DL_URL ; then
                echo "---Download complete---"
            else
                echo "---Something went wrong, can't download FiveM, putting server in sleep mode---"
                sleep infinity
            fi
            tar -xf fx.tar.xz
            rm ${SERVER_DIR}/$LAT_V/fx.tar.xz
            touch fiveminstalled-$LAT_V
        elif [ "$LAT_V" == "$CUR_V" ]; then
            echo "---FiveM Version up-to-date---"
        fi
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
if [ ! -f ~/.screenrc ]; then
    echo "defscrollback 30000
bindkey \"^C\" echo 'Blocked. Please use to command \"quit\" to shutdown the server or close this window to exit the terminal.'" > ~/.screenrc
fi
if [ ! -z "${GAME_CONFIG}" ]; then
    if [ ! -f "${SERVER_DIR}/server.cfg" ]; then
        echo "---No server.cfg found, downloading...---"
        cd ${SERVER_DIR}
        wget -q -nc --show-progress --progress=bar:force:noscroll server.cfg "https://raw.githubusercontent.com/ich777/docker-fivem-server/master/configs/server.cfg"
    fi
fi
chmod -R ${DATA_PERM} ${DATA_DIR}
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
if [ -z "${GAME_CONFIG}" ]; then
    screen -S FiveM -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/run.sh +sv_licenseKey ${SERVER_KEY} +sv_hostname ${SRV_NAME} ${START_VARS}
else
    screen -S FiveM -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/run.sh +exec ${GAME_CONFIG} +sv_licenseKey ${SERVER_KEY} +sv_hostname ${SRV_NAME} ${START_VARS}
fi
sleep 2
if [ "${ENABLE_WEBCONSOLE}" == "true" ]; then
    /opt/scripts/start-gotty.sh 2>/dev/null &
fi
screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
tail -f ${SERVER_DIR}/masterLog.0