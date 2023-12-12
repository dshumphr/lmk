```
 _           _    
 | |_ __ ___ | | __
 | | '_ ` _ \| |/ /
 | | | | | | |   < 
 |_|_| |_| |_|_|\_\
```

## What is LMK?
LMK (Let Me Know) is a simple bash tool designed to send notifications to your Telegram account upon the completion of a command in your terminal. It offers flexibility with customizable messages, timing options, and can handle various scenarios based on the success or failure of commands.

## Prerequisites: Creating a Telegram Bot
Before installing LMK, you need to create a Telegram bot and obtain your unique bot token and chat ID.

### Steps to Create a Telegram Bot:
1. **Create the Bot:**
   - Open Telegram and search for the 'BotFather'.
   - Start a chat and type `/newbot`.
   - Follow the instructions to set a name and a username for your bot.
   - Once created, BotFather will provide a bot token. Keep this token safe as it will be needed during the setup.

2. **Get Your Chat ID:**
   - Start a chat with your new bot or add it to a group.
   - Send a message to it.
   - Visit `https://api.telegram.org/bot[YourBOTToken]/getUpdates` in your browser to find your chat ID in the JSON response.

## Installation
To install LMK, follow these steps:

1. **Clone the Repository:**
   - Clone or download this repository to your local machine.

2. **Run the Setup Script:**
   - Navigate to the directory containing LMK.
   - Make the setup script executable: `chmod +x setup.sh`.
   - Run the setup script: `./setup.sh`.
   - Follow the prompts to enter your Telegram bot token and chat ID.

3. **Check the Installation:**
   - Ensure that the scripts `lmk` and `rlmk` are available in your path. You can check this by typing `which lmk` and `which rlmk`.

## Usage
LMK can be used in multiple ways, depending on your needs. Here are some examples:

### Basic Usage
Send a notification when a command completes:
```bash
your-command ; lmk
```

### Customize Alert
Send a custom message with a number prepended and timestamp appended:
```bash
your-command ; lmk --num 3 --message "Custom Alert Message" --timestamp
```
Reminder: Use ';' if you prefer to receive a notification regardless of command success. Use && 

### Delay Alert
Add a delay (in seconds) to the notification:
```bash
your-command ; lmk --delay 30
```

### Conditional Alert
Send a notification only when a command successfully with '&&':
```bash
your-command && lmk
```
Send a different notification depending on command status:
```bash
your-command && lmk "success" || lmk "failure"
```

### Using rlmk for more details
rlmk will run a command and send a detailed notification including the command itself and its exit status:
```bash
rlmk echo "test"
```
