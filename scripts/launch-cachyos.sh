#!/bin/bash
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
export LIBGL_ALWAYS_INDIRECT=0
export VIRGL_CLIENT_DIR=/data/data/com.termux/files/usr/tmp

# Start XFCE Terminal with Fastfetch automatically
xfce4-terminal --maximize --title="MateDesk CachyOS Terminal" --command="bash -c 'fastfetch; exec bash'" &

# Start XFCE Session
exec dbus-launch --exit-with-session xfce4-session
