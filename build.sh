#!/bin/sh

set -e

echo "making variable font"

fontmake -g ./Jura.glyphs -o variable --output-path ./fonts/Jura-VF.ttf

echo "VF built"

echo "Removing Build UFOS"

rm -rf master_ufo/ instance_ufo/

echo "Build UFOS Removed"

echo "fix nonhinting script"
### add the fixes that we know are necessary from initial fontbakery run
gftools fix-nonhinting ./fonts/Jura-VF.ttf ./fonts/Jura-VF.fix.ttf
rm -rf ./fonts/Jura-VF-backup-fonttools-prep-gasp.ttf
rm -rf ./fonts/Jura-VF.ttf
mv ./fonts/variable/Quicksand-VF.ttf.fix ./fonts/variable/Quicksand-VF.ttf
echo "fix nonhinting script complete"


echo "fix DSIG script Running"
gftools fix-dsig --autofix ./fonts/Jura-VF.ttf
echo "fix DSIG script Complete"

