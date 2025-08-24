#!/bin/bash

# WiFi Plugin for SketchyBar
# This script shows WiFi connection status and details

# Get WiFi interface (usually en0 on macOS)
WIFI_INTERFACE="en0"

# Function to get WiFi icon (simple: connected or disconnected)
get_wifi_icon() {
    local status=$1
    if [[ "$status" == "connected" ]]; then
        echo "󰤨"  # Full WiFi signal
    else
        echo "󰤮"  # Disconnected WiFi
    fi
}

# Function to get WiFi status
get_wifi_status() {
    local status
    status=$(networksetup -getairportpower $WIFI_INTERFACE | awk '{print $4}')
    echo "$status"
}

# Function to get current WiFi network name (SSID)
get_current_ssid() {
    local ssid
    
    # Try to get SSID using system_profiler with better parsing
    local wifi_data
    wifi_data=$(system_profiler SPAirPortDataType 2>/dev/null)
    
    # Look for the actual network name after "Current Network Information:"
    ssid=$(echo "$wifi_data" | awk '
        /Current Network Information:/ { 
            in_current = 1; 
            next 
        }
        in_current && /^[[:space:]]*[^:[:space:]][^:]*:/ && !/Network Type:|Channel:|Country Code:|Security:|Signal|PHY Mode/ {
            gsub(/^[[:space:]]*/, "");
            gsub(/:.*$/, "");
            print;
            exit
        }
    ')
    
    # If that doesn't work, try a simpler approach
    if [[ -z "$ssid" ]]; then
        ssid=$(echo "$wifi_data" | grep -A 10 "Current Network Information:" | grep -v "Network Type\|Channel\|Country Code\|Security\|Signal\|PHY Mode\|Current Network Information" | grep ":" | head -1 | cut -d: -f1 | sed 's/^[[:space:]]*//')
    fi
    
    # If still empty, try networksetup as fallback
    if [[ -z "$ssid" ]]; then
        local network_info
        network_info=$(networksetup -getairportnetwork en0 2>/dev/null)
        if [[ "$network_info" == *"Current Wi-Fi Network:"* ]]; then
            ssid=$(echo "$network_info" | sed 's/Current Wi-Fi Network: //')
        fi
    fi
    
    # Clean up the result
    ssid=$(echo "$ssid" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    
    if [[ -z "$ssid" ]] || [[ "$ssid" == *"not associated"* ]] || [[ "$ssid" == *"AirPort network"* ]]; then
        echo "Not Connected"
    else
        echo "$ssid"
    fi
}

# Function to get signal strength
get_signal_strength() {
    local signal
    signal=$(system_profiler SPAirPortDataType | grep "Signal / Noise" | awk -F': ' '{print $2}' | awk '{print $1}')
    echo "$signal"
}

# Function to get IP address
get_ip_address() {
    local ip
    ip=$(ifconfig $WIFI_INTERFACE | grep "inet " | awk '{print $2}')
    echo "${ip:-"No IP"}"
}

# Function to get router IP (gateway)
get_router_ip() {
    local router_ip
    router_ip=$(route -n get default | grep gateway | awk '{print $2}')
    echo "${router_ip:-"Unknown"}"
}

# Function to show detailed WiFi information
show_wifi_details() {
    local ssid signal ip router_ip security channel
    ssid=$(get_current_ssid)
    signal=$(get_signal_strength)
    ip=$(get_ip_address)
    router_ip=$(get_router_ip)
    
    # Get security type and channel from system_profiler
    local wifi_info
    wifi_info=$(system_profiler SPAirPortDataType)
    
    security=$(echo "$wifi_info" | grep -A 20 "$ssid" | grep "Security" | awk -F': ' '{print $2}' | xargs)
    channel=$(echo "$wifi_info" | grep -A 20 "$ssid" | grep "Channel" | awk -F': ' '{print $2}' | xargs)
    
    # Create notification with details
    osascript -e "display notification \"SSID: $ssid
Signal: ${signal} dBm
IP Address: $ip
Router: $router_ip
Security: ${security:-"Unknown"}
Channel: ${channel:-"Unknown"}\" with title \"WiFi Details\" sound name \"Glass\""
}

# Main logic based on arguments
case "$1" in
    "click")
        toggle_wifi_popup
        ;;
    *)
        # Default behavior - update the bar
        wifi_status=$(get_wifi_status)
        
        if [[ "$wifi_status" == "On" ]]; then
            ssid=$(get_current_ssid)
            
            if [[ "$ssid" == "Not Connected" ]]; then
                # WiFi is on but not connected
                wifi_icon=$(get_wifi_icon "disconnected")
                sketchybar --set wifi \
                    icon="$wifi_icon" \
                    label="No Connection"
            else
                # Connected to WiFi
                wifi_icon=$(get_wifi_icon "connected")
                
                sketchybar --set wifi \
                    icon="$wifi_icon" \
                    label="$ssid"
            fi
        else
            # WiFi is off
            wifi_icon=$(get_wifi_icon "disconnected")
            sketchybar --set wifi \
                icon="$wifi_icon" \
                label="WiFi Off"
        fi
        ;;
esac
