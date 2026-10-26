#!/data/data/com.termux/files/usr/bin/env bash
# pulse_start.sh - start PulseAudio in Termux with the AAudio sink and a local TCP server

echo "Stopping earlier PulseAudio processes..."
pkill -f pulseaudio 2>/dev/null || true
sleep 1

# Tells other programs where to send their audio
export PULSE_SERVER=127.0.0.1

echo "Starting PulseAudio with the aaudio sink..."
pulseaudio -D \
    --log-level=4 \
    --log-target=file:$HOME/pa.log \
    --log-time=0 \
    --exit-idle-time=-1 \
    --load="module-aaudio-sink" \
    --load="module-native-protocol-tcp auth-anonymous=1 auth-ip-acl=127.0.0.1"

echo "PulseAudio started. To check the log: tail -f $HOME/pa.log"
