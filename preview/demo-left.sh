#!/usr/bin/env bash
clear
printf '\e[1mdank16 palette\e[0m  (from the wallpaper via DMS)\n\n'
for i in 0 1 2 3 4 5 6 7; do printf '\e[48;5;%dm      \e[0m' $i; done; echo
for i in 8 9 10 11 12 13 14 15; do printf '\e[48;5;%dm      \e[0m' $i; done; echo; echo
for i in 1 2 3 4 5 6 7; do printf '\e[3%dm■ color%d\e[0m  ' $i $i; done; echo
for i in 1 2 3 4 5 6 7; do printf '\e[9%dm■ color%d\e[0m ' $i $((i+8)); done; echo; echo
printf '\e[34m~/projects/app\e[0m on \e[35m main\e[0m \e[33m!2\e[0m\n'
printf '\e[32m❯\e[0m git diff --stat\n'
printf ' src/theme.ts  | 14 \e[32m++++++++++\e[31m----\e[0m\n'
printf ' README.md     |  3 \e[32m+++\e[0m\n'
printf '\n\e[32m❯\e[0m cargo test\n'
printf '\e[32m   Compiling\e[0m app v0.3.1\n\e[32m    Finished\e[0m test profile in 2.31s\n'
printf 'test palette::loads ... \e[32mok\e[0m\ntest palette::contrast ... \e[32mok\e[0m\ntest theme::reload ... \e[31mFAILED\e[0m\n'
printf '\e[33mwarning\e[0m: unused variable `seed`\n'
printf '\n\e[32m❯\e[0m '
exec sleep infinity
