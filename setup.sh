#!/bin/bash

# Paths
INSTALL_DIR="/usr/local/bin"
CONFIG_FILE="$HOME/.lmk_config"
LMK_SCRIPT="lmk.sh"
RLMK_SCRIPT="rlmk.sh"

echo "LMK Setup Script"

# Check if the user has permission to write to the install directory
if [ ! -w "$INSTALL_DIR" ]; then
    echo "Error: You do not have permission to write to $INSTALL_DIR."
    echo "Please run this script with sudo or as a user with the appropriate permissions."
    exit 1
fi

# Function to prompt for user input
prompt_for_input() {
    read -p "$1: " input
    while [[ -z "$input" ]]; do
        echo "Input cannot be empty. Please enter a valid value."
        read -p "$1: " input
    done
    echo $input
}

# Prompt for Telegram Bot Token and Chat ID
TELEGRAM_BOT_TOKEN=$(prompt_for_input "Enter your Telegram Bot Token")
TELEGRAM_CHAT_ID=$(prompt_for_input "Enter your Telegram Chat ID")

# Write to configuration file
echo "Writing configuration..."
echo "TELEGRAM_BOT_TOKEN='$TELEGRAM_BOT_TOKEN'" > "$CONFIG_FILE"
echo "TELEGRAM_CHAT_ID='$TELEGRAM_CHAT_ID'" >> "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

# Install lmk and rlmk scripts
echo "Installing scripts..."
cp "./$LMK_SCRIPT" "$INSTALL_DIR/$LMK_SCRIPT"
cp "./$RLMK_SCRIPT" "$INSTALL_DIR/$RLMK_SCRIPT"
chmod +x "$INSTALL_DIR/$LMK_SCRIPT"
chmod +x "$INSTALL_DIR/$RLMK_SCRIPT"

# Create a symbolic link for lmk.sh
ln -sf "$INSTALL_DIR/$LMK_SCRIPT" "$INSTALL_DIR/lmk"
ln -sf "$INSTALL_DIR/$RLMK_SCRIPT" "$INSTALL_DIR/rlmk"

echo "Installation completed successfully."
echo "Scripts are installed in $INSTALL_DIR and configuration is stored in $CONFIG_FILE"
echo "You can use the command 'lmk' directly to run the script."
