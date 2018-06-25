video=`cat /etc/PW/SENSOR`
#video=`cat /proc/PW/SENSOR`
video_frontend=${video:0:4}

wifi=`cat /etc/PW/WIFI`
#wifi=`cat /proc/PW/WIFI`

cpu_type=`cat /etc/PW/TYPE`
#cpu_type=`cat /proc/PW/TYPE`

SWID=`cat /etc/PW/SWID`
#SWID=`cat /proc/PW/SWID`

type=${SWID:14:4}
echo "SWID	type $type"
if [ "$type" == "1700" ]; then
	cpu_type=8136
	video_frontend=9712
	wifi=8188
fi 
if [ "$type" == "1701" ]; then
	cpu_type=8135
	video_frontend=9712
	wifi=8188
fi 
if [ "$type" == "1702" ]; then
	cpu_type=8135
	video_frontend=1045
	wifi=8188
fi 


echo "cpu_type $cpu_type"
echo "wifi $wifi"
echo "sensor $video_frontend"


#if [ "${wifi:0:4}" == "8188" ]; then
#	echo "/sbin/insmod /lib/modules/8188eu.ko"
#	/sbin/insmod /lib/modules/8188eu.ko
#fi

#if [ "${wifi:0:4}" == "7601" ]; then
#	echo "/sbin/insmod /lib/modules/mt7601.ko"
#	/sbin/insmod /lib/modules/mtutil7601Usta.ko
#	/sbin/insmod /lib/modules/mt7601Usta.ko
#	/sbin/insmod /lib/modules/mtnet7601Usta.ko
#fi

video_system=PAL
# Support video_front_end: ov2710, ov2715, ov9712, ov9715, ov9714, ov5653
# Support video_front_end: mt9m034, ar0130, ar0140, ar0330, ar0331
# Support video_front_end: imx222, imx238, imx236, imx238

chipver=`head -1 /proc/pmu/chipver`
chipid=`echo $chipver | cut -c 1-4`

if [ "$chipid" != "8136" ] && [ "$chipid" != "8135" ]; then
    echo "Error! Not support chip version $chipver."
    exit
fi

if [ "$video_system" != "NTSC" ] && [ "$video_system" != "PAL" ]; then
    echo "Invalid argument for NTSC/PAL."
    exit
fi

/sbin/insmod /lib/modules/frammap.ko
cat /proc/frammap/ddr_info
/sbin/insmod /lib/modules/log.ko mode=0 log_ksize=64
/sbin/insmod /lib/modules/ms.ko
/sbin/insmod /lib/modules/em.ko
#/sbin/insmod /lib/modules/flcd200-common.ko
#/sbin/insmod /lib/modules/flcd200-pip.ko output_type=0 fb0_fb1_share=1    # CVBS display
#/sbin/insmod /lib/modules/sar_adc.ko
/sbin/insmod /lib/modules/think2d.ko
#/sbin/insmod /lib/modules/ftpwmtmr010.ko
/sbin/insmod /lib/modules/fe_common.ko
/sbin/insmod /lib/modules/adda308.ko output_mode=1 input_mode=0 single_end=1 
/sbin/insmod /lib/modules/ft3dnr200.ko src_yc_swap=1 dst_yc_swap=1 ref_yc_swap=1

