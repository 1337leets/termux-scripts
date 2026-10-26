#!/data/data/com.termux/files/usr/bin/env bash
# start_xfce.sh - Termux X11 + XFCE
# ~/start_xfce.sh {start|stop|status}

LOG="$HOME/x11_start.log"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Could not find '$1'." | tee -a "$LOG"
    return 1
  }
  return 0
}

stop_all() {
  echo "==> Stopping X11 session and related services..." | tee -a "$LOG"
  pkill -f termux-x11 2>/dev/null || true
  pkill -f xfce4 2>/dev/null || true
  pkill -f dbus-daemon 2>/dev/null || true
  pkill -f pulseaudio 2>/dev/null || true
  pkill -f gpg-agent 2>/dev/null || true
  sleep 1
  echo "==> Stopped." | tee -a "$LOG"
}

status_all() {
  echo "=== X11/XFCE related processes ===" | tee -a "$LOG"
  ps -A | egrep 'termux-x11|xfce4|dbus-daemon|pulseaudio|gpg-agent' || true
}

start_all() {
  echo "---- Starting X11 + XFCE session: $(date) ----" | tee -a "$LOG"

  # quick checks
  need_cmd termux-x11 "termux-x11-nightly" || true
  need_cmd dbus-daemon "dbus" || true
  need_cmd pulseaudio "pulseaudio" || true
  # startxfce4 may be part of xfce packages
  command -v startxfce4 >/dev/null 2>&1 || echo "xfce4 does not exist" | tee -a "$LOG"

  # Kill leftovers
  echo "Killing leftovers..." | tee -a "$LOG"
  pkill -f termux-x11 2>/dev/null || true
  pkill -f xfce4 2>/dev/null || true
  pkill -f dbus-daemon 2>/dev/null || true
  pkill -f pulseaudio 2>/dev/null || true
  pkill -f gpg-agent 2>/dev/null || true
  sleep 1

  # Start dbus session daemon (if available)
  if command -v dbus-daemon >/dev/null 2>&1; then
    echo "Starting dbus-daemon..." | tee -a "$LOG"
    dbus-daemon --session --address=unix:path="$PREFIX/var/run/dbus-session" >>"$LOG" 2>&1 &
    sleep 1
  else
    echo "dbus-daemon does not exist" | tee -a "$LOG"
  fi

  # Environment
  export DISPLAY=:0
  export PULSE_SERVER=127.0.0.1
  echo "DISPLAY=$DISPLAY PULSE_SERVER=$PULSE_SERVER" | tee -a "$LOG"

  # Start pulseaudio
  if command -v pulseaudio >/dev/null 2>&1; then
    echo "Starting pulseaudio with aaudio sink..." | tee -a "$LOG"
    pulseaudio -D \
        --log-level=4 \
        --log-target=file:"$HOME/pa.log" \
        --log-time=0 \
        --exit-idle-time=-1 \
		--load="module-aaudio-sink" \
		--load="module-native-protocol-tcp auth-anonymous=1 auth-ip-acl=127.0.0.1" >>"$LOG" 2>&1 || echo "pulseaudio start error" | tee -a "$LOG"
    sleep 1
  fi

  # Start termux-x11
  if command -v termux-x11 >/dev/null 2>&1; then
    echo "Starting termux-x11..." | tee -a "$LOG"
    termux-x11 :0 >>"$LOG" 2>&1 &
    sleep 2
  else
    echo "Can't find termux-x11" | tee -a "$LOG"
  fi

  # Suppress DPMS / screensaver warnings if xset exists
  if command -v xset >/dev/null 2>&1; then
    xset s off -dpms >>"$LOG" 2>&1 || true
  fi

  # Start XFCE session (use dbus-launch if present)
  echo "Starting XFCE session..." | tee -a "$LOG"
  if command -v dbus-launch >/dev/null 2>&1; then
    dbus-launch --exit-with-session startxfce4 >>"$LOG" 2>&1 &
  else
    startxfce4 >>"$LOG" 2>&1 &
  fi

  echo "Started. Tail the log with: tail -f $LOG" | tee -a "$LOG"
}

# Main dispatcher
case "${1:-start}" in
  start)
    start_all
    ;;
  stop)
    stop_all
    ;;
  status)
    status_all
    ;;
  *)
    echo "Usage: $0 {start|stop|status}"
    exit 1
    ;;
esac
