#!/data/data/com.termux/files/usr/bin/bash
echo "Menghentikan semua sesi MateDesk..."
killall -9 termux-x11 virgl_test_server_android pulseaudio 2>/dev/null || true
echo "Semua sesi berhasil dihentikan."
