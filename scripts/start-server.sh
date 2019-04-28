#!/bin/bash
CUR_V="$(find -name fx.tar.xz-[^extended]* | cut -d '-' -f 2,3)"
LAT_V="$(wget -q -O - ${SRV_ADR} | grep 'Parent directory/</a></td><td>-</td><td' | head | grep -Po '(?<=href=").{45}' |grep 1)"

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
  echo "---FiveM not found, downloading!---"
  cd ${SERVER_DIR}
  wget -qO $LAT_V "${SRV_ADR}$LAT_V/fx.tar.xz"
  tar -xf $LAT_V
  mv ${SERVER_DIR}/$LAT_V ${DATA_DIR}/fx.tar.xz-$LAT_V
elif [ "$LAT_V" != "$CUR_V" ]; then
  echo "---Newer version found, installing!---"
  rm ${DATA_DIR}/fx.tar.xz-$CUR_V
  cd ${SERVER_DIR}
  wget -qO $LAT_V "${SRV_ADR}$LAT_V/fx.tar.xz"
  tar -xf $LAT_V
  mv ${SERVER_DIR}/$LAT_V ${DATA_DIR}/fx.tar.xz-$LAT_V
elif [ "$LAT_V" == "$CUR_V" ]; then
  echo "---FiveM Version up-to-date---"
else
  echo "---Something went wrong, putting server in sleep mode---"
  sleep infinity
fi

if [ ! -d "${SERVER_DIR}/server-data" ]; then
  echo "---SERVER-DATA not found, downloading...---"
  cd ${SERVER_DIR}
  mkdir server-data
  cd ${SERVER_DIR}/server-data
  wget -qO server-data.zip "http://github.com/citizenfx/cfx-server-data/archive/master.zip"
  unzip -q server-data.zip
  mv ${SERVER_DIR}/server-data/cfx-server-data-master/resources ${SERVER_DIR}/server-data/resources
  rm server-data.zip && rm -R cfx-server-data-master/
fi

echo "---Prepare Server---"
if [ ! -f "${SERVER_DIR}/server-data/server.cfg" ]; then
  echo "---No server.cfg found, downloading...---"
  cd ${SERVER_DIR}/server-data
  wget -qi server.cfg "https://raw.githubusercontent.com/ich777/docker-fivem-server/master/configs/server.cfg"
fi
chmod -R 770 ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}
./run.sh +exec +sv_licenseKey $SERVER_KEY +sv_hostname ${SRV_NAME} ${START_VARS} ${GAME_CONFIG}
