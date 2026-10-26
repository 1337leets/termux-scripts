#!/data/data/com.termux/files/usr/bin/env bash
# tinycore-qemu.sh - boot the Tiny Core Linux live CD in QEMU from Termux
# Expects Core-current.iso, core.img and tce_disk.qcow2 in the home directory.
# SSH on the guest is forwarded to port 2222, the screen is served over VNC display :0 (port 5900).

cd "$HOME" || exit 1
qemu-system-i386 \
  -cdrom Core-current.iso \
  -hda core.img \
  -hdb "$HOME/tce_disk.qcow2" \
  -boot d \
  -m 128 \
  -net nic \
  -net user,hostfwd=tcp::2222-:22 \
  -vnc :0
