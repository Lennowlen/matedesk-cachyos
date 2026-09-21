# MateDesk CachyOS Edition

<p align="center">
  <img src="assets/screenshots/preview.png" alt="MateDesk CachyOS Preview" width="750" style="border-radius: 12px;">
</p>

<p align="center">
  <b>Turn your Huawei MatePad 12 X into a sleek CachyOS Linux Workstation with GPU Hardware Acceleration.</b><br>
  Powered by Termux, PRoot Arch Linux ARM64, Termux-X11, and VirGL Driver Passthrough.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Huawei%20MatePad%2012%20X-00C8B3?style=for-the-badge&logo=huawei" alt="Platform">
  <img src="https://img.shields.io/badge/GPU-HiSilicon%20Maleoon%20(VirGL)-00F076?style=for-the-badge" alt="GPU">
  <img src="https://img.shields.io/badge/Base-CachyOS%20%2F%20Arch%20ARM-1793D1?style=for-the-badge&logo=arch-linux" alt="OS">
  <img src="https://img.shields.io/badge/License-GPL--3.0-blue?style=for-the-badge" alt="License">
</p>

---

## ✨ Features

- 🚀 **HiSilicon Maleoon Hardware Acceleration**: Custom VirGL host-bridge passthrough enabling OpenGL acceleration on Kirin/Maleoon GPU.
- 🎨 **CachyOS Aesthetics**: Beautiful Emerald & Dark theme with Papirus icons, JetBrains Mono font, Starship prompt, and custom Fastfetch.
- 💻 **No Root / No Bootloader Unlock Required**: Runs completely in userland via Termux & PRoot on HarmonyOS.
- ⚡ **Low-Latency Termux-X11 Display**: High frame rate rendering directly to display buffer on native 2.8K resolution.
- ⌨️ **MatePad Ready**: Full support for Huawei Smart Magnetic Keyboard, M-Pencil (Stylus cursor), and Bluetooth Mouse.

---

## 📱 MateDesk Companion App (Android / HarmonyOS)

Selain menjalankan via command script Termux, repository ini juga menyediakan **MateDesk Standalone App** (source code Flutter di folder `app/`):
- **CachyOS UI Preset by Default**: Dipadukan dengan aksen tema CachyOS Emerald (`#00F076`).
- **One-Tap Desktop Launch**: Menjalankan X11 Server, VirGL GPU Passthrough, dan Desktop Session dengan 1 tombol di aplikasi.
- **Embedded App Store & Terminal**: Memasang aplikasi tambahan (VS Code, Blender, LibreOffice) secara visual.

1. **[Termux](https://f-droid.org/en/packages/com.termux/)** (Download APK from F-Droid, **not** Google Play Store).
2. **[Termux-X11 Nightly](https://github.com/termux/termux-x11/releases/tag/nightly)** (Download `app-arm64-v8a-debug.apk`).

---

## 🚀 One-Line Installation

Open **Termux** on your MatePad and run:

```bash
curl -sL https://raw.githubusercontent.com/Lennowlen/matedesk-cachyos/main/scripts/setup.sh | bash
```

---

## 🖥️ How to Launch the Desktop

1. Open Termux and run:
   ```bash
   bash ~/start-desktop.sh
   ```
2. The **Termux-X11** app will automatically open, presenting your full CachyOS desktop.
3. To stop all desktop background processes:
   ```bash
   bash ~/stop-desktop.sh
   ```

---

## ⚙️ Recommended Termux-X11 Settings for MatePad 12 X

Open the **Termux-X11** app settings (pull down notification or press back button):
- **Display resolution mode**: `native`
- **Display scale**: `125%` or `150%` (Recommended for 2800×1840 3:2 screen)
- **Rescale display**: `Disabled`
- **Fullscreen on device display**: `Enabled`
- **Show additional keyboard**: `Disabled` (if using Huawei Smart Magnetic Keyboard)

---

## 🛠️ What You Can Run

| Software | Performance on Kirin Maleoon |
|---|---|
| **VS Code (C++ / Python / Web)** | 🟢 Very Fast (Native ARM64 Execution) |
| **Firefox / Chromium** | 🟢 Smooth Browsing & Media |
| **LibreOffice Suite** | 🟢 Native Desktop Office Work |
| **GIMP / Inkscape** | 🟢 Full Stylus & Drawing Support |
| **Fastfetch & Starship Shell** | 🟢 Instant terminal feedback |

---

## 📄 License

Licensed under the [GNU General Public License v3.0](LICENSE).
