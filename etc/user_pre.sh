#!/bin/sh
#cpu_type=`cat /proc/PW/TYPE`
#SWID=`cat /proc/PW/SWID`

#type=${SWID:14:4}
#echo "SWID	type $type"
#if [ "$type" == "1700" ]; then
#	cpu_type=8136
#fi 
#if [ "$type" == "1701" ]; then
#	cpu_type=8135
#fi 
#if [ "$type" == "1702" ]; then
#	cpu_type=8135
#fi 


#if [ "${cpu_type:0:4}" == "8136" ]; then
#	cp /usr/gm/cfg/8136/gmlib.cfg /mnt/mtd/gmlib.cfg
#fi

#if [ "${cpu_type:0:4}" == "8135" ]; then
#	cp /usr/gm/cfg/8135/gmlib.cfg /mnt/mtd/gmlib.cfg
#fi

video=`cat /etc/PW/SENSOR`
#video=`cat /proc/PW/SENSOR`
video_frontend=${video:0:4}

SWID=`cat /etc/PW/SWID`
#SWID=`cat /proc/PW/SWID`

type=${SWID:14:4}
echo "SWID	type $type"
if [ "$type" == "1700" ]; then
	video_frontend=9712
fi 
if [ "$type" == "1701" ]; then
	video_frontend=9712
fi 
if [ "$type" == "1702" ]; then
	video_frontend=1045
fi 

echo "video_frontend $video_frontend"
case "$video_frontend" in
        "9715"|"9712"|"9710")
        cp /usr/gm/cfg/8135/720P/gmlib.cfg /mnt/mtd/gmlib.cfg
        echo "720P-gmlib"       
        ;;
        "1045"|"1145")
				cp /usr/gm/cfg/8135/720P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "720P-gmlib"       
        ;;
        "1225")
				cp /usr/gm/cfg/8135/960P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "960P-gmlib"      
        ;;  
				"1135")
				cp /usr/gm/cfg/8135/960P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "960P-gmlib"
        ;;
        "1235")
				cp /usr/gm/cfg/8135/960P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "960P-gmlib"
        ;;
        "0130")
				cp /usr/gm/cfg/8135/960P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "960P-gmlib"
        ;;
        "2143")
				cp /usr/gm/cfg/8135/960P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "960P-gmlib-2143"
        ;;
	"2035")
				cp /usr/gm/cfg/8136/1080P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "1080P-gmlib"
        ;;
	"2135")
				cp /usr/gm/cfg/8136/1080P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "1080P-gmlib"
        ;;
  "2235")
				cp /usr/gm/cfg/8136/1080P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "1080P-gmlib"
        ;;
  	"0330")
				cp /usr/gm/cfg/8136/1696P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "1696P-gmlib"
        ;;
  	"3035")
				cp /usr/gm/cfg/8136/1696P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "1696P-gmlib"
        ;;
	"0323")
				cp /usr/gm/cfg/8136/1080P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "1080P-gmlib"
        ;;
	"0237")
				cp /usr/gm/cfg/8136/1080P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "1080P-gmlib"
        ;;
	"0290")
				cp /usr/gm/cfg/8136/1080P/gmlib.cfg /mnt/mtd/gmlib.cfg
				echo "1080P-gmlib"
        ;;
     		*)
        echo "Invalid argument for video frontend: $video_frontend"
        exit
        ;;
esac

#cp /usr/gm/cfg/gmlib.cfg /mnt/mtd/gmlib.cfg

#mkdir -p /mnt/mtd/Config /mnt/mtd/Log /mnt/mtd/Config/ppp /mnt/mtd/Config/Json

#telnetd &

#timecheck &

#netinit &

#if [ -e /mnt/mtd/Config/RT2870STA.dat ]; then
#	echo "/mnt/mtd/Config/RT2870STA.dat, exist!";
#else
#	echo "no exist  exec cp RT2870STA.dat";
#	cp /usr/etc/RT2870STA.dat /mnt/mtd/Config/
#fi



