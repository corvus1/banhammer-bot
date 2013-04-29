#!/bin/sh

echo 'print execl("./bot.sh","./bot.sh",0)' | gdb -p $(cat bot.pid)
