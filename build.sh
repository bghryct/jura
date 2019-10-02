#!/bin/sh

set -e

mkdir fonts/variable/

echo "making variable font"
fontmake -g ./sources/Jura.glyphs -o variable --output-path ./fonts/variable/Jura\[wght\].ttf
echo "VF built"

mkdir fonts/ttf/
echo "making statics"
fontmake -g sources/Jura.glyphs -i -o ttf --output-dir ./fonts/ttf/ 
echo "Made Roman ttfs"



echo "Removing Build UFOS"

rm -rf master_ufo/ instance_ufo/

echo "Build UFOS Removed"

echo "fix nonhinting script"
### add the fixes that we know are necessary from initial fontbakery run
gftools fix-nonhinting ./fonts/variable/Jura\[wght\].ttf ./fonts/variable/Jura\[wght\].fix.ttf
rm -rf ./fonts/variable/Jura\[wght\]-backup-fonttools-prep-gasp.ttf
rm -rf ./fonts/variable/Jura\[wght\].ttf
mv ./fonts/variable/Jura\[wght\].fix.ttf ./fonts/variable/Jura\[wght\].ttf
echo "fix nonhinting script complete"


echo "fix DSIG script Running"
gftools fix-dsig --autofix ./fonts/Jura-VF.ttf
echo "fix DSIG script Complete"


vfs=$(ls ./fonts/variable/*.ttf)
for vf in $vfs
do
        gftools fix-dsig -f $vf;
        gftools fix-nonhinting $vf "$vf.fix";
        mv "$vf.fix" $vf;
        ttx -f -x "MVAR" $vf; # Drop MVAR. Table has issue in DW
        rtrip=$(basename -s .ttf $vf)
        new_file=./fonts/variable/$rtrip.ttx;
        rm $vf;
        ttx $new_file
        rm ./fonts/variable/*.ttx
done
rm ./fonts/variable/*backup*.ttf

# echo "OS/2 table patch begin"
# # copies the 'OS/2' table patch into the variable outputs folder
# cp ./patch/Jura-VF.ttx ./fonts/Jura-VF.ttx
# #walkin' down to the variable level
# cd fonts/
# #mergin' in my patched os2 
# ttx -m Jura-VF.ttf Jura-VF.ttx
# #Deletin' that nasty wrong file
# rm -rf Jura-VF.ttf
# rm -rf Jura-VF.ttx
# #rename that new guy the gorrect name
# mv Jura-VF#1.ttf Jura-VF.ttf

# cd ..

echo "Post processing statics"

ttfs=$(ls ./fonts/ttf/*.ttf)
echo $ttfs
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
	gftools fix-nonhinting $ttf "$ttf.fix";
	mv "$ttf.fix" $ttf;
done
echo "fixed nonhinting ttfs as well as DSIG"

rm ./fonts/ttf/*backup*.ttf
