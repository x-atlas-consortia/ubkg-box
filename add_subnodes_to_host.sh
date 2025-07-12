#!/bin/bash

# Adds the subnode neo4j.ubkgbox.com to the local host file.
# This has been tested on MacOs.

HOST_ENTRY_NEO4J="127.0.0.1    neo4j.ubkgbox.com"

# Prompt for sudo password at the start.
    
if ! sudo -n true 2>/dev/null; then
    echo
    echo "The UBKGBox application uses subnodes (*.ubkgbox.com) that are mapped by default to the localhost/loopback IP (127.0.0.1)."
    echo "Setting up subnodes requires modifying the hosts file on the local machine. "
    echo "This requires administrative (sudo) privileges."
    echo 
fi

if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
    sudo -v || exit 1
    if ! sudo -v; then
        echo "Authentication with sudo failed."
        exit 1
    fi
fi

add_to_hosts() {
    if grep -q "neo4j.ubkgbox.com" /etc/hosts; then
        echo "UBKGBox subnodes already exist in /etc/hosts."
    else
        echo "Adding UBKGBox subnodes to /etc/hosts"
        echo "# UBKGBox" | sudo tee -a /etc/hosts > /dev/null
        echo "$HOST_ENTRY_NEO4J" | sudo tee -a /etc/hosts > /dev/null
        echo "# UBKGBox" | sudo tee -a /etc/hosts > /dev/null
    fi
}

flush_dns_macos() {
    echo "Flushing DNS cache on macOS..."
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
}

# Per Copilot: "On Linux, DNS cache flush is best-effort (not all systems cache DNS).""
flush_dns_linux() {
    # Try systemd-resolved first
    if command -v systemd-resolve >/dev/null; then
        echo "Flushing DNS cache with systemd-resolve..."
        sudo systemd-resolve --flush-caches
    elif sudo service dns-clean status &>/dev/null; then
        echo "Flushing DNS cache with dns-clean..."
        sudo service dns-clean restart
    elif sudo service nscd status &>/dev/null; then
        echo "Flushing DNS cache with nscd..."
        sudo service nscd restart
    elif sudo service dnsmasq status &>/dev/null; then
        echo "Flushing DNS cache with dnsmasq..."
        sudo service dnsmasq restart
    else
        echo "No recognized DNS caching service found. You may need to restart your network."
    fi
}

# Per Copilot: "On Windows, direct editing of the hosts file requires admin rights and may not work from 
# Bash unless run as administrator (or via WSL with sudo)." 
# This has not been tested on a Windows machine. YMMV.
add_to_hosts_windows() {
    HOSTS_PATH="/mnt/c/Windows/System32/drivers/etc/hosts"
    if grep -q "neo4j.ubkgbox.com" "$HOSTS_PATH"; then
        echo "UBKGBox subnodes already exist in /etc/hosts."
    else
        echo "Adding UBKGBox subnnodes to $HOSTS_PATH"
        # Requires script to be run as administrator or from an elevated shell
        echo "# UBKGBox" | sudo tee -a /etc/hosts > /dev/null
        echo "$HOST_ENTRY_NEO4J" | sudo tee -a "$HOSTS_PATH" > /dev/null
        echo "# UBKGBox" | sudo tee -a /etc/hosts > /dev/null
    fi
}

flush_dns_windows() {
    echo "Flushing DNS cache on Windows..."
    powershell.exe -Command "Clear-DnsClientCache"
}

# Main OS detection
case "$OSTYPE" in
  darwin*)
    add_to_hosts
    flush_dns_macos
    ;;
  linux*)
    # Check if running under WSL for Windows hosts file
    if grep -qi microsoft /proc/version 2>/dev/null; then
        add_to_hosts_windows
        flush_dns_windows
    else
        add_to_hosts
        flush_dns_linux
    fi
    ;;
  msys*|cygwin*)
    add_to_hosts_windows
    flush_dns_windows
    ;;
  *)
    echo "Unsupported OS: $OSTYPE"
    exit 1
    ;;
esac
