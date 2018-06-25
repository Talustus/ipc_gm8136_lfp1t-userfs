 #!/bin/sh
#
# Loging
exec >> /tmp/dream-hack.log
# Error Loging
exec 2>> /tmp/dream-hack_err.log

echo -e "#####################################################"
echo -e "    $(date): Dream-Hack IniT"
echo -e "#####################################################"
##
## Something Usefull comes here after we find a way to inject our process
##
##
## Dream-Hack already applied? exit ...
if [ -f /tmp/.dreamhack ];
then
  echo -e "Dream-Hack: already patched, exiting..."
  exit 0
fi

## DebugFS - SetUp eth0
echo -e "Dream-Hack: Custom Network Config"
sleep 1
if [ -f /usr/etc/interfaces.custom ];
then
  echo -e "found Custom interfaces file, reconfiguring network..."
  #ifdown -a
  #ifup -a -i /usr/etc/interfaces.custom
  ip link set eth0 down
  ip link set eth0 up
  ip addr add 192.168.178.74/24 brd + dev eth0
  # ip route add 192.168.178.0/24 dev eth0
  ip route add default via 192.168.178.1 dev eth0
else
  echo -e "Custom interfaces file not found, skipping network config..."
fi
echo " Network Config done ..."

## Alloca running?
grep Alloca /proc/29*/cmdline
if [ "$?" == "0" ];
then
  echo -e "Dream-Hack: looks like /var/Alloca is running, killing it!"
  if [ -e /mnt/voice/wdt ];
  then
    echo -e "Dream-Hack, using: /mnt/voice/wdt for wotchdog timer"
    WDT_BIN=/mnt/voice/wdt
    # /mnt/voice/wdt 120
  else
    echo -e "Dream-Hack, using: /mnt/mtd/dream/wdt for wotchdog timer"
    WDT_BIN=/mnt/mtd/dream/wdt
    # /mnt/mtd/dream/wdt 120
  fi
  # echo $WDT_BIN
  # $WDT_BIN 120
  echo -e "Sleep 40 ..."
  sleep 40
  echo -e "... sleep done"
  $WDT_BIN 120
  # kill -9 293
  # kill -9 294
  # kill -9 298
  killall dvrHelper
  killall Alloca
  # echo -e "Sleep 1"
  # sleep 1
  /sbin/watchdog -T 120 -t 30 /dev/watchdog &
else
  echo -e "Dream-Hack: good, no /var/Alloca running..."
  #
  #
fi

## Check for /mnt/mtd partition
## which contains our custom files
mountpoint /mnt/mtd
if [ "$?" = "0" ];
then
  echo -e "/mnt/mtd is mounted looking for custom Stuff ...!"
else
  echo -e "Sorry /mnt/mtd is no valid mountpoint..."
  echo -e "Nothing todo, exiting ..."
  exit 1
fi

echo -e ""
echo -e "Searching for custom Binaries on mnt/mtd partition"
echo -e ""
## RTSPD BIN
if [ -f /mnt/mtd/dream/rtspd ];
then
  echo -e "RTSPD bin found  on /mnt/mtd, nice one.."
  # Already on /var?
  if [ -f /var/rtspd ];
  then
    echo -e "RTSPD already exists on /var..."
    echo -e ""
  else
    echo -e "Copying RTSPD Binary...."
    echo -e ""
    cp /mnt/mtd/dream/rtspd /var/
  fi
  echo -e "Starting RTSPD With MJPEG Stream: rtsp://0.0.0.0:554/live/ch00_0"
  #/var/rtspd -j &
  echo "DebugFS i dont start rtspd now ..."
  ## Debug
  killall watchdog
  /sbin/watchdog -T 120 -t 30 /dev/watchdog
  #/var/rtspd -j > /dev/null 2>&1
else
  echo -e "boooo, no rtspd binary found :("
fi

echo -e ""
echo -e "*** Dream-Hack EndOF ***"
echo -e ""

touch /tmp/.dreamhack

exit 0
