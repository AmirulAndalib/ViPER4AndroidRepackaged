#!/bin/bash

set -e -u

[[ `git status --porcelain` ]] && CHANGES="+" || CHANGES="-"
VERSIONCODE=$(git rev-list --count HEAD)
REPACKAGEDSTRING="repackagedhoch$VERSIONCODE"
COMMITHASH=$(git log -1 --pretty=%h)
VERSION=v$VERSIONCODE$CHANGES\($COMMITHASH\)

cp -f module.prop magiskmodule/module.prop
sed -i "s/VERSION/$VERSION/g" magiskmodule/module.prop
sed -i "s/VCODE/$VERSIONCODE/g" magiskmodule/module.prop
sed -i "s/REPACKAGEDSTRING/$REPACKAGEDSTRING/g" magiskmodule/module.prop

OUTPUT_FILE="ViPER4AndroidFX-$REPACKAGEDSTRING$CHANGES$COMMITHASH.zip"
rm ViPER4AndroidFX-repackaged* 2>/dev/null || true

echo "Compressing Viper IRS files..."
cd ViperIRS
[ -f "../magiskmodule/ViperIRS.zip" ] && rm "../magiskmodule/ViperIRS.zip"
zip -9 -q "../magiskmodule/ViperIRS.zip" *.irs
cd ..

echo "Compressing Original VDC files..."
cd OriginalVDCs
[ -f "../magiskmodule/vdcs.zip" ] && rm "../magiskmodule/vdcs.zip"
zip -9 -q "../magiskmodule/vdcs.zip" *.vdc
cd ..

echo "Compressing Magisk Module..."
cd magiskmodule
zip -r -9 -q "../$OUTPUT_FILE" .
cd ..

echo "Done"
