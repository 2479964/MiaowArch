# 🐈‍⬛ MiaowArch — CAT OS (Hyprland · Chaotic Build)

> *Dark, cozy base. Subtle animations. Random annoying-but-rare behaviors. Feels alive, not broken.*
>
> **You're in control… most of the time.**

---

## ✨ Features

| Area | Details |
|---|---|
| **WM** | [Hyprland](https://hyprland.org/) — smooth cat-like animations, blur, rounded corners |
| **Bar** | Waybar — small, rounded, semi-transparent chill HUD |
| **Terminal** | Kitty — cat-orange cursor, cozy dark palette |
| **Notifications** | dunst — rounded, semi-transparent, cat-orange accents |
| **Idle / Lock** | hypridle + hyprlock — "cat sleep mode" with auto-dim and lock |
| **Chaos** | Four background scripts that make the system feel *alive* |

### 🎨 Colour Palette

| Role | Hex | Preview |
|---|---|---|
| Background | `#0f0f0f` | ██ deep black |
| Surface | `#1a1a1a` | ██ dark grey |
| Accent | `#ffb347` | ██ cat orange |
| Text | `#e6e6e6` | ██ soft white |

---

## 📦 Prerequisites

```
hyprland  waybar  kitty  wofi  swww  dunst  btop  playerctl
ttf-jetbrains-mono  noto-fonts-emoji  brightnessctl  pipewire  wireplumber
# AUR
hypridle  hyprlock  hyprpaper  cava  grimblast-git
```

---

## 🚀 Install

```bash
git clone https://github.com/2479964/MiaowArch.git
cd MiaowArch
./install.sh            # guided install (packages + configs)
./install.sh --no-pkg   # deploy configs only
./install.sh --pkg-only # install packages only
./install.sh -y         # non-interactive mode
```

The install script symlinks every config file into `~/.config/` and makes
the catOS scripts executable.  Existing configs are backed up as `*.bak`.

---

## 🗂 Repository Layout

```
MiaowArch/
├── hypr/
│   ├── hyprland.conf      ← animations, borders, keybinds, autostart
│   ├── hypridle.conf      ← cat sleep mode (dim → lock → suspend)
│   └── hyprlock.conf      ← lock screen with clock + cat label
├── waybar/
│   ├── config.jsonc       ← modules: workspaces · clock · cpu · ram · audio · battery
│   └── style.css          ← dark cozy rounded semi-transparent bar
├── dunst/
│   └── dunstrc            ← rounded notifications with cat-orange frame
├── kitty/
│   └── kitty.conf         ← terminal — cat-orange cursor, dark palette
├── catOS/
│   ├── cat_thoughts.sh    ← random "meow" notifications every 5–15 min
│   ├── cat_walk.sh        ← switches workspace every 10–25 min
│   ├── cat_nudge.sh       ← tiny cursor nudge every 10–30 min
│   └── cat_interfere.sh   ← cryptic "something moved" message every 15–45 min
└── install.sh             ← one-shot setup script
```

---

## 🐾 catOS Chaos Scripts

All four scripts autostart via `exec-once` in `hyprland.conf`.

### cat_thoughts.sh
Random cat messages via `notify-send` every **5–15 minutes**.
Messages include: `"meow"`, `"no."`, `"feed me"`, `"i closed that btw"`, …

### cat_walk.sh
Switches to a random workspace (1–5) every **10–25 minutes** — as if a cat
walked across the keyboard.  A subtle notification tells you what happened.

### cat_nudge.sh
Moves the cursor by ±2 pixels every **10–30 minutes**.  Barely noticeable.
That's the point.

### cat_interfere.sh
Fires a cryptic notification (`"something moved"`, `"that wasn't me"`, …)
every **15–45 minutes**.

> **Balance**: rare = funny · frequent = uninstall

---

## ⌨️ Key Bindings (defaults)

| Keys | Action |
|---|---|
| `Super + Return` | Open Kitty terminal |
| `Super + D` | Application launcher (wofi) |
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + V` | Toggle floating |
| `Super + H/J/K/L` | Move focus (vim-style) |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + Ctrl + H/J/K/L` | Resize window |
| `Super + 1–9` | Switch workspace |
| `Super + Shift + 1–9` | Move window to workspace |
| `Super + W` | Random wallpaper from `~/.config/wallpapers/` |
| `Super + L` | Lock screen (hyprlock) |
| `Super + Shift + E` | Session menu (wlogout) |
| `Print` | Screenshot area (grimblast) |

---

## 🖼 Wallpapers

Drop images into `~/.config/wallpapers/`.  
`Super + W` picks one at random via `swww`.

---

## 🔥 Upgrade Ideas

- [ ] Animated cat overlay on idle (wired to hypridle)
- [ ] `cat --pet` fake command (shell alias / script)
- [ ] Rare meow sound: `paplay ~/.config/catOS/meow.wav`
- [ ] cava visualiser in a corner kitty window
