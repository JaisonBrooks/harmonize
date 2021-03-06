#!/bin/bash
# Harmonize
# Init script for Harmonize.rb
# Author: Jaison Brooks
# Dec 2015
SCRIPTDIR=`dirname $0`
L="[Harmonize] "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo  "$L Updating [ harmonize.rb ] Permissions" | sed $'s/harmonize.rb/\e[36m&\e[0m/' 
chmod 755 "$SCRIPTDIR/harmonize.rb"
sleep 0.3
echo "$L Moving [ harmonize.rb ] to /usr/local/bin" | sed $'s/harmonize.rb/\e[36m&\e[0m/' 
sleep 0.3
cp -r "$SCRIPTDIR/harmonize.rb" /usr/local/bin/harmonize
echo "$L Execute \`harmonize -h\` to get started" | sed $'s/harmonize -h/\e[34m&\e[0m/' 
sleep 0.3
echo "$L Have Fun Harmonizing your digital life!" | sed $'s/Harmonizing/\e[35m&\e[0m/'
sleep 0.3
# echo "$L"
echo "$L Created By: Jaison Brooks" | sed $'s/Jaison Brooks/\e[31m&\e[0m/'
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
# Might switch to sym link ln -s $PWD/harmonize /usr/local/bin
