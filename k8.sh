#!/bin/bash

# Exit on error
set -e

echo "🟢 Starting script..."

# 1. Update and upgrade packages
echo "🔄 Updating system..."
sudo apt-get update -y && sudo apt-get upgrade -y

# 2. Create a directory
DIR_NAME="$HOME/demo_script_folder"
echo "📂 Creating directory: $DIR_NAME"
mkdir -p "$DIR_NAME"

# 3. Write a file
FILE_PATH="$DIR_NAME/system_info.txt"
echo "📝 Writing system information to $FILE_PATH"
{
  echo "Date: $(date)"
  echo "Hostname: $(hostname)"
  echo "Uptime: $(uptime -p)"
  echo "Logged in users:"
  who
} > "$FILE_PATH"

# 4. Display disk usage
echo "💾 Disk usage:"
df -h

# 5. Optional cleanup
# echo "🧹 Removing created directory..."
# rm -rf "$DIR_NAME"

echo "✅ Script completed!"
