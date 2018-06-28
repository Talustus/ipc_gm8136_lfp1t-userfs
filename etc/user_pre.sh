#!/bin/sh

video=`cat /proc/PW/SENSOR`
video_frontend=${video:0:4}
SWID=`cat /proc/PW/SWID`

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
