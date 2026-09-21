#!/bin/bash
set -e

# Disable signature checking everywhere in pacman.conf
sed -i 's/SigLevel.*/SigLevel = Never/' /etc/pacman.conf
sed -i 's/LocalFileSigLevel.*/LocalFileSigLevel = Never/' /etc/pacman.conf
if ! grep -q "LocalFileSigLevel = Never" /etc/pacman.conf; then
    sed -i '/\[options\]/a LocalFileSigLevel = Never' /etc/pacman.conf
fi
if ! grep -q "SigLevel = Never" /etc/pacman.conf; then
    sed -i '/\[options\]/a SigLevel = Never' /etc/pacman.conf
fi

cd /var/cache/pacman/pkg
rm -f /var/lib/pacman/db.lck

echo "[+] Installing offline cached packages without PGP check..."
pacman -U --noconfirm --needed *.pkg.tar.xz

echo "[+] Finishing installation of any remaining packages..."
pacman -S --noconfirm --needed \
    xfce4 xfce4-goodies \
    materia-gtk-theme papirus-icon-theme \
    ttf-jetbrains-mono noto-fonts noto-fonts-cjk noto-fonts-emoji \
    mesa libglvnd \
    nano git sudo fish starship fastfetch \
    firefox vlc mousepad ristretto xfce4-terminal
