# remove all rules
iptables -F

# drop all other connections
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow local loopback services
iptables -A INPUT -i lo -j ACCEPT

# Allow traffic already established to continue
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow web services
iptables -A INPUT -p tcp --dport 80 -i eth0 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -i eth0 -j ACCEPT

# Allow pings
iptables -I INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -I INPUT -p icmp --icmp-type source-quench -j ACCEPT
iptables -I INPUT -p icmp --icmp-type time-exceeded -j ACCEPT

# Drop security scanner
iptables -A INPUT -d 198.211.119.109/32 -p tcp -m tcp --dport 80 -m string --string "GET /w00tw00t.at.ISC.SANS." --algo bm --to 70 -j DROP

iptables -L -v