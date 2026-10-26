# Termux Scripts

Small helper scripts I use in Termux on my Android phone. Each one sits in its own folder and does one job. They
are short and were written for my own setup, so check the paths and package names before running them on yours.

## x11-xfce-session

`start_xfce.sh` starts a full XFCE desktop on Termux:X11. It starts a D-Bus session daemon, PulseAudio with the
AAudio sink, the `termux-x11` server on display `:0` and finally `startxfce4`, logging everything to
`~/x11_start.log`.

```
./start_xfce.sh start     # also the default
./start_xfce.sh stop      # kill the X11, XFCE, D-Bus and PulseAudio processes
./start_xfce.sh status    # list those processes
```

It needs the `termux-x11-nightly`, `xfce4`, `dbus` and `pulseaudio` packages and the Termux:X11 app. Missing commands
are reported in the log instead of stopping the script.

## pulseaudio-start

`pulse_start.sh` restarts PulseAudio on its own, with the same AAudio sink and a TCP server that only accepts
connections from `127.0.0.1`. Programs that set `PULSE_SERVER=127.0.0.1`, for example ones running in a proot
distribution, can then play sound through the phone. The log goes to `~/pa.log`.

## tinycore-qemu

`tinycore-qemu.sh` boots the Tiny Core Linux live CD in `qemu-system-i386` with 128 MB of RAM. It expects
`Core-current.iso`, `core.img` and the extension disk `tce_disk.qcow2` in the home directory. Port 2222 on the
phone is forwarded to SSH in the guest, and the screen is served over VNC on display `:0`. I used it to run 32-bit
x86 programs on the phone.

## blinking-text

`blinking_text.sh` is a fifteen-line demo that blinks a line of red text with ANSI escape codes. It hides the
cursor and puts it back when you press Ctrl+C.

## License

MIT, see [LICENSE](LICENSE).
