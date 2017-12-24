#!/bin/sh -e

lock_img=/tmp/screen_locked.png

# Take a screenshot
scrot $lock_img

# Pixellate it 50x then blur it
cmd="convert $lock_img -scale 1.25% -scale 8000% -blur 0x5"

# Embed xkcd
url=$(curl -L https://c.xkcd.com/random/comic/ | grep "(for hotlinking/embedding)" | cut -d " " -f 5)
if [ "$url" != "" ]
then
  xkcd_img=/tmp/xkcd.png
  curl -o $xkcd_img $url
  s=$(identify -format "%h %w" $lock_img)
  s_h=$(echo "$s" | cut -f 1 -d \ )
  s_w=$(echo "$s" | cut -f 2 -d \ )
  s=$(identify -format "%h %w" $xkcd_img)
  e_h=$(echo "$s" | cut -f 1 -d \ )
  e_w=$(echo "$s" | cut -f 2 -d \ )
  px=$((s_w / 2 - e_w / 2))
  py=$((s_h / 2 - e_h / 2))
  # Embed the image to the middle of the screen.
  cmd="$cmd ( $xkcd_img -repage +$px+$py ) -layers flatten"
fi
cmd="$cmd $lock_img"
$cmd

# Lock screen displaying this image.
i3lock -i $lock_img

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
