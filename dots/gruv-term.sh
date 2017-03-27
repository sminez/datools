#!/bin/sh
# GRUVBOX FOR YOUR TERMINAL
# Modified from the base16 shell darktooth theme
# base16-shell (https://github.com/chriskempson/base16-shell)
# Base16 Shell template by Chris Kempson (http://chriskempson.com)
# Darktooth scheme by Jason Milkins (https://github.com/jasonm23)

# This script doesn't support linux console (use 'vconsole' template instead)
if [ "${TERM%%-*}" = 'linux' ]; then
    return 2>/dev/null || exit 0
fi

color00="1D/20/21" # Base 00 - Black
color01="CC/24/1D" # Base 08 - Red
# color02="B8/BB/26" # Base 0B - Green
color02="95/C0/85" # Base 0B - Green
color03="FA/BD/2F" # Base 0A - Yellow
color04="45/85/88" # Base 0D - Blue
color05="B1/62/86" # Base 0E - Magenta
color06="68/9D/6A" # Base 0C - Cyan
color07="FB/F1/C7" # Base 05 - White
color08="66/5C/54" # Base 03 - Bright Black
color09="FB/49/34" # Base 08 - Bright Red
color10="B8/BB/26" # Base 0B - Bright Green
color11="FA/BD/2F" # Base 0A - Bright Yellow
color12="83/A5/98" # Base 0D - Bright Blue
color13="D3/86/9B" # Base 0E - Bright Magenta
color14="8E/C0/7C" # Base 0C - Bright Cyan
color15="FB/F1/C7" # Base 07 - Bright White
color16="FE/86/25" # Base 09
color17="A8/73/22" # Base 0F
color18="32/30/2F" # Base 01
color19="50/49/45" # Base 02
color20="92/83/74" # Base 04
color21="D5/C4/A1" # Base 06
color_foreground="FB/1C/C7" # Base 05
color_background="28/28/28" # Base 00
color_cursor="A8/99/84" # Base 05

if [ -n "$TMUX" ]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  printf_template='\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\'
  printf_template_var='\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\'
  printf_template_custom='\033Ptmux;\033\033]%s%s\033\033\\\033\\'
elif [ "${TERM%%-*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  printf_template='\033P\033]4;%d;rgb:%s\033\\'
  printf_template_var='\033P\033]%d;rgb:%s\033\\'
  printf_template_custom='\033P\033]%s%s\033\\'
else
  printf_template='\033]4;%d;rgb:%s\033\\'
  printf_template_var='\033]%d;rgb:%s\033\\'
  printf_template_custom='\033]%s%s\033\\'
fi

# 16 color space
printf $printf_template 0  $color00
printf $printf_template 1  $color01
printf $printf_template 2  $color02
printf $printf_template 3  $color03
printf $printf_template 4  $color04
printf $printf_template 5  $color05
printf $printf_template 6  $color06
printf $printf_template 7  $color07
printf $printf_template 8  $color08
printf $printf_template 9  $color09
printf $printf_template 10 $color10
printf $printf_template 11 $color11
printf $printf_template 12 $color12
printf $printf_template 13 $color13
printf $printf_template 14 $color14
printf $printf_template 15 $color15

# 256 color space
printf $printf_template 16 $color16
printf $printf_template 17 $color17
printf $printf_template 18 $color18
printf $printf_template 19 $color19
printf $printf_template 20 $color20
printf $printf_template 21 $color21

# clean up
unset printf_template
unset printf_template_var
unset color00
unset color01
unset color02
unset color03
unset color04
unset color05
unset color06
unset color07
unset color08
unset color09
unset color10
unset color11
unset color12
unset color13
unset color14
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background
unset color_cursor
