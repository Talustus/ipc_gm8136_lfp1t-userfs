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

## create lockfile
touch /tmp/.dreamhack

## DebugFS - SetUp eth0
echo -e "Dream-Hack: Custom Network Config"
sleep 1
if [ -f /usr/etc/dream/interfaces.custom ];
then
  echo -e "found Custom interfaces file, reconfiguring network..."
  ip link set eth0 down
  ip link set eth0 up
  ip addr add 192.168.178.74/24 brd + dev eth0
  ip route add default via 192.168.178.1 dev eth0
else
  echo -e "Custom interfaces file not found, skipping network config..."
fi
echo " Network Config done ..."

## Check Custom dream-hack settings
##
## IPTables Support
IPT_ENABLE=0
if [ -f /usr/etc/dream/iptables.enable ] && [ -e /usr/sbin/xtables-multi ];
then
  IPT_ENABLE=`cat /usr/etc/dream/iptables.enable`
fi

## RTSPD Stream
RTSPD_ENABLE=0
if [ -f /usr/etc/dream/rtspd.enable ] && [ -f /usr/sbin/rtspd.xz ];
then
  RTSPD_ENABLE=`cat /usr/etc/dream/rtspd.enable`
fi

echo -e "**************************"
echo -e "** Dream-Hack Settings: **"
echo -e "**************************"
echo -e "** - IPTables enabled: $IPT_ENABLE"
echo -e "** - RTSPD enabled: $RTSPD_ENABLE"
echo -e "**************************"

## EOF Custom Dream-Hack Settings ##

# Check for watchdog Timer binary location
if [ -e /mnt/voice/wdt ];
then
  echo -e "Dream-Hack, using: /mnt/voice/wdt for wotchdog timer"
  WDT_BIN=/mnt/voice/wdt
else
  echo -e "Dream-Hack, using: /mnt/mtd/dream/wdt for wotchdog timer"
  WDT_BIN=/mnt/mtd/dream/wdt
fi
echo "WDT Binary: $WDT_BIN"

$WDT_BIN 120
echo -e "Sleep 2"
sleep 2

echo -e "Starting Software Watchdog"
/sbin/watchdog -T 120 -t 30 /dev/watchdog &

## Check for /mnt/mtd partition
mountpoint /mnt/mtd
if [ "$?" = "0" ];
then
  echo -e "/mnt/mtd is mounted....!"
else
  echo -e "Sorry /mnt/mtd is no valid mountpoint..."
fi

## Check for /mnt/voice partition
mountpoint /mnt/voice
if [ "$?" = "0" ];
then
  echo -e "/mnt/voice is mounted....!"
else
  echo -e "Sorry /mnt/voice is no valid mountpoint..."
fi

## Check for /mnt/web partition
mountpoint /mnt/web
if [ "$?" = "0" ];
then
  echo -e "/mnt/web is mounted....!"
else
  echo -e "Sorry /mnt/web is no valid mountpoint..."
fi

##########################################
## Setup the system based on our config ##
##########################################

## IPTables
if [ "$IPT_ENABLE" == "1" ];
then
  echo -e "** Dream-Hack: Enabling IPTables Support"
  ln -s /usr/sbin/xtables-multi /bin/iptables
  ln -s /usr/sbin/xtables-multi /bin/iptables-save
  ln -s /usr/sbin/xtables-multi /bin/iptables-restore
  ln -s /usr/sbin/xtables-multi /bin/iptables-xml
  modprobe -v ip_tables
  modprobe -v ipt_LOG
  echo -e " "
  echo -e "Testing if iptables is working ..."
  iptables -L --line-numbers
fi

## RTSPD
if [ "$RTSPD_ENABLE" == "1" ];
then
  echo -e "** Dream-Hack: Enabling RTSPD Stream Support"
  cd /var
  cp /usr/sbin/rtspd.xz /var
  xz -d rtspd.xz
  echo -e " "
  echo -e "Starting RTSP Stream"
  /var/rtspd -j > /dev/null &
fi

###
echo -e ""
echo -e "*** Dream-Hack EndOF ***"
echo -e ""

exit 0
