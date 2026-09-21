#!/bin/bash
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
export LIBGL_ALWAYS_INDIRECT=0
export VIRGL_CLIENT_DIR=/tmp

# Start D-Bus session daemon
eval $(dbus-launch --sh-syntax)

# Start Window Manager and Desktop components
xfwm4 --replace &
xfsettingsd &
xfdesktop &
xfce4-panel &

# Start terminal with Fastfetch
sleep 1
xfce4-terminal --title="MateDesk CachyOS Terminal" --command="bash -c 'fastfetch; exec bash'" &

# Wait for panel to keep session open
wait
