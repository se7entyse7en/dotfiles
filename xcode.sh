are_xcode_command_line_tools_installed() {
    xcode-select --print-path &> /dev/null
}

is_xcode_installed() {
    [ -d "/Applications/Xcode.app" ]
}

# Install Xcode command line tools
echo "Installing Xcode command line tools..."
xcode-select --install &> /dev/null
# Wait Xcode installation
until are_xcode_command_line_tools_installed; do
    sleep 5;
done

# Install Xcode
echo "Installing Xcode..."
if ! is_xcode_installed; then
    open "macappstores://itunes.apple.com/en/app/xcode/id497799835"
fi
# Wait Xcode installation
until is_xcode_installed; do
    sleep 5;
done

# Set Xcode developer directory
echo "Setting Xcode developer directory..."
sudo xcode-select -switch "/Applications/Xcode.app/Contents/Developer" &> /dev/null

# Agree with with Xcode license
echo "Agreeing Xcode license..."
sudo xcodebuild -license accept &> /dev/null
