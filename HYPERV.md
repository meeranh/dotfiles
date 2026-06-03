# HyperV setup — seamless Arch desktop via Enhanced Session

This branch (`hyperv`) runs Arch in a Hyper-V VM on a Windows host and exposes a
seamless desktop through **Enhanced Session Mode**: open the VM in Hyper-V
Manager and you get an integrated window with **audio, clipboard, and dynamic
resolution** over VMBus — no IP addresses, no separate RDP client.

It works by running **xrdp over the VMBus `vsock` transport**, serving an **i3
(X11)** session. xrdp renders i3 to its own X server, so there is **no GPU/dmabuf
dependency** (a Wayland/Sway RDP server can't capture video on a GPU-less Hyper-V
VM — that path is a dead end; don't retry it).

`install.sh` does all of the below automatically. This file is the manual fallback.

---

## 1. Guest packages (Arch VM)

```bash
# base desktop is already in install.sh (i3-wm, xorg-server, xorg-xinit, ly,
# pipewire, wireplumber, pipewire-pulse, ...). The Enhanced-Session extras:
paru -S xrdp xorgxrdp pipewire-module-xrdp
```
`xorgxrdp` is essential — without it you get **"X server could not be started"**.

## 2. xrdp over vsock

Edit `/etc/xrdp/xrdp.ini`: in the **`[Globals]`** section only, set
```
port=vsock://-1:3389
security_layer=rdp
crypt_level=none
bitmap_compression=false
```
Leave every other `port=` line (under `[Xorg]`, `[Xvnc]`, …) as **`-1`**.
Safe one-liner that only touches `[Globals]`:
```bash
sudo awk -i inplace '/^\[/{s=$0} s=="[Globals]"&&/^port=/{print "port=vsock://-1:3389";next}{print}' /etc/xrdp/xrdp.ini
sudo sed -i -e 's|^security_layer=.*|security_layer=rdp|' \
            -e 's|^crypt_level=.*|crypt_level=none|' \
            -e 's|^bitmap_compression=.*|bitmap_compression=false|' /etc/xrdp/xrdp.ini
```

## 3. Launch i3 as the session

```bash
sudo tee /etc/xrdp/startwm.sh >/dev/null <<'EOF'
#!/bin/sh
[ -r /etc/profile ] && . /etc/profile
[ -r ~/.profile ] && . ~/.profile
exec i3
EOF
sudo chmod +x /etc/xrdp/startwm.sh
```

## 4. Let Xorg start outside a console seat

```bash
printf 'allowed_users=anybody\nneeds_root_rights=yes\n' | sudo tee /etc/X11/Xwrapper.config
```

## 5. hv_sock module + enable xrdp

```bash
echo hv_sock | sudo tee /etc/modules-load.d/hv_sock.conf
sudo systemctl enable --now xrdp
sudo ss -l -A vsock          # verify: should show  v_str LISTEN *:3389
```

## 6. Audio

`pipewire-module-xrdp` redirects sound over RDP, but it loads via XDG autostart
which i3 doesn't run — so the i3 config triggers it explicitly:
```
# (already in ~/.config/i3/config)
exec --no-startup-id sh -c 'sleep 3; /usr/lib/pipewire-module-xrdp/load_pw_modules.sh'
```
The script self-guards (no-op outside an xrdp session). On first connect, if audio
is silent, in an xrdp-session terminal:
```bash
/usr/lib/pipewire-module-xrdp/load_pw_modules.sh
pactl set-default-sink xrdp-sink
```

## 7. i3 config notes (this VM)

In `~/.config/i3/config` the laptop-only bits are disabled for the VM:
- the `xrandr --output eDP-1 ...` line (no physical output; RDP sets resolution)
- `picom` (no GLX under xrdp; xrdp owns the framebuffer)

---

## Host side (Windows, elevated PowerShell) — ONE TIME

```powershell
Set-VMHost -EnableEnhancedSessionMode $true            # host-level toggle
Set-VM "<VMName>" -EnhancedSessionTransportType HvSocket
Get-VM "<VMName>" | Format-List EnhancedSessionTransportType, Version
# transport is established at boot — power-cycle the VM:
Stop-VM "<VMName>"; Start-VM "<VMName>"
```

## Connect

Hyper-V Manager → Connect to the VM → click the **Enhanced Session** toolbar
button → pick a resolution → log in as your user → i3 with sound.

---

## Troubleshooting (issues we actually hit)

| Symptom | Cause / fix |
|---|---|
| **Enhanced Session button greyed out** | Host ESM off (`Set-VMHost -EnableEnhancedSessionMode $true`), transport not `HvSocket`, or VM not power-cycled after setting it. |
| **"X server could not be started"** | `xorgxrdp` not installed, or missing `/etc/X11/Xwrapper.config`. |
| **Login rejected** | xrdp ships its own `/etc/pam.d/xrdp`, so system password works; check `journalctl -u xrdp-sesman`. |
| **No `vsock` listener** | `port=` in `[Globals]` not set to `vsock://-1:3389`, or backend `port=` lines got overwritten (must stay `-1`); restart `xrdp`. |
| **No sound** | Run the load script **inside the xrdp session** (env `XRDP_SOCKET_PATH` only exists there); `pactl set-default-sink xrdp-sink`. Don't be logged into the console session at the same time (shared PipeWire). |
