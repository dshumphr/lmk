#!/bin/bash

# Script version
VERSION="1.0.0"

# Function to display the version
display_version() {
    echo "RLMK version $VERSION"
    exit 0
}

# Function to display help
display_help() {
    echo "Usage: rlmk.sh [options] command"
    echo ""
    echo "Runs a command and sends a notification via LMK upon completion."
    echo "The notification will include the command run and its status."
    echo ""
    echo "Options:"
    echo "  Same as lmk.sh, including -m, --message, -d, --delay, -n, --num, -t, --timestamp"
    echo "  -v, --version    Display the version of the script"
    echo "  -h, --help       Display this help message"
    echo ""
    echo "For detailed options, refer to lmk.sh --help"
    echo ""
    echo "Example:"
    echo "  rlmk.sh -t echo \"Test Command\""
    exit 0
}

# Path to the lmk script
LMK_SCRIPT_PATH="/usr/local/bin/lmk.sh"

# Function to run a command and notify
run_and_notify() {
    # Capture the command and its arguments
    local original_command=("$@")

    # Extract lmk specific arguments
    local lmk_args=()
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -m|--message|-d|--delay|-n|--num|-t|--timestamp) 
                lmk_args+=("$1")
                # Add the argument's value for options that have one
                if [[ "$1" == "-m" ]] || [[ "$1" == "--message" ]] || [[ "$1" == "-d" ]] || [[ "$1" == "--delay" ]] || [[ "$1" == "-n" ]] || [[ "$1" == "--number" ]]; then
                    lmk_args+=("$2")
                    shift
                fi
                ;;
            *) 
                # Break on the first non-lmk argument
                break
                ;;
        esac
        shift
    done

    # Remaining arguments are the command to run
    local command_to_run=("$@")

    # Execute the command
    "${command_to_run[@]}"
    local command_status=$?

    # Construct the base message
    local base_message="Command '${command_to_run[*]}' completed with status ${command_status}"

    # Append the base message to lmk_args if --message is not already set
    if [[ ! " ${lmk_args[@]} " =~ " -m " ]] && [[ ! " ${lmk_args[@]} " =~ " --message " ]]; then
        lmk_args+=("--message" "$base_message")
    else
        # Replace the custom message with custom message + base message
        for ((i = 0; i < ${#lmk_args[@]}; i++)); do
            if [[ "${lmk_args[i]}" == "-m" ]] || [[ "${lmk_args[i]}" == "--message" ]]; then
                lmk_args[i+1]="${lmk_args[i+1]} $base_message"
                break
            fi
        done
    fi

    # Call lmk script with constructed message and additional arguments
    "$LMK_SCRIPT_PATH" "${lmk_args[@]}"
}

# Parse command-line arguments for version and help flags
case "$1" in
    -v|--version) display_version ;;
    -h|--help) display_help ;;
    *)
        # Pass all arguments to the run_and_notify function
        run_and_notify "$@"
        ;;
esac

# Pass all arguments to the run_and_notify function
run_and_notify "$@"
