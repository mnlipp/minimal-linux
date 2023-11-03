#!/bin/sh

# Create the new mountpoint in RAM.
mount -t tmpfs none /mnt

# Create folders for all critical file systems.
mkdir /mnt/dev
mkdir /mnt/sys
mkdir /mnt/proc
mkdir /mnt/tmp
echo "Created folders for all critical file systems."

# Copy root folders in the new mountpoint.
echo -e "Copying the root file system to \\e[94m/mnt\\e[0m."
for dir in */ ; do
  case $dir in
    dev/)
      # skip
      ;;
    proc/)
      # skip
      ;;
    sys/)
      # skip
      ;;
    mnt/)
      # skip
      ;;
    tmp/)
      # skip
      ;;
    *)
      cp -a $dir /mnt
      ;;
  esac
done

# Move critical file systems to the new mountpoint.
mount --move /dev /mnt/dev
mount --move /sys /mnt/sys
mount --move /proc /mnt/proc
mount --move /tmp /mnt/tmp
echo -e "Mount locations \\e[94m/dev\\e[0m, \\e[94m/sys\\e[0m, \\e[94m/tmp\\e[0m and \\e[94m/proc\\e[0m have been moved to \\e[94m/mnt\\e[0m."

# The new mountpoint becomes file system root. All original root folders are
# deleted automatically as part of the command execution. The '/sbin/init'
# process is invoked and it becomes the new PID 1 parent process.
echo "Switching from initramfs root area to overlayfs root area."
exec switch_root /mnt /usr/bin/setsid /bin/cttyhack /bin/sh
#exec switch_root /mnt /bin/sh

echo "(/etc/02_overlay.sh) - there is a serious bug."

# Wait until any key has been pressed.
read -n1 -s
