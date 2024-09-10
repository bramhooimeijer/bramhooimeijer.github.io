#!/bin/bash
SCHEME_NAME=fortyforwards

# Check if three arguments are provided or none
if [ $# -ne 3 ] && [ $# -ne 0 ]; then
    echo "Generate a '$SCHEME_NAME.css' theme css file using three colors (neutral, primary, secondary)."
    echo "See https://blowfish.page/docs/advanced-customisation/#colour-schemes for more information"
    echo "Usage: $0 <hex1> <hex2> <hex3>"
    exit 1
fi

# Set default values if no arguments are provided
if [ $# -eq 0 ]; then
    set -- 657B9A 00AAE7 C75000
fi

original_dir=$(pwd)
git_root=$(git rev-parse --show-toplevel)
cd "$git_root" || exit 1

scripts/fugu/index.js generate "$1" "$2" "$3" &> /dev/null
mv ./output.css ./assets/css/schemes/$SCHEME_NAME.css

echo "Color scheme generated and saved to assets/css/schemes/$SCHEME_NAME.css"

# Temporarily change colorScheme to trigger a rebuild
sed -i 's/colorScheme = ".*"/colorScheme = "ocean"/' config/_default/params.toml

# Wait a moment to ensure Hugo detects the change
sleep .5

# Change it back
sed -i "s/colorScheme = \"ocean\"/colorScheme = \"$SCHEME_NAME\"/" config/_default/params.toml

echo "Triggered Hugo rebuild"

cd "$original_dir" || exit 1
# Color 1
# - Text
# Color 2
# - label boxes
# - Hover highlights
# - Underline in ToC
# Color 3
