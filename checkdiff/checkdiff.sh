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


# Copy new file to current
rm -rf compress-new
cp ../skadoosh/compress.bash ./compress-new

# Cat both files
cat compress-new | grep = >> newstuff.txt
cat compress-old | grep = >> oldstuff.txt

# Take the diff to a text file
diff newstuff.txt oldstuff.txt >> diffofstuff.txt

# Clean up and copy the *new* file!
rm -rf compress-old
cp ../skadoosh/compress.bash ./compress-old
rm -rf compress-new
rm -rf newstuff.txt
rm -rf oldstuff.txt

# Conditional shiz
if [ -s diffofstuff.txt ]; then
        echo "I find a difference"
        echo "Lets do the stuff!"
        # Removing the diff file
        rm -rf diffofstuff.txt
        
        # Start the madness
        cd ../skadoosh
        /bin/bash compress.bash
else
        echo "There is no difference"
        echo "Not doing stuff"
        
        # Removing the diff file
        rm -rf diffofstuff.txt
        exit 0
fi
