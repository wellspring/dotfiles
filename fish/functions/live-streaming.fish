function live-streaming --description 'Record the desktop, and live broadcast/stream it online. (could be also used to make a screencast)'
	set -l local_cfg ~/.live-streaming.conf

  if test (count $argv) -ge 1
    set rtmp_stream $argv[1]
  else if test -f $local_cfg
    set rtmp_stream (cat $local_cfg)
  else
    echo "Usage: live-streaming [rtmpurl]"
    echo "  (or store the rtmp stream url in your $local_cfg)"
    return -1
  end

  # Screen stream
  set -l input_resolution (xwininfo -root | awk -F'[ +]*' '/geometry/ {print $3}')
  set -l output_resolution $input_resolution
  set -l fps 15
  set -l gopmin $fps
  set -l gop (= "2*$fps")
  set -l threads 2
  set -l cbr 1000k
  set -l key_frame 2
  set -l quality ultrafast
  set -l audio_rate 44100
  set -l audio_bitrate 96k
  set -l constant_rate_factor 23

  # Webcam stream (to enable: add '-vf $webcam' before '-strict')
  set -l webcam_device /dev/video0
  set -l webcam_size 240x160
  set -l webcam_position "780:435"
  set -l webcam "movie=$webcam_device:f=video4linux2, scale=$webcam_size, setpts=PTS-STARTPTS [WebCam]; [in] setpts=PTS-STARTPTS [Screen]; [Screen][WebCam] overlay=$webcam_position [out]"

  # start...
  echo Streaming... | colorize 198
  ffmpeg -f x11grab -s $input_resolution -framerate $fps -i :0.0 -f alsa -i pulse -f flv -ac 2 -ar $audio_rate \
         -vcodec libx264 -force_key_frames "expr:gte(t,n_forced*$key_frame)" -g $gop -keyint_min $gopmin -b:v $cbr \
         -minrate $cbr -maxrate $cbr -pix_fmt yuv420p -s $output_resolution -preset ultrafast -tune film \
         -acodec libmp3lame -threads $threads -strict normal -bufsize $cbr \
         "$rtmp_stream" 2> "/var/tmp/ffmpeg_streaming_"(date +%Y-%m-%d_%Hh%M)".log"
end
