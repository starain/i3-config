#!/bin/sh -e

lock_img=/tmp/screen_locked.png

# Take a screenshot
scrot $lock_img

# Pixellate it 50x
mogrify -scale 1.25% -scale 8000% $lock_img

# Blur it
convert $lock_img -blur 0x5 $lock_img

# Embed xkcd
url=$(curl -L https://c.xkcd.com/random/comic/ | grep "(for hotlinking/embedding)" | cut -d " " -f 5)
if [ "$url" != "" ]
then
  xkcd_img=/tmp/xkcd.png
  curl -o $xkcd_img $url
  s_h=$(identify -format "%h" $lock_img)
  s_w=$(identify -format "%w" $lock_img)
  e_h=$(identify -format "%h" $xkcd_img)
  e_w=$(identify -format "%w" $xkcd_img)
  px=$((s_w / 2 - e_w / 2))
  py=$((s_h / 2 - e_h / 2))
  convert $lock_img \( $xkcd_img -repage +$px+$py \) -layers flatten $lock_img
fi

# Lock screen displaying this image.
i3lock -i $lock_img

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
