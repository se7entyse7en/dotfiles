set -e

are_xcode_command_line_tools_installed() {
    xcode-select --print-path &> /dev/null
}

# Install Xcode command line tools
echo "Installing Xcode command line tools..."
xcode-select --install &> /dev/null
# Wait Xcode installation
until are_xcode_command_line_tools_installed; do
    sleep 5;
done
