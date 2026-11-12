#!/usr/bin/env bash
clear
printf '\e[2m// theme.ts\e[0m\n'
printf '\e[35mexport\e[0m \e[35mconst\e[0m \e[34mpalette\e[0m = \e[36mload\e[0m(\e[32m"dms"\e[0m);\n\n'
printf '\e[35mfunction\e[0m \e[34mapply\e[0m(\e[31mseed\e[0m: \e[33mstring\e[0m) {\n'
printf '  \e[35mif\e[0m (!seed) \e[35mreturn\e[0m \e[33mnull\e[0m;\n'
printf '  \e[35mconst\e[0m tone = \e[36mmix\e[0m(seed, \e[33m0.42\e[0m);\n'
printf '  \e[35mreturn\e[0m { accent: tone, \e[2m// follows the wallpaper\e[0m\n'
printf '           surface: \e[32m"#%s"\e[0m };\n}\n\n' "0c0e12"
printf '\e[1m  PID  NAME         CPU   MEM\e[0m\n'
printf '  412  \e[34mnode\e[0m        \e[33m12.4%%\e[0m  210M\n'
printf '  977  \e[34mcargo\e[0m       \e[31m88.1%%\e[0m  1.2G\n'
printf ' 1203  \e[34mnvim\e[0m         \e[32m0.6%%\e[0m   64M\n'
exec sleep infinity
