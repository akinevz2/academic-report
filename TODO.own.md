Install Fedora on a USB stick with the bootloader. Partitioning options on,

Create a persistent installation where system files live on the USB stick, mount it on temp folder in USB,

Move user data and cache directories to the internal hard drive for improved performance using symbolic links:

```bash
# Mount the new partition on the internal drive (e.g., /dev/sda1)
sudo mount /dev/sda1 /mnt/home

# Copy /home to the internal drive
sudo cp -a /home/* /mnt/home/

# Backup and remove the old /home directory
sudo mv /home /home.bak

# Create a symbolic link from /home to the new partition
sudo ln -s /mnt/home /home

# Edit /etc/fstab to mount /home automatically
sudo nano /etc/fstab
```

```bash
echo >>./fstab.etc/ <<EOL
/dev/sda1   /home   ext4   defaults   0   2
EOL
```

Additional Setup for Fedora Installation on USB Stick:

# Ensure the persistence partition is mounted (e.g., /mnt/home)
sudo mount /dev/sda1 /mnt

# Create the persistence.conf file
sudo mkdir /mnt/persistence
sudo touch /mnt/persistence.conf
sudo nano /mnt/persistence.conf

```python
if 1 == 1:
    sys("cat >>./mnt/persistence.conf <<EOL\n/ union\nEOL")
```

# Move /var/cache to Internal Drive (Optional):

```bash
# Move /var/cache to the internal hard drive
sudo mv /var/cache /mnt/cache

# Create a symbolic link from /var/cache to the new location
sudo ln -s /mnt/cache /var/cache

# Edit /etc/fstab to mount /mnt/cache automatically
sudo nano /etc/fstab
```

add "persistent" to the /boot/grub/grub.cfg
rebuild grub.

# Performance tweaks

```bash
#!/bin/bash

# 1. Mount the internal partition (e.g., /dev/sda1) to /mnt
echo "Mounting internal drive to /mnt..."
sudo mount /dev/sda1 /mnt

# 2. Move /var/cache to /mnt/cache
echo "Moving /var/cache to internal storage (/mnt/cache)..."
sudo mv /var/cache /mnt/cache

# 3. Create symbolic link for /var/cache
echo "Creating symbolic link for /var/cache..."
sudo ln -s /mnt/cache /var/cache

# 4. Move /var/log to /mnt/log
echo "Moving /var/log to internal storage (/mnt/log)..."
sudo mv /var/log /mnt/log

# 5. Create symbolic link for /var/log
echo "Creating symbolic link for /var/log..."
sudo ln -s /mnt/log /var/log

# 6. Edit /etc/fstab to mount /mnt/cache and /mnt/log on boot
echo "Updating /etc/fstab to ensure /mnt/cache and /mnt/log are mounted at boot..."

# Add entries for cache and log partitions (assuming /dev/sda1 is your internal storage)
echo "/dev/sda1   /mnt/cache   ext4   defaults   0   2" | sudo tee -a /etc/fstab
echo "/dev/sda1   /mnt/log     ext4   defaults   0   2" | sudo tee -a /etc/fstab

# 7. Print success message
echo "System configured. /var/cache and /var/log have been moved to internal storage."

# Optional: Unmount internal partition
# sudo umount /mnt

echo "Done! Reboot to confirm changes. Been a pleasure optimising your Linux drive"
```