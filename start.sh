#!/bin/bash

set -e

VERSION="${VERSION//./_}"
ZIPFILE="FTBLite2.zip"

if [[ "${VERSION}" = "LATEST" ]]; then
    VERSION="$(wget -q -O - http://www.feed-the-beast.com/server-download | grep -Po "(FTBLite2%5E[\d_]+)" | sed 's/FTBLite2%5E//')"
fi

cd /data

if [[ ! -e "${ZIPFILE}" ]]; then
    echo "Downloading modpacks%5EFTBLite2%5E${VERSION}%5EFTBLite2Server.zip -> ${ZIPFILE} ..."
    wget -c -O "${ZIPFILE}.part" "http://www.creeperrepo.net/FTB2/modpacks%5EFTBLite2%5E${VERSION}%5EFTBLite2Server.zip"
    mv "${ZIPFILE}"{.part,}
fi

[[ -d config ]] || unzip "${ZIPFILE}"

if [[ ! -e server.properties ]]; then
    cp /tmp/server.properties .
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi
if [[ -n "$PAX" ]]; then
    paxctl -C /usr/bin/java
    paxctl -m /usr/bin/java
fi

java $JVM_OPTS -jar FTBServer-*.jar nogui
