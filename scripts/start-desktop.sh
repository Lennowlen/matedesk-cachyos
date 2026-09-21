#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# MateDesk CachyOS Launcher
# ==============================================================================

export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PREFIX/bin/applets:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export HOME=/data/data/com.termux/files/home
export TMPDIR=$PREFIX/tmp

# Bersihkan sesi lama
killall -9 termux-x11 virgl_test_server_android pulseaudio 2>/dev/null || true
rm -rf $TMPDIR/.X11-unix $TMPDIR/.X*-lock $TMPDIR/.virgl_test 2>/dev/null || true

# 1. Start PulseAudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 2>/dev/null || true

# 2. Start Termux-X11 Display Server
termux-x11 :0 -ac &
sleep 2

# 3. Start VirGL Server (GPU Maleoon Acceleration)
virgl_test_server_android &
sleep 1

# 4. Open Termux-X11 Activity
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity 2>/dev/null || true
sleep 1

# 5. Launch CachyOS Desktop Session
proot-distro login archlinux --shared-tmp -- /root/launch-cachyos.sh
