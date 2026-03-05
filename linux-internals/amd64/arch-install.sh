#!/bin/bash

# =============================================
# MINIMAL ARCH LINUX INSTALL SCRIPT
# Covers partitioning (if needed), mounting,
# chroot, kernel installation, basic setup,
# and login manager activation.
# =============================================

# Configuration variables - EDIT THESE FIRST!
TARGET_PARTITION="/dev/sdX1"  # Replace with your actual partition (e.g., /dev/nvme0n1p2)
ROOT_MOUNT="/mnt"
INITRAMFS_MOUNT="/initramfs_mount"
KERNEL_VERSION="linux"        # Options: linux, linux-lts, linux-zen, etc.
LOGIN_MANAGER="ly"            # Options: gdm, sddm, lightdm, ly
USERNAME="archuser"           # Default username
HOSTNAME="myarchbox"          # Hostname

# =============================================
# PARTITIONING (Uncomment if you need to create partitions)
# WARNING: This will erase data on the disk!
# =============================================
# echo "Creating partitions..."
# parted -s $TARGET_PARTITION mklabel gpt
# parted -s $TARGET_PARTITION mkpart primary 1M 100%
# parted -s $TARGET_PARTITION set 1 boot on
# parted -s $TARGET_PARTITION set 1 esp on
# echo "Partition created. Replace TARGET_PARTITION with your actual partition."

# =============================================
# MOUNTING FILESYSTEMS
echo "[*] Mounting filesystems..."

# Create mount points if they don't exist
mkdir -p $ROOT_MOUNT $INITRAMFS_MOUNT

# Mount EFI System Partition (ESP) for bootloader
mount --types vfat /dev/sdX1boot $ROOT_MOUNT/efi  # Replace sdX1 with your ESP partition

# Create and mount root filesystem
mkfs.ext4 $TARGET_PARTITION && \
mount $TARGET_PARTITION $ROOT_MOUNT

# Mount initramfs temporarily for kernel installation
mkdir -p $INITRAMFS_MOUNT
mount --bind /dev $ROOT_MOUNT/dev
mount --bind /proc $ROOT_MOUNT/proc
mount --bind /sys $ROOT_MOUNT/sys

echo "[*] Filesystems mounted successfully."

# =============================================
# CHROOT ENVIRONMENT
echo "[*] Entering chroot environment..."

chroot $ROOT_MOUNT /bin/bash << 'EOF'
#!/bin/bash

# Update package database
echo "[*] Updating package database..."
pacman -Syu --noconfirm

# Install minimal essential packages
echo "[*] Installing basic utilities..."
pacman -S --needed base base-devel linux $KERNEL_VERSION linux-firmware networkmanager vim sudo systemd

# Set hostname
echo "$HOSTNAME" > /etc/hostname

# Configure locale (critical for proper system behavior)
localectl set-locale LANG=en_US.UTF-8

# Generate SSH keys (optional but recommended)
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -a -f ~/.ssh/id_ed25519

# Set root password
passwd

# Create user account
useradd -m $USERNAME
echo "$USERNAME" | chpasswd

# Configure /etc/hosts
echo "127.0.1.1 $HOSTNAME localhost.localdomain localhost" >> /etc/hosts

# Install and configure login manager
echo "[*] Installing and configuring $LOGIN_MANAGER..."
pacman -S $LOGIN_MANAGER
systemctl enable --now $LOGIN_MANAGER

# Enable networking
systemctl enable NetworkManager

# Configure basic services (optional)
systemctl enable --now sshd

# Set up sudo rules
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/wheel

# Cleanup (remove initramfs mount point)
rm -rf $INITRAMFS_MOUNT

echo "[*] Minimal Arch Linux installation complete!"
echo "You can now reboot with:"
echo "systemctl reboot"
EOF

# =============================================
# REBOOT INSTRUCTIONS
echo ""
echo "========================================="
echo "SCRIPT COMPLETE! Here's what you need to do:"
echo ""
echo "1. Reboot your system:"
echo "   sudo reboot"
echo ""
echo "2. After reboot, you'll be prompted for:"
echo "   - Root password (set during installation)"
echo "   - Username password ($USERNAME)"
echo ""
echo "3. First boot notes:"
echo "   - You may need to configure $LOGIN_MANAGER manually."
echo "   - Enable NetworkManager if needed."
echo ""
echo "4. Optional: Install a window manager or desktop environment."
echo "   Example: pacman -S xfce4"
echo ""
echo "========================================="
