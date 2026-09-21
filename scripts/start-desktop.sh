#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# Launcher MateDesk CachyOS
# ==============================================================================

export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PREFIX/bin/applets:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export HOME=/data/data/com.termux/files/home
export TMPDIR=$PREFIX/tmp

CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}[*] Menyiapkan environment MateDesk CachyOS...${NC}"

# Matikan proses lama jika ada & bersihkan socket/lock
killall -9 termux-x11 virgl_test_server_android pulseaudio xfce4-session 2>/dev/null || true
rm -rf $TMPDIR/.X11-unix $TMPDIR/.X0-lock $TMPDIR/.virgl_test 2>/dev/null || true
mkdir -p $TMPDIR/.X11-unix
chmod 1777 $TMPDIR/.X11-unix

# 1. Start PulseAudio server
echo -e "${GREEN}[1/4] Memulai Audio Subsystem (PulseAudio)...${NC}"
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 2>/dev/null || true

# 2. Start Termux-X11 Display Server
echo -e "${GREEN}[2/4] Memulai Display Server (Termux-X11)...${NC}"
termux-x11 :0 -ac &
sleep 2

# 3. Start VirGL Server untuk Akselerasi GPU Huawei Maleoon
echo -e "${GREEN}[3/4] Mengaktifkan GPU Acceleration (HiSilicon Maleoon VirGL Proxy)...${NC}"
virgl_test_server_android &
sleep 1

# 4. Buka App Termux-X11 di Android
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity 2>/dev/null || true
sleep 1

# 5. Launch XFCE4 Desktop Session di Arch Linux
echo -e "${GREEN}[4/4] Membuka sesi CachyOS Desktop...${NC}"
proot-distro login archlinux --shared-tmp -- env DISPLAY=:0 PULSE_SERVER=127.0.0.1 GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 LIBGL_ALWAYS_INDIRECT=0 VIRGL_CLIENT_DIR=/data/data/com.termux/files/usr/tmp dbus-launch --exit-with-session xfce4-session

# Bersihkan daemon saat desktop ditutup
echo -e "\n${CYAN}[*] Membersihkan background processes...${NC}"
killall -9 virgl_test_server_android termux-x11 2>/dev/null || true
