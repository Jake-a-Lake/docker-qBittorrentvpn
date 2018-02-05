#!/bin/bash
set -e

if [[ ! -e /config/qBittorrent ]]; then
	mkdir -p /config/qBittorrent/config/
	chown -R ${PUID}:${PGID} /config/qBittorrent
else
	chown -R ${PUID}:${PGID} /config/qBittorrent
fi

if [[ ! -e /config/qBittorrent/config/qBittorrent.conf ]]; then
	/bin/cp /etc/qbittorrent/qBittorrent.conf /config/qBittorrent/config/qBittorrent.conf
	chmod 755 /config/qBittorrent/config/qBittorrent.conf
	chown -R ${PUID}:${PGID} /config/qBittorrent/config/qBittorrent.conf
fi

echo "[info] Starting qBittorrent daemon..." | ts '%Y-%m-%d %H:%M:%.S'
/bin/bash /etc/qbittorrent/qbittorrent.init start
chmod -R 755 /config/qBittorrent

sleep 1
child=$(pgrep -o -x qbittorrent-nox) 
echo "[info] qBittorrent PID: $child" | ts '%Y-%m-%d %H:%M:%.S'

if [ -e /proc/$child ]; then
	sleep infinity
else
	echo "qBittorrent failed to start!"
fi
