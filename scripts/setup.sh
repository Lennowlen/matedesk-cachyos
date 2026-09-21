#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# MateDesk CachyOS Setup Script
# Optimized for Huawei MatePad 12 X (HiSilicon Kirin & Maleoon GPU)
# ==============================================================================

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
cat << "EOF"
  __  __       _       ____            _    
 |  \/  | __ _| |_ ___|  _ \  ___  ___| | __
 | |\/| |/ _` | __/ _ \ | | |/ _ \/ __| |/ /
 | |  | | (_| | ||  __/ |_| |  __/\__ \   < 
 |_|  |_|\__,_|\__\___|____/ \___||___/_|\_\
         CachyOS Edition for MatePad 12 X
EOF
echo -e "${NC}"
echo -e "${GREEN}[*] Memulai instalasi MateDesk (CachyOS Experience)...${NC}"

# 1. Update Termux Package & Install Prerequisite
echo -e "\n${YELLOW}[1/6] Memperbarui sistem Termux & menginstall dependensi host...${NC}"
pkg update -y && pkg upgrade -y
pkg install -y x11-repo
pkg install -y termux-x11-nightly virglrenderer-android proot-distro pulseaudio wget git tar jq

# 2. Setup Base Arch Linux ARM
echo -e "\n${YELLOW}[2/6] Memasang base Arch Linux ARM64...${NC}"
if ! proot-distro list | grep -q "archlinux.*installed"; then
    proot-distro install archlinux
else
    echo -e "${GREEN}[+] Arch Linux sudah terpasang. Melanjutkan konfigurasi...${NC}"
fi

# 3. Setup Distro Packages & CachyOS Aesthetics inside Arch
echo -e "\n${YELLOW}[3/6] Mengonfigurasi paket desktop & styling tema CachyOS...${NC}"
proot-distro login archlinux -- bash -c '
set -e
pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syu --noconfirm
pacman -S --noconfirm --needed \
    xfce4 xfce4-goodies \
    arc-gtk-theme papirus-icon-theme \
    ttf-jetbrains-mono noto-fonts noto-fonts-cjk noto-fonts-emoji \
    mesa libglvnd \
    nano git sudo fish starship fastfetch \
    firefox vlc mousepad ristretto xfce4-terminal
'

# 4. Inisialisasi Konfigurasi User & Lingkungan GPU Maleoon di Distro
echo -e "\n${YELLOW}[4/6] Mengonfigurasi environment GPU Maleoon & CachyOS Theme...${NC}"
proot-distro login archlinux -- bash -c '
# Buat direktori config
mkdir -p /root/.config/fastfetch
mkdir -p /root/.config/xfce4/xfconf/xfce-perchannel-xml

# Fastfetch Custom Config
cat << "EOF_FF" > /root/.config/fastfetch/config.jsonc
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "small"
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "display",
    "de",
    "wm",
    "theme",
    "icons",
    "font",
    "terminal",
    "cpu",
    "gpu",
    "memory",
    "break"
  ]
}
EOF_FF

# Starship Prompt Config
cat << "EOF_SS" > /root/.config/starship.toml
format = """
[┌───────────────────>](bold green)
[│](bold green) $directory$git_branch$git_status
[└─>](bold green) $character"""

[directory]
style = "bold cyan"

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"
EOF_SS

# Environment Variable untuk VirGL Passthrough & Fastfetch
cat << "EOF_BASHRC" > /root/.bashrc
# MateDesk Environment for Huawei Maleoon GPU
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
export LIBGL_ALWAYS_INDIRECT=0
export VIRGL_CLIENT_DIR="/data/data/com.termux/files/usr/tmp"

# Starship shell init
eval "$(starship init bash)"

# Fastfetch display on interactive shell
if [ -t 1 ]; then
    fastfetch
fi
EOF_BASHRC

# Set default shell theme XFCE ke Arc-Dark & Papirus-Dark
cat << "EOF_XFWM" > /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Arc-Dark"/>
    <property name="title_font" type="string" value="JetBrains Mono 10"/>
  </property>
</channel>
EOF_XFWM

cat << "EOF_XSET" > /root/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Arc-Dark"/>
    <property name="IconThemeName" type="string" value="Papirus-Dark"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="FontName" type="string" value="Noto Sans 10"/>
    <property name="MonospaceFontName" type="string" value="JetBrains Mono 10"/>
  </property>
</channel>
EOF_XSET
'

# 5. Buat Script Launcher di Termux Host
echo -e "\n${YELLOW}[5/6] Membuat launcher scripts di Termux host...${NC}"
mkdir -p $HOME/.matedesk

cat << 'EOF_LAUNCHER' > $HOME/start-desktop.sh
#!/data/data/com.termux/files/usr/bin/bash
# Launcher MateDesk CachyOS

CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}[*] Menyiapkan environment MateDesk CachyOS...${NC}"

# Matikan proses lama jika ada
killall -9 termux-x11 virgl_test_server_android pulseaudio 2>/dev/null || true

# 1. Start PulseAudio server
echo -e "${GREEN}[1/4] Memulai Audio Subsystem (PulseAudio)...${NC}"
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

# 2. Start Termux-X11 Display Server
echo -e "${GREEN}[2/4] Memulai Display Server (Termux-X11)...${NC}"
termux-x11 :0 -ac &
sleep 1

# 3. Start VirGL Server untuk Akselerasi GPU Huawei Maleoon
echo -e "${GREEN}[3/4] Mengaktifkan GPU Acceleration (HiSilicon Maleoon VirGL Proxy)...${NC}"
virgl_test_server_android &
sleep 1

# 4. Buka App Termux-X11 di Android
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity 2>/dev/null || true

# 5. Launch XFCE4 Desktop Session di Arch Linux
echo -e "${GREEN}[4/4] Membuka sesi CachyOS Desktop...${NC}"
proot-distro login archlinux --shared-tmp -- bash -c "
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
export LIBGL_ALWAYS_INDIRECT=0
export VIRGL_CLIENT_DIR=/data/data/com.termux/files/usr/tmp
xfce4-session
"

# Bersihkan daemon saat desktop ditutup
echo -e "\n${CYAN}[*] Membersihkan background processes...${NC}"
killall -9 virgl_test_server_android termux-x11 2>/dev/null || true
EOF_LAUNCHER
chmod +x $HOME/start-desktop.sh

cat << 'EOF_STOP' > $HOME/stop-desktop.sh
#!/data/data/com.termux/files/usr/bin/bash
echo "Menghentikan semua sesi MateDesk..."
killall -9 termux-x11 virgl_test_server_android pulseaudio 2>/dev/null || true
echo "Semua sesi berhasil dihentikan."
EOF_STOP
chmod +x $HOME/stop-desktop.sh

# 6. Selesai
echo -e "\n${GREEN}======================================================${NC}"
echo -e "${GREEN} [*] INSTALASI MATEDESK CACHYOS BERHASIL!             ${NC}"
echo -e "${GREEN}======================================================${NC}"
echo -e "Untuk menjalankan Desktop CachyOS:"
echo -e "   ${CYAN}bash ~/start-desktop.sh${NC}"
echo -e "\nUntuk menghentikan sesi:"
echo -e "   ${CYAN}bash ~/stop-desktop.sh${NC}"
echo -e "\nPastikan aplikasi ${YELLOW}Termux-X11${NC} sudah terpasang di MatePad Anda."
