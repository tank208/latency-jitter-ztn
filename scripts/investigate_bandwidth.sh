#!/bin/bash
# Network Bandwidth Investigation Script for Raspberry Pi
# Run this on both pi1 and pi2 to diagnose bandwidth issues

echo "=========================================="
echo "NETWORK BANDWIDTH INVESTIGATION"
echo "=========================================="
echo ""

# 1. CHECK NETWORK INTERFACE CONFIGURATION
echo "1. CHECKING NETWORK INTERFACE SPEED & DUPLEX"
echo "------------------------------------------"

# Find the primary network interface (usually eth0 or wlan0)
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)
echo "Primary interface: $INTERFACE"
echo ""

# Check link speed and duplex mode
echo "Interface details:"
ethtool $INTERFACE 2>/dev/null | grep -E "Speed|Duplex|Link detected"
echo ""

# Alternative method if ethtool doesn't work
if [ $? -ne 0 ]; then
    echo "Ethtool not available. Checking via other methods..."
    cat /sys/class/net/$INTERFACE/speed 2>/dev/null
    cat /sys/class/net/$INTERFACE/duplex 2>/dev/null
fi
echo ""

# 2. CHECK FOR INTERFACE ERRORS
echo "2. CHECKING NETWORK INTERFACE ERRORS"
echo "------------------------------------------"
ip -s link show $INTERFACE | grep -A 5 "RX:\|TX:"
echo ""
ifconfig $INTERFACE 2>/dev/null | grep -E "errors|dropped|overruns|carrier"
echo ""

# 3. CHECK MTU SIZE
echo "3. CHECKING MTU SIZE"
echo "------------------------------------------"
ip link show $INTERFACE | grep mtu
echo "Note: Standard MTU is 1500. Lower values may reduce throughput."
echo ""

# 4. CHECK FOR TRAFFIC CONTROL / RATE LIMITING
echo "4. CHECKING FOR TRAFFIC CONTROL (tc) RULES"
echo "------------------------------------------"
tc qdisc show dev $INTERFACE
tc class show dev $INTERFACE 2>/dev/null
echo "Note: 'qdisc pfifo_fast' or 'qdisc noqueue' is normal (no rate limiting)"
echo "      'qdisc tbf' or 'qdisc htb' indicates rate limiting is active"
echo ""

# 5. CHECK IPTABLES FOR RATE LIMITING
echo "5. CHECKING IPTABLES FOR RATE LIMITING"
echo "------------------------------------------"
sudo iptables -L -v -n | grep -i limit
echo "Note: No output = no iptables rate limiting"
echo ""

# 6. CHECK CPU FREQUENCY/THROTTLING
echo "6. CHECKING CPU STATUS (throttling can affect network)"
echo "------------------------------------------"
echo "CPU frequency:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null
echo "Throttling status:"
vcgencmd get_throttled 2>/dev/null
echo "Temperature:"
vcgencmd measure_temp 2>/dev/null
echo ""

# 7. CHECK NETWORK DRIVER
echo "7. CHECKING NETWORK DRIVER & MODULE"
echo "------------------------------------------"
ethtool -i $INTERFACE 2>/dev/null | grep -E "driver|version"
lsmod | grep -E "r8169|bcmgenet|lan78xx" | head -n 3
echo ""

# 8. ENHANCED IPERF3 TESTS
echo "8. RUNNING ENHANCED IPERF3 TESTS"
echo "------------------------------------------"
echo "Instructions:"
echo "On SERVER (e.g., pi2): iperf3 -s"
echo "On CLIENT (e.g., pi1): Run the following tests"
echo ""

# Get the IP of the other Pi (you'll need to customize this)
read -p "Enter IP address of the iperf3 server: " SERVER_IP

if [ ! -z "$SERVER_IP" ]; then
    echo ""
    echo "Test 1: Standard TCP test (10 seconds)"
    iperf3 -c $SERVER_IP -t 10
    
    echo ""
    echo "Test 2: TCP with larger window size (reduces overhead)"
    iperf3 -c $SERVER_IP -t 10 -w 256K
    
    echo ""
    echo "Test 3: Multiple parallel streams (tests aggregate bandwidth)"
    iperf3 -c $SERVER_IP -t 10 -P 4
    
    echo ""
    echo "Test 4: UDP test (tests max throughput without TCP overhead)"
    iperf3 -c $SERVER_IP -t 10 -u -b 100M
    
    echo ""
    echo "Test 5: Reverse mode (server sends to client)"
    iperf3 -c $SERVER_IP -t 10 -R
    
    echo ""
    echo "Test 6: Bidirectional test"
    iperf3 -c $SERVER_IP -t 10 --bidir
else
    echo "Skipping iperf3 tests. Run manually with the commands above."
fi

echo ""
echo "=========================================="
echo "INVESTIGATION COMPLETE"
echo "=========================================="
echo ""
echo "QUICK FIXES TO TRY:"
echo "-------------------"
echo "1. If speed shows 10Mbps instead of 100/1000Mbps:"
echo "   - Check/replace Ethernet cable"
echo "   - Check switch port configuration"
echo ""
echo "2. If half-duplex detected:"
echo "   sudo ethtool -s $INTERFACE speed 1000 duplex full autoneg on"
echo ""
echo "3. If MTU is low (< 1500):"
echo "   sudo ip link set $INTERFACE mtu 1500"
echo ""
echo "4. If tc rate limiting found:"
echo "   sudo tc qdisc del dev $INTERFACE root"
echo ""
echo "5. Disable power management (can throttle WiFi):"
echo "   sudo iwconfig $INTERFACE power off  # for WiFi only"
echo ""
echo "6. Update firmware and packages:"
echo "   sudo apt update && sudo apt upgrade -y"
echo "   sudo rpi-update  # firmware update"
