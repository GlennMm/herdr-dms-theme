#!/usr/bin/env python3
"""matugen post_hook: make Herdr's dms layout follow DMS's terminal opacity.

DMS Settings > Theme > Terminal > Opacity (10..100) drives:
  layouts/dms.json   terminal_opacity = pct/100, window_blur = pct < 100
  themes/dms*.json   colors.background fully transparent (lets the desktop
                     through), colors.canvas / colors.chrome at BAR_RATIO * pct
At 100 everything is opaque again.

Usage: herdr-opacity.py [percent]   (percent overrides DMS, for testing)
"""
import json, os, re, sys, tempfile

BAR_RATIO = 0.8          # bars/sidebar opacity relative to the terminals'
CONFIG = os.environ.get("XDG_CONFIG_HOME") or os.path.expanduser("~/.config")
HERDR = os.environ.get("HERDR_APP_HOME") or os.path.join(CONFIG, "herdr-app")
LAYOUT = os.path.join(HERDR, "layouts", "dms.json")
THEMES = [os.path.join(HERDR, "themes", n + ".json") for n in ("dms", "dms-dark", "dms-light")]
DMS_SETTINGS = os.path.join(CONFIG, "DankMaterialShell", "settings.json")


def from_ancestors():
    """The value DMS passed to `dms matugen generate --terminal-opacity N`, if we run under it."""
    pid = os.getppid()
    for _ in range(12):
        if pid <= 1:
            break
        try:
            argv = open(f"/proc/{pid}/cmdline", "rb").read().decode(errors="replace").split("\0")
            stat = open(f"/proc/{pid}/stat").read()
        except OSError:
            break
        for i, a in enumerate(argv):
            if a == "--terminal-opacity" and i + 1 < len(argv):
                return int(argv[i + 1])
            if a.startswith("--terminal-opacity="):
                return int(a.split("=", 1)[1])
        if "generate" in argv and any(a.endswith("dms") for a in argv[:1]):
            return 100          # DMS omits the flag at 100
        pid = int(stat.rsplit(")", 1)[1].split()[1])
    return None


def from_settings():
    try:
        return int(json.load(open(DMS_SETTINGS)).get("terminalOpacity", 100))
    except (OSError, ValueError, TypeError):
        return 100


def write(path, text):
    if open(path).read() == text:
        return
    fd, tmp = tempfile.mkstemp(dir=os.path.dirname(path), prefix=".herdr-opacity-")
    with os.fdopen(fd, "w") as f:
        f.write(text)
    os.chmod(tmp, 0o644)
    os.replace(tmp, path)


def main():
    if len(sys.argv) > 1:
        pct = int(sys.argv[1])
    else:
        try:
            pct = from_ancestors()
        except ValueError:
            pct = None
        if pct is None:
            pct = from_settings()
    if pct <= 0:
        pct = 100
    pct = max(10, min(100, pct))
    opaque = pct >= 100
    bar = "" if opaque else "%02x" % round(255 * pct / 100 * BAR_RATIO)
    alpha = {"background": "" if opaque else "00", "canvas": bar, "chrome": bar}

    for path in THEMES:
        if not os.path.exists(path):
            continue
        text = open(path).read()
        head, sep, colors = text.partition('"colors"')
        if not sep:
            continue
        for key, a in alpha.items():
            colors = re.sub(r'("%s":\s*"#[0-9a-fA-F]{6})(?:[0-9a-fA-F]{2})?"' % key,
                            lambda m: m.group(1) + a + '"', colors, count=1)
        write(path, head + sep + colors)

    if os.path.exists(LAYOUT):
        layout = json.load(open(LAYOUT))
        layout["window_blur"] = not opaque
        layout["terminal_opacity"] = pct / 100
        write(LAYOUT, json.dumps(layout, indent=2))


if __name__ == "__main__":
    main()
