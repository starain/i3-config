#!/bin/sh -e

# Take a screenshot
scrot /tmp/screen_locked.png

# Pixellate it 50x
mogrify -scale 1.25% -scale 8000% /tmp/screen_locked.png

# Blur it
convert /tmp/screen_locked.png -blur 0x5 /tmp/screen_locked.png

# Lock screen displaying this image.
i3lock -i /tmp/screen_locked.png

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
