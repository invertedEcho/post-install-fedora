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
