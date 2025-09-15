# post-install-fedora

## Setup

After installing fedora, run the script to install all needed software

```bash
./install.sh
```

## misc

- Setting up gdm display configuration
  - Change display settings in gnome-settings
  - Copy over monitors.xml into gdm config directory:
    ```
    sudo cp /home/user/.config/monitors.xml /var/lib/gdm/.config/
    ```

- auto mount smb share
  - create credentials file
    ```bash
    sudo vim /etc/samba/credentials
    # Content:
    username=username
    password=password
    ```
  - add to `/etc/fstab`
    ```bash
    //jakobs-raspberrypi.local/Share /mnt/smbshare cifs credentials=/etc/samba/credentials,iocharset=utf8,uid=1000,gid=1000,file_mode=0664,dir_mode=0775 0 0
    ```
