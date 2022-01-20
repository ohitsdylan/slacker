#/bin/bash

# slacker.sh
# downloads and builds files from slackbuilds.org
# by ohitsdylan

# Get SlackBuild URL and storage directory.
read -p 'SlackBuild URL: ' SBURL
read -p 'Full path to storage directory (i.e. /home/user/directory): ' SBDIR
read -p 'Project directory (i.e. bar-1.1): ' PRDIR

# Create storage directory and use URL to get files.
mkdir $SBDIR/$PRDIR
cd $SBDIR/$PRDIR
FNAME=$(basename "$SBURL")
wget $SBURL

# Collect version number
VNUM=$(cat $FNAME.info | cut -f 2 -d '"' | sed -n '2 p')

# Use tar to decompress files and drop into directory.
tar -xzf $FNAME
FNAME=$(echo $FNAME | cut -f 1 -d '.')
cd $FNAME

# Grab the source file from the .info file and wget it.
SBURL=$(awk -F 'DOWNLOAD' '{print $2}' $FNAME.info | cut -f 2 -d '"' | tr -d '\n')
wget $SBURL

# Grant execute rights to the .SlackBuild file and execute.
chmod +x $FNAME.SlackBuild
./$FNAME.SlackBuild

# Run installpkg and move file into project directory
installpkg /tmp/$FNAME-$VNUM-x86_64-1_SBo.tgz
mv /tmp/$FNAME-$VNUM-x86_64-1_SBo.tgz .
