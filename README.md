# Jonathans nixos configurations

## Eduroam

Needs dbus-python, which can be given by:

```

nix-shell -p 'python3.withPackages (ps: [ ps.dbus-python ])'
```

Then run the python scripts with python3. Then use nmtui to connect to the wifi and enter username and password. You may also need to configure the settings of the network in nm tui as described on [the kth website](https://www.kth.se/student/it/work-online/wifi-pa-kth/eduroam-pa-kth-1.1349435)

If the password is forgotten for each reboot, use the nmtui to set the password (edit connections) and select available for all users.

## Raspberry Pi

To build the raspberry PI image use:

```bash
nix build .#images.rpi4
```

This will generate a 'result' in CWD. Follow the symlink and some directories down you will find a nixos.\*\*\*.img. Flash this to your SD-card using:

```bash
sudo dd bs=4M if=<SD_IMAGE> of=<SD-card DEVICE LOCATION> status=progress oflag=sync
```

Quirks:

- The ssh key is for some reason not added. I manually added it by mounting the sd card block device going into the filesystem, and adding the file my public key in ~/.ssh/authorized_keys (i also had to create .ssh and authorized_keys since they did not exist). Stupidly enough I did not want to set a password so I was not able to access sudo. This was solved by once again mouting the SD-card, and adding an entry to the /etc/shadow file. I took the entry that I added from my running linux instance. In heindseight i should have set as password in the flake and then changed it using passwd. Oh well.

### Remote deployment

To update the raspberry pi with packages being build on a remote machine use

```bash
nixos-rebuild switch --flake .#rpi4 --target-host <user>@<raspberry pi host> --use-remote-sudo
```
