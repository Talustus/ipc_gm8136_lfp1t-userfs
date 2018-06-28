#!/bin/sh

# cd /var
# cp /usr/sbin/Alloca.xz /var
# xz -d /var/Alloca.xz

echo "start to read upgrade_state"

i=1
for lines in `cat /mnt/mtd/up_state.txt`
do
  case ${i} in
  1) var1=${lines};;
  2) var2=${lines};;
  3) var3=${lines};;
  4) var4=${lines};;
  5) var5=${lines};;
  6) var6=${lines};;
  7) var7=${lines};;
  8) var8=${lines};;
  9) var9=${lines};;
  10) var10=${lines};;
  11) var11=${lines};;
  esac
  i=`expr ${i} + 1`
done

	echo ${var1}
	echo ${var2}
	echo ${var3}
	echo ${var4}
	echo ${var5}
	echo ${var6}
	echo ${var7}
	echo ${var8}
	echo ${var9}
	echo ${var10}
	echo ${var11}


free -m
IPNCAUTO=`cat /proc/PW/IPNCAUTO`

#for wifi test
TF=`cat /proc/PW/TF`
if [ "$TF" == "4" ]  ; then
		#for wifi test
		echo "***************************"
		echo "TF=4 start wifi test"
		echo "***************************"
		#mount TF card
		sh /m_tf.sh
		if [ -e "/mnt/sd0/mp-wifi.sh" ]; then
			echo "mp-wifi.sh start"
			mkdir -p /var/mp-test
			cp -rf /mnt/sd0/* /var/mp-test
			sh /var/mp-test/mp-wifi.sh start
			sh /var/mp-test/mp-wifi.sh test
		fi
elif [ "$TF" == "5" ]  ; then
		#for mp test
		echo "***************************"
		echo "TF=5 start mp test"
		echo "***************************"
		#mount TF card
		sh /m_tf.sh
		if [ -e "/mnt/sd0/mp-test.sh" ]; then
			echo "mp-test.sh start"
			mkdir -p /var/mp-test
			cp -rf /mnt/sd0/* /var/mp-test
			sh /var/mp-test/mp-test.sh start
			sh /var/mp-test/mp-test.sh test
		fi
elif [ "$var1" == "1" ]  ; then
		echo "***************************"
		echo "Do not start Alloca, Ready to Update"
		echo "***************************"
		if [ -e /mnt/voice/UpgradeMy ]; then
			/mnt/voice/UpgradeMy&
			echo "UpgradeMy from /mnt/voice/*********************"
		else
			/gm/bin/UpgradeMy&
			echo "UpgradeMy from /gm/bin/*********************"
		fi
else
	if [ "$IPNCAUTO" == "1" ];
	then
		echo "**********************************"
		echo "** Autostarting IP-Cam Services **"
		echo "**********************************"
		echo "ready to start ip-cam-services"
		#/var/rtspd -j
		echo "OH: Kernel Debug FS!!! i should not start anything now right?"
		echo "ready to run Dream-hacks Script (DebugFS-Dummy)"
		sh /usr/etc/dream-hack.sh
	else
		echo "*******************************************"
		echo "** Autostart of IP-CAM-Services Disabled **"
		echo "*******************************************"
		echo "skipping start of ip-cam-services"
		/mnt/voice/wdt 120
		/sbin/watchdog -T 120 -t 30 -F /dev/watchdog
	fi
fi
