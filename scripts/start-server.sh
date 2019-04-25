#!/bin/bash
sleep infinity
<TODO>


CUR_V="$(wget -q -O - ${SRV_ADR} | grep 'Parent directory/</a></td><td>-</td><td' | head | grep -Po '(?<=href=").{45}' |grep 1)"
wget -qi - ${SRV_ADR}$CUR_V/fx.tar.xz
