#!/bin/bash

# Script version
VERSION="1.0.0"

# Function to display the version
display_version() {
    echo "LMK version $VERSION"
    exit 0
}

# Function to display help
display_help() {
    echo "Usage: lmk.sh [options] [message]"
    echo ""
    echo "Options:"
    echo "  -m, --message    Custom message to send as notification"
    echo "  -d, --delay      Delay in seconds before sending the message"
    echo "  -n, --num    Prefix the message with a number"
    echo "  -t, --timestamp  Add a timestamp to the message"
    echo "  -v, --version    Display the version of the script"
    echo "  -h, --help       Display this help message"
    echo ""
    echo "Example:"
    echo "  lmk.sh --message \"Backup Complete\" --timestamp"
    exit 0
}

# Configuration file path
CONFIG_FILE="$HOME/.lmk_config"

# Read Telegram Bot Token and Chat ID from the configuration file
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found. Please make sure you have set up your bot token and chat ID."
    exit 1
fi

# Default values
MESSAGE="Done!"
DELAY=0
PREFIX_NUMBER=""
TIMESTAMP=""

# Flag to check if the message was set via named argument
NAMED_MESSAGE_SET=false

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m|--message) 
            MESSAGE="$2"; 
            NAMED_MESSAGE_SET=true; 
            shift ;;
        -d|--delay) 
            DELAY="$2"; 
            shift ;;
        -n|--num)
            PREFIX_NUMBER="$2. "; 
            shift ;;
        -t|--timestamp) 
            TIMESTAMP="true" ;;
        -v|--version)
            display_version ;;
        -h|--help)
            display_help ;;
        *) 
            # If no named message argument, treat as positional message
            if [ "$NAMED_MESSAGE_SET" = false ]; then
                MESSAGE="$1"
                NAMED_MESSAGE_SET=true
            else
                echo "Unknown parameter passed: $1"; 
                exit 1 
            fi ;;
    esac
    shift
done

# Add timestamp if requested
if [[ "$TIMESTAMP" == "true" ]]; then
    MESSAGE="$MESSAGE [at $(date)]"
fi

# Add number prefix if provided
MESSAGE="$PREFIX_NUMBER$MESSAGE"

# Apply delay if specified
sleep "$DELAY"

# Send the message
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d chat_id="$TELEGRAM_CHAT_ID" -d text="$MESSAGE" -o /dev/null

# Check for successful send
if [ $? -ne 0 ]; then
    echo "Failed to send notification."
    exit 1
fi
