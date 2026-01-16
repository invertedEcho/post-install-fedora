# post-install-linux

## Setup

Depending on whether installing debian or fedora, run either
- ./post-install-debian.sh
- ./post-install-fedora.sh

## misc

- Don't require username, only password on tty1 login:

`/etc/systemd/system/getty@tty1.service.d/skip-username.conf`
```
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -- invertedecho' --noclear --skip-login - $TERM
```
`sudo systemctl enable getty@tty1`

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
    //jakobs-homeserver.local/Share /mnt/smbshare cifs credentials=/etc/samba/credentials,iocharset=utf8,uid=1000,gid=1000,file_mode=0664,dir_mode=0775 0 0
    ```

- proper permission on ntfs mount:
  - add to /etc/fstab
    ```
    UUID=<UUID>  <mnt-path>  ntfs-3g  uid=1000,gid=1000,umask=022,windows_names  0  0
    ```
