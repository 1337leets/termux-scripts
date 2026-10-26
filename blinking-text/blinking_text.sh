#!/bin/bash
# blinking_text.sh - blink a line of red text in the terminal until Ctrl+C
text="BLINKING TEXT"
echo -ne "\e[?25l"  # hide the cursor

trap "echo -ne '\e[?25h\n'; exit" SIGINT  # show the cursor again on Ctrl+C

while true; do
  # show the text
  echo -ne "\e[1;31m$text\r"
  sleep 0.4

  # erase it by printing spaces over the same line
  echo -ne "               \r"
  sleep 0.4
done
