#!/bin/bash
set -e

# Disable PGP check in PRoot container
sed -i 's/SigLevel.*=.*Required.*/SigLevel = Never/' /etc/pacman.conf || true
sed -i 's/#SigLevel = Never/SigLevel = Never/' /etc/pacman.conf || true

pacman -S --noconfirm --needed \
    xfce4 xfce4-goodies \
    materia-gtk-theme papirus-icon-theme \
    ttf-jetbrains-mono noto-fonts noto-fonts-cjk noto-fonts-emoji \
    mesa libglvnd \
    nano git sudo fish starship fastfetch \
    firefox vlc mousepad ristretto xfce4-terminal
