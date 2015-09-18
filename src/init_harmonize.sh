#!/bin/bash

# Init script for Harmonize.rb

L=" [Harmonize]:"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo  "$L Updating [ harmonize.rb ] Permissions" | sed $'s/harmonize.rb/\e[36m&\e[0m/' 
chmod 755 harmonize.rb
sleep 0.4
echo "$L Moving to [ harmonize.rb ] to /usr/local/bin" | sed $'s/harmonize.rb/\e[36m&\e[0m/' 
sleep 0.4
cp -r harmonize.rb /usr/local/bin/harmonize
echo "$L Now you can use [ harmonize ] from anywhere in your file system :)" | sed $'s/harmonize/\e[36m&\e[0m/' 
sleep 0.4
echo "$L Execute \`harmonize -h\` to get started" | sed $'s/harmonize -h/\e[34m&\e[0m/' 
sleep 0.4
echo "$L Enjoy Harmonizing your digital life!" | sed $'s/Harmonizing/\e[31m&\e[0m/'
sleep 0.4
echo "$L"
echo "$L Author: Jaison Brooks" | sed $'s/Jaison Brooks/\e[35m&\e[0m/'
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

# Might switch to this ln -s $PWD/harmonize /usr/local/bin
