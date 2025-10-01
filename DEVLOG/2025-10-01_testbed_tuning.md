# Investigate Bandwidth Limitation
1. Verify Pi network interface is configured to > 100 Mbps
2. Verify cable quality
3. Run additional iperf tests

## Verify Pi network interface is configured to > 100 Mbps
```bash
ethtool eth0 | grep Speed
# Should show "Speed: 1000Mb/s" or "Speed: 100Mb/s"
```
1. `pi-jitter-1` `Speed: 1000Mb/s`
2. `pi-jitter-2` `Speed: 1000Mb/s`
3. Speeds verified at 1000 Mbps

## Verify cable quality
1. Verified CAT 6 Ethernet cables in use, issued by IT department.

## Run additional iPerf3 tests
1. Increase receive buffer sizes on both Pis.
2. Ran investigate_bandwidth script on both pis concurrently
3. Dropped RX packets very high
	1. pi-jitter-1: 2615 dropped out of 3.67 M total
	2. pi-jitter-2: 2438 dropped out of 6026 total. 
4. CPU throttling
	1. pi-jitter-1: 1700 MHz
	2. pi-jitter-2: 600 MHz - power saving mode?

## Extended testing
1. Conduct longer duration tests to capture time based patterns
	```bash
--- 192.168.50.12 ping statistics ---
10000 packets transmitted, 10000 received, 0% packet loss, time 20086ms
rtt min/avg/max/mdev = 0.125/0.163/0.327/0.017 ms
	   ```
```bash
--- 192.168.50.11 ping statistics ---
10000 packets transmitted, 10000 received, 0% packet loss, time 20038ms
rtt min/avg/max/mdev = 0.128/0.147/0.256/0.003 ms

```
1. Add bi-directional testing (pi to pi) for asymmetric issues