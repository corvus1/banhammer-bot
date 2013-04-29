#!/bin/sh
 
CHAN="#gentoo-chat-ru"
MYNICK="brave-org"
SLEEPFOR=300
 
echo "NICK $MYNICK"
echo "USER $MYNICK $MYNICK $MYNICK $MYNICK"
sleep 3
echo "NICKSERV IDENTIFY login password"
sleep 10
echo "JOIN :$CHAN"
 
while read line; do
echo "$line" >> bot.log
echo "$line" | sed -ne 's/PING/PONG/p'
if echo "$line" | awk '{print $2}' | grep -q "JOIN"; then
  NICK=$(echo "$line" | sed -ne 's/.*:\([^!]*\)!.*/\1/p')
  HOST=$(echo "$line" | sed -ne 's/.*@\([^ ]*\) .*/\1/p')
  HOSTSTDOUT=$(host "$HOST." 2>&1 | tee -a bot.log)
  if dig "$HOST" SOA | grep -q "afraid.org" && echo "$HOSTSTDOUT" | grep -q NXDOMAIN; then
    echo "MODE $CHAN +b :*!*@$HOST" | tee -a bot.log
    HITS=$((`grep $HOST bot.log -c`/2))
    (sleep "$((SLEEPFOR**HITS))"; echo "MODE $CHAN -b :*!*@$HOST" | tee -a bot.log) &
    echo "KICK $CHAN $NICK :afraid.org temporarily banned, sorry" | tee -a bot.log
  fi
fi
done