echo "video_frontend $video_frontend"
case "$video_frontend" in
        "9715"|"9712"|"9710")
        echo "case 9712"
        codec_max_width=1280
        codec_max_height=720
        if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_ov9715.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_ov9715.ko sensor_w=1280 sensor_h=720 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_ov9715.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
            /sbin/insmod /lib/modules/fisp_ov9715.ko sensor_w=1280 sensor_h=720 fps=25 mirror=0 flip=0
        fi        
        ;;    
        "1045")
        echo "case 1045"
				codec_max_width=1280
				codec_max_height=720
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc1045.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc1045.ko sensor_w=1280 sensor_h=720 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc1045.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
            /sbin/insmod /lib/modules/fisp_sc1045.ko sensor_w=1280 sensor_h=720 fps=25 mirror=0 flip=0
        fi        
        ;;
		"1145")
        echo "case 1145"
				codec_max_width=1280
				codec_max_height=720
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc1045.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc1145.ko sensor_w=1280 sensor_h=720 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc1045.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
            /sbin/insmod /lib/modules/fisp_sc1145.ko sensor_w=1280 sensor_h=720 fps=25 mirror=0 flip=0
        fi        
        ;;
		"1225")
        echo "case 1225"
				codec_max_width=1280
				codec_max_height=960
				echo =========================================================================
				echo "vgboot.sh----1225"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_imx225.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_imx225.ko sensor_w=1280 sensor_h=960 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_imx225.cfg
            echo =========================================================================
						echo "vgboot.sh----225,isp328_imx225.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_imx225.ko sensor_w=1280 sensor_h=960 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----225,fisp_imx225.ko"
						echo =========================================================================
        fi        
        ;;  
		"1135")
        echo "case 1135"
				codec_max_width=1280
				codec_max_height=960
				echo =========================================================================
				echo "vgboot.sh----1135"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc1135.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc1135.ko sensor_w=1280 sensor_h=960 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc1135.cfg
            echo =========================================================================
						echo "vgboot.sh----1135,isp328_sc1135.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_sc1135.ko sensor_w=1280 sensor_h=960 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----1135,fisp_sc1135.ko"
						echo =========================================================================
        fi        
        ;;  
    "0130")
        echo "case 0130"
				codec_max_width=1280
				codec_max_height=960
				echo =========================================================================
				echo "vgboot.sh----0130"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_mt9m034.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_mt9m034.ko sensor_w=1280 sensor_h=960 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_mt9m034.cfg
            echo =========================================================================
						echo "vgboot.sh----0130,fisp_mt9m034.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_mt9m034.ko sensor_w=1280 sensor_h=960 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----0130,fisp_mt9m034.ko"
						echo =========================================================================
        fi        
        ;;   
	"0330")
		echo "case 0330"
				codec_max_width=1792
				codec_max_height=1536
				echo =========================================================================
				echo "vgboot.sh----0330"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_ar0330.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_ar0330.ko sensor_w=1792 sensor_h=1536 fps=18 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_ar0330.cfg
            echo =========================================================================
						echo "vgboot.sh----0330,isp328_ar0330.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1     
            echo =========================================================================
						echo "vgboot.sh----0330,fisp_algorithm.ko"
						echo =========================================================================   
           	/sbin/insmod /lib/modules/fisp_ar0330.ko sensor_w=1792 sensor_h=1536 fps=18 mirror=0 flip=0 interface=0
            echo =========================================================================
						echo "vgboot.sh----0330,fisp_ar0330.ko"
						echo =========================================================================
        fi        
        ;;  
	"3035")
		echo "case 3035"
				codec_max_width=1792
				codec_max_height=1536
				echo =========================================================================
				echo "vgboot.sh----3035"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc3035.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc3035.ko sensor_w=1792 sensor_h=1536 fps=18 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc3035.cfg
            echo =========================================================================
						echo "vgboot.sh----3035,isp328_sc3035.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1     
            echo =========================================================================
						echo "vgboot.sh----3035,fisp_algorithm.ko"
						echo =========================================================================      
           	/sbin/insmod /lib/modules/fisp_sc3035.ko sensor_w=1792 sensor_h=1536 fps=18 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----3035,fisp_sc3035.ko"
						echo =========================================================================
        fi        
        ;;  
    	"2035")
        echo "case 2035"
				codec_max_width=1920
				codec_max_height=1080
				echo =========================================================================
				echo "vgboot.sh----2035"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc2035.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc2035.ko sensor_w=1920 sensor_h=1080 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc2035.cfg
            echo =========================================================================
						echo "vgboot.sh----2035,isp328_sc2035.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_sc2035.ko sensor_w=1920 sensor_h=1080 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----2035,fisp_sc2035.ko"
						echo =========================================================================
        fi        
        ;;    
	"2135")
        echo "case 2135"
				codec_max_width=1920
				codec_max_height=1080
				echo =========================================================================
				echo "vgboot.sh----2135"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc2135.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc2135.ko sensor_w=1920 sensor_h=1080 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc2135.cfg
            echo =========================================================================
						echo "vgboot.sh----2135,isp328_sc2135.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_sc2135.ko sensor_w=1920 sensor_h=1080 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----2135,fisp_sc2135.ko"
						echo =========================================================================
        fi        
        ;;  
        
        "2235")
        echo "case 2235"
				codec_max_width=1920
				codec_max_height=1080
				echo =========================================================================
				echo "vgboot.sh----2235"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc2235.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc2235.ko sensor_w=1920 sensor_h=1080 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc2235.cfg
            echo =========================================================================
						echo "vgboot.sh----2235,isp328_sc2235.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_sc2235.ko sensor_w=1920 sensor_h=1080 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----2235,fisp_sc2235.ko"
						echo =========================================================================
        fi        
        ;;  
        
		"ov9750")
				codec_max_width=1280
				codec_max_height=960
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_ov9750.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_ov9750.ko sensor_w=1280 sensor_h=960 fps=25 mirror=1 flip=1
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_ov9750.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
            /sbin/insmod /lib/modules/fisp_ov9750.ko sensor_w=1280 sensor_h=960 fps=25 mirror=1 flip=1
        fi        
        ;;    
		"0323")
        echo "case 0323"
				codec_max_width=1920
				codec_max_height=1080
				echo =========================================================================
				echo "vgboot.sh----0323"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_imx323.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_imx323.ko sensor_w=1920 sensor_h=1080 fps=30 mirror=0 flip=0 sensor_spi=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_imx323.cfg
            echo =========================================================================
						echo "vgboot.sh----0323,isp328_imx323.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_imx323.ko sensor_w=1920 sensor_h=1080 fps=25 mirror=0 flip=0 sensor_spi=0
            echo =========================================================================
						echo "vgboot.sh----0323,fisp_imx323.ko"
						echo =========================================================================
        fi        
        ;;  
		"0237")
        echo "case 0237"
				codec_max_width=1920
				codec_max_height=1080
				echo =========================================================================
				echo "vgboot.sh----0237"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_ar0237.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_ar0237.ko sensor_w=1920 sensor_h=1080 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_ar0237.cfg
            echo =========================================================================
						echo "vgboot.sh----0237,isp328_ar0237.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_ar0237.ko sensor_w=1920 sensor_h=1080 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----0237,fisp_ar0237.ko"
						echo =========================================================================
        fi        
        ;;
        "1235")
        echo "case 1235"
				codec_max_width=1280
				codec_max_height=960
				echo =========================================================================
				echo "vgboot.sh----1235"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc1235.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc1235.ko sensor_w=1280 sensor_h=960 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc1235.cfg
            echo =========================================================================
						echo "vgboot.sh----1235,isp328_sc1235.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_sc1235.ko sensor_w=1280 sensor_h=960 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----1235,fisp_sc1235.ko"
						echo =========================================================================
        fi        
        ;;  
          
		"0290")
        echo "case 0290"
				codec_max_width=1920
				codec_max_height=1080
				echo =========================================================================
				echo "vgboot.sh----0290"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_imx290.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_imx290.ko sensor_w=1920 sensor_h=1080 fps=30 mirror=0 flip=0 interface=2
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_imx290.cfg
            echo =========================================================================
						echo "vgboot.sh----0290,isp328_imx290.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_imx290.ko sensor_w=1920 sensor_h=1080 fps=25 mirror=0 flip=0 interface=2
            echo =========================================================================
						echo "vgboot.sh----0290,fisp_imx290.ko"
						echo =========================================================================
        fi        
        ;;  
        
        "2143")
        echo "case 2143"
				codec_max_width=1280
				codec_max_height=960
				echo =========================================================================
				echo "vgboot.sh----2143"
				echo =========================================================================
				if [ "$video_system" == "NTSC" ]  ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc2143.cfg
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=0            
            /sbin/insmod /lib/modules/fisp_sc2143.ko sensor_w=1280 sensor_h=960 fps=30 mirror=0 flip=0
        elif [ "$video_system" == "PAL" ] ; then
            /sbin/insmod /lib/modules/fisp328.ko cfg_path=/usr/gm/cfg/isp328_sc2143.cfg
            echo =========================================================================
						echo "vgboot.sh----2143,isp328_sc2143.cfg"
						echo =========================================================================
            /sbin/insmod /lib/modules/fisp_algorithm.ko pwr_freq=1            
           	/sbin/insmod /lib/modules/fisp_sc2143.ko sensor_w=1280 sensor_h=960 fps=25 mirror=0 flip=0
            echo =========================================================================
						echo "vgboot.sh----2143,fisp_sc2143.ko"
						echo =========================================================================
        fi        
        ;;    
    *)
        echo "Invalid argument for video frontend: $video_frontend"
        exit
        ;;
