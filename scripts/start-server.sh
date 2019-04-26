#!/bin/bash
CUR_V="$(find -name fx.tar.xz-[^extended]* | cut -d '-' -f 2,3)"
LAT_V="$(wget -q -O - ${SRV_ADR} | grep 'Parent directory/</a></td><td>-</td><td' | head | grep -Po '(?<=href=").{45}' |grep 1)"

if [ -z "$CUR_V" ]; then
  echo "---FiveM not found!---"
  cd ${SERVER_DIR}
  wget -qO $LAT_V "${SRV_ADR}$LAT_V/fx.tar.xz"
  tar -xf $LAT_V
  mv ${SERVER_DIR}/$LAT_V ${SERVER_DIR}/fx.tar.xz-$LAT_V
elif [ "$LAT_V" != "$CUR_V" ]; then
  echo "---Newer version found, installing!---"
  rm ${SERVER_DIR}/fx.tar.xz-$CUR_V
  cd ${SERVER_DIR}
  wget -qO $LAT_V "${SRV_ADR}$LAT_V/fx.tar.xz"
  tar -xf $LAT_V
  mv ${SERVER_DIR}/$LAT_V ${SERVER_DIR}/fx.tar.xz-$LAT_V
elif [ "$LAT_V" == "$CUR_V" ]; then
  echo "---FiveM Version up-to-date---"
else
  echo "---Something went wrong, putting server in sleep mode---"
  sleep infinity
fi

if [ ! -d "${SERVER_DIR}/cfx-server-data" ]; then
  echo "---CFX-SERVER-DATA not found, downloading...---"
  cd ${SERVER_DIR}
  wget -qO server-data.zip "http://github.com/citizenfx/cfx-server-data/archive/master.zip"
  unzip server-data.zip
  rm ${SERVER_DIR}/server-data.zip
  mv ${SERVER_DIR}/cfx-server-data-master ${SERVER_DIR}/cfx-server-data
else
  echo "---CFX-SERVER-DATA found, updating...---"
  wget -qO server-data.zip "http://github.com/citizenfx/cfx-server-data/archive/master.zip"
  unzip server-data.zip
  rm ${SERVER_DIR}/server-data.zip
  mv ${SERVER_DIR}/cfx-server-data-master ${SERVER_DIR}/cfx-server-data
fi

if [ ! -f "${SERVER_DIR}/server.cfg" ]; then
  echo "---No server.cfg found, downloading...---"
  cd ${SERVER_DIR}
  wget -qi server.cfg "https://raw.githubusercontent.com/ich777/docker-fivem-server/master/configs/server.cfg"
fi

${SERVER_DIR}/run.sh +exec server.cfg +sv_licenseKey ${SERVER_KEY}

sleep infinity
