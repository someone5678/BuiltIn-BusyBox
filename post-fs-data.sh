#!/system/bin/sh

# Magisk Module: Magisk built-in BusyBox v1.0.6
# Copyright (c) zgfg @ xda, 2022-
# GitHub source: https://github.com/zgfg/BuiltIn-BusyBox

# Module's own path (local path)
MODDIR=${0%/*}

# Clean-up old stuff
rm -rf "$MODDIR/system"

# Choose XBIN or BIN path
SDIR=/system/xbin
if [ ! -d $SDIR ]
then
  SDIR=/system/bin
fi
BBDIR=$MODDIR$SDIR
mkdir -p $BBDIR
chmod 751 $BBDIR
chown -R :shell $BBDIR
cd $BBDIR
pwd

# ToyBox-Ext path
TBDIR="/data/adb/modules/ToyBox-Ext/$SDIR"
								   
# KernelSU built-in BusyBox
BB=busybox
BBBIN=/data/adb/ksu/bin/$BB

# List BusyBox applets
$BBBIN --list | wc -l
Applets="$BB"$'\n'"$($BBBIN --list)"

# Create local symlinks for BusyBox applets
for Applet in $Applets
do
  Target=$SDIR/$Applet
  if [ ! -x $Target ]
  then
    # Create symlink
    ln -s $BBBIN $Applet

    # Remove local symlink for ToyBox applet (prefer BusyBox)
    Target=$TBDIR/$Applet
    if [ -h $Target ]
    then
      rm -f $Target
    fi
  fi
done
ln -s $BBBIN $BB
