#!/bin/sh

set -e

echo "making variable font"

fontmake -g ./sources/Jura.glyphs -o variable --output-path ./fonts/Jura-VF.ttf

echo "VF built"

echo "Removing Build UFOS"

rm -rf master_ufo/ instance_ufo/

echo "Build UFOS Removed"

echo "fix nonhinting script"
### add the fixes that we know are necessary from initial fontbakery run
gftools fix-nonhinting ./fonts/Jura-VF.ttf ./fonts/Jura-VF.fix.ttf
rm -rf ./fonts/Jura-VF-backup-fonttools-prep-gasp.ttf
rm -rf ./fonts/Jura-VF.ttf
mv ./fonts/Jura-VF.fix.ttf ./fonts/Jura-VF.ttf
echo "fix nonhinting script complete"


echo "fix DSIG script Running"
gftools fix-dsig --autofix ./fonts/Jura-VF.ttf
echo "fix DSIG script Complete"


echo "OS/2 table patch begin"
# copies the 'OS/2' table patch into the variable outputs folder
cp ./patch/Jura-VF.ttx ./fonts/Jura-VF.ttx
#walkin' down to the variable level
cd fonts/
#mergin' in my patched os2 
ttx -m Jura-VF.ttf Jura-VF.ttx
#Deletin' that nasty wrong file
rm -rf Jura-VF.ttf
rm -rf Jura-VF.ttx
#rename that new guy the gorrect name
mv Jura-VF#1.ttf Jura-VF.ttf