esac

/sbin/insmod /lib/modules/vcap300_common.ko
/sbin/insmod /lib/modules/vcap0.ko vi_mode=0,1 ext_irq_src=1
/sbin/insmod /lib/modules/vcap300_isp.ko ch_id=0 range=1
/sbin/insmod /lib/modules/fmcp_drv.ko mp4_tight_buf=1						
/sbin/insmod /lib/modules/favc_enc.ko h264e_max_b_frame=0 h264e_one_ref_buf=1 h264e_tight_buf=1 h264e_max_chn=6 h264e_max_width=$codec_max_width h264e_max_height=$codec_max_height h264e_slice_offset=1
/sbin/insmod /lib/modules/favc_rc.ko
#jpeg
/sbin/insmod /lib/modules/decoder.ko
#jpeg
/sbin/insmod /lib/modules/fmjpeg_drv.ko jpg_enc_max_chn=1
#mjpeg 
#/sbin/insmod /lib/modules/fmpeg4_drv.ko mp4_max_width=$codec_max_width mp4_max_height=$codec_max_height
#/sbin/insmod /lib/modules/mp4e_rc.ko

# Encode 4CH + Cascade YUV 1CH
/sbin/insmod /lib/modules/sw_osg.ko
/sbin/insmod /lib/modules/fscaler300.ko max_vch_num=3 max_minors=3 temp_width=0 temp_height=0
#/sbin/insmod /lib/modules/ftdi220.ko
/sbin/insmod /lib/modules/osd_dispatch.ko
/sbin/insmod /lib/modules/codec.ko
/sbin/insmod /lib/modules/audio_drv.ko audio_ssp_num=0,1 audio_ssp_chan=1,1 bit_clock=400000,400000 sample_rate=8000,8000 audio_out_enable=1,0
/sbin/insmod /lib/modules/gs.ko reserved_ch_cnt=1 alloc_unit_size=65536 flow_mode=1
/sbin/insmod /lib/modules/loop_comm.ko
/sbin/insmod /lib/modules/vpd_slave.ko vpslv_dbglevel=0 ddr0_sz=0 ddr1_sz=0 config_path="/mnt/mtd/" usr_func=0 usr_param=0 datain_minors=4 dataout_minors=8
/sbin/insmod /lib/modules/vpd_master.ko vpd_dbglevel=0 gmlib_dbglevel=0
/sbin/insmod /lib/modules/ftpwmtmr010.ko
/sbin/insmod /lib/modules/gm_steppermotor.ko

