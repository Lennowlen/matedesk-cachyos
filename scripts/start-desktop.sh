#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# MateDesk CachyOS Launcher
# Optimized for Huawei MatePad 12 X (HarmonyOS / Kirin / HiSilicon Maleoon)
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

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}[*] Menyiapkan environment MateDesk CachyOS di MatePad 12 X...${NC}"

# 1. Bersihkan proses lama & socket X11
killall -9 termux-x11 virgl_test_server_android pulseaudio xfce4-session xfwm4 xfdesktop xfce4-panel 2>/dev/null || true
rm -rf $TMPDIR/.X11-unix $TMPDIR/.X0-lock $TMPDIR/.virgl_test 2>/dev/null || true
mkdir -p $TMPDIR/.X11-unix
chmod 1777 $TMPDIR/.X11-unix

# 2. Mulai Audio PulseAudio
echo -e "${GREEN}[1/4] Memulai Audio Subsystem (PulseAudio)...${NC}"
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 2>/dev/null || true

# 3. Mulai Termux-X11 Display Server dengan flags kompatibilitas MatePad 12 X
echo -e "${GREEN}[2/4] Memulai Display Server (Termux-X11)...${NC}"
termux-x11 :0 -ac -legacy-drawing -disable-gpu-present &
sleep 2

# 4. Aktifkan GPU Passthrough VirGL
echo -e "${GREEN}[3/4] Mengaktifkan GPU Acceleration (HiSilicon Maleoon VirGL Proxy)...${NC}"
virgl_test_server_android &
sleep 1

# 5. Buka Aplikasi Termux-X11 di Android
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity 2>/dev/null || true
sleep 1

# 6. Buka XFCE4 Session Desktop
echo -e "${GREEN}[4/4] Membuka sesi Desktop CachyOS...${NC}"
exec xfce4-session
