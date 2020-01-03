FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends xz-utils unzip screen && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_CONFIG="template"
ENV SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
ENV MANUAL_UPDATES=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV SERVER_KEY="template"
ENV START_VARS="template"

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $SERVER_DIR -s /bin/bash --uid $UID --gid $GID fivem && \
	chown -R fivem $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R fivem /opt/scripts

USER fivem

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]