echo =========================================================================
echo "insmod gm_steppermotor.ko"
echo =========================================================================

echo /mnt/nfs > /proc/videograph/dumplog   #configure log path
mdev -s
cat /proc/modules
echo 0 > /proc/frammap/free_pages   #should not free DDR1 for performance issue
echo 1 > /proc/vcap300/vcap0/dbg_mode  #need debug mode to detect capture overflow
echo 0 > /proc/videograph/em/dbglevel
echo 0 > /proc/videograph/gs/dbglevel
echo 0 > /proc/videograph/ms/dbglevel
echo 0 > /proc/videograph/datain/dbglevel
echo 0 > /proc/videograph/dataout/dbglevel
echo 0 > /proc/videograph/vpd/dbglevel
echo 0 > /proc/videograph/gmlib/dbglevel

echo =========================================================================
if [ -e /usr/gm/cfg/gmlib.cfg ] ; then
grep ";" /mnt/mtd/gmlib.cfg |sed -n '1,1p'
else
grep ";" /usr/gm/cfg/spec.cfg |sed -n '2,6p'
fi

rootfs_date=`ls /|grep 00_2`
mtd_date=`ls /mnt/mtd|grep 00_2`
echo =========================================================================
echo "  Video Front End: $video_frontend"
echo "  Chip Version: $chipver"
echo "  RootFS Version: $rootfs_date"
echo "  MTD Version: $mtd_date"
echo =========================================================================

devmem 0x9a1000a0 32 0x87878587
devmem 0x9a100034 32 0x061f0606
devmem 0x9a1000c4 32 0x08000f08
devmem 0x9a1000c8 32 0x061f0606
devmem 0x9a100030 32 0xDF000f04

#devmem 0x96105440 32 0x01500000
#devmem 0x96105438 32 0x01500000
#echo 1 0x50 > /proc/3dnr/dma/param
#echo w ae_en 0 > /proc/isp320/command
#echo w sen_exp 133 > /proc/isp320/command
#echo w fps 15 > /proc/isp320/command

# force max CPU performance
#echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor



#echo 1 > /proc/sys/vm/overcommit_memory
#echo 1 > /proc/sys/vm/oom_kill_allocating_task

echo DeltaQPWeight 4 > /proc/videograph/h264e/param
echo IPOffset 3 > /proc/videograph/h264e/param	
#echo "0" >> proc/isp328/awb/sta_mode 

echo "Ready 2 sh check_mod.sh"
sh /usr/gm/sh/check_mod.sh
