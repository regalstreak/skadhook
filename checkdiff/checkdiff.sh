#!/bin/bash

#########################################
#
# Author - Neil "regalstreak" Agarwal
# 2016
#
# This file (checkdiff.sh) will check if there is a difference to the compress.bash after a pull triggered by the webhook.
# If there is a difference, it will trigger the build.
# If not, will safely exit.
# To be used with the Skadoosh project and Caddy webserver with git automation.
# https://github.com/regalstreak/skadoosh
#
#########################################

### Variable [Change this]
# Skadhook clone directory
SKADHOOK=/home/regalstreak2/android/skadhook

# Statics [Do not change this]
SKADOOSH=$SKADHOOK/skadoosh
DIFF=$SKADHOOK/checkdiff

# Check if we don't want to trigger a build
if [ grep "DONTBUILD" "$SKADOOSH/compress.bash" ] || [ grep "DONTBUILD" "$SKADOOSH/skadoo.sh" ]; then
  exit 1
fi

# Copy new file to current
rm -rf $DIFF/compress-new
cp $SKADOOSH/compress.bash $DIFF/compress-new

# Cat both files
cat $DIFF/compress-new | grep = >> $DIFF/newstuff.txt
cat $DIFF/compress-old | grep = >> $DIFF/oldstuff.txt

# Take the diff to a text file
diff $DIFF/newstuff.txt $DIFF/oldstuff.txt >> $DIFF/diffofstuff.txt

# Clean up and copy the *new* file!
cleanstuff(){
        rm -rf $DIFF/compress-old
        cp $SKADOOSH/compress.bash $DIFF/compress-old
        rm -rf $DIFF/compress-new
        rm -rf $DIFF/newstuff.txt
        rm -rf $DIFF/oldstuff.txt
}

cleanstuff

# Conditional shiz
if [ -s $DIFF/diffofstuff.txt ]; then
        echo "I find a difference"
        echo "Lets do the stuff!"
        # Removing the diff file
        rm -rf $DIFF/diffofstuff.txt
        
        # Start the madness
        /bin/bash $SKADOOSH/compress.bash | tee $SKADHOOK/logs/checkdiff/checkdiff-$(date +%Y-%m-%d).log
else
        echo "There is no difference"
        echo "Not doing stuff"
        
        # Removing the diff file
        rm -rf $DIFF/diffofstuff.txt
        exit 0
fi
