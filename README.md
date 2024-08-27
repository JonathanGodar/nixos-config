# To connect to eduroam:

Download installer script.
Run

```bash
nix-shell -p 'python3.withPackages (ps: [ ps.dbus-python ])'
python3 <eduroam_install_script.py>
```
