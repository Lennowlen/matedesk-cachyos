#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# MateDesk CachyOS Launcher (Official CachyOS Emerald Styling)
# ==============================================================================

export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PREFIX/bin/applets:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export HOME=/data/data/com.termux/files/home
export TMPDIR=$PREFIX/tmp
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330

# Bersihkan sesi lama
killall -9 termux-x11 virgl_test_server_android pulseaudio xfce4-session xfwm4 xfdesktop xfce4-panel 2>/dev/null || true
rm -rf $TMPDIR/.X11-unix $TMPDIR/.X0-lock 2>/dev/null || true
mkdir -p $TMPDIR/.X11-unix
chmod 1777 $TMPDIR/.X11-unix

# 1. Start PulseAudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 2>/dev/null || true

# 2. Start Display Server (Termux-X11)
termux-x11 :0 -ac -legacy-drawing -disable-gpu-present &
sleep 2

# 3. Start VirGL Server (GPU Acceleration)
virgl_test_server_android &
sleep 1

# 4. Open Termux-X11 app
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity 2>/dev/null || true
sleep 1

# 5. Start Terminal with CachyOS Shell & Fastfetch automatically on startup
xfce4-terminal --geometry=120x35+80+60 --title="CachyOS Emerald Terminal" &

# 6. Launch Desktop
exec xfce4-session
