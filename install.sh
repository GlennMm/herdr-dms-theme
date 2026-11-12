#!/usr/bin/env bash
# Registers the herdr DMS theme templates with matugen so DankMaterialShell
# regenerates ~/.config/herdr-app/themes/dms*.json on every wallpaper/theme change.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
MATUGEN_CONFIG="$CONFIG_HOME/matugen/config.toml"
THEMES_DIR="$CONFIG_HOME/herdr-app/themes"
BEGIN="# >>> herdr-dms-theme >>>"
END="# <<< herdr-dms-theme <<<"

mkdir -p "$(dirname "$MATUGEN_CONFIG")" "$THEMES_DIR"
touch "$MATUGEN_CONFIG"

# Drop any previous block so re-running is idempotent.
if grep -qF "$BEGIN" "$MATUGEN_CONFIG"; then
  sed -i "/^$BEGIN\$/,/^$END\$/d" "$MATUGEN_CONFIG"
fi

# matugen needs a [config] table; add one only if the file has none.
grep -q '^\[config\]' "$MATUGEN_CONFIG" || printf '[config]\n\n' >> "$MATUGEN_CONFIG"

cat >> "$MATUGEN_CONFIG" <<TOML
$BEGIN
# Follows DMS's current light/dark mode
[templates.herdr-dms]
input_path = '$HERE/templates/herdr.json'
output_path = '$THEMES_DIR/dms.json'

[templates.herdr-dms-dark]
input_path = '$HERE/templates/herdr-dark.json'
output_path = '$THEMES_DIR/dms-dark.json'

[templates.herdr-dms-light]
input_path = '$HERE/templates/herdr-light.json'
output_path = '$THEMES_DIR/dms-light.json'
$END
TOML

echo "Added herdr templates to $MATUGEN_CONFIG"
echo "Make sure DMS Settings > Theme > 'Run user matugen templates' is on (it is by default),"
echo "then change wallpaper or toggle dark/light once to generate the themes."
