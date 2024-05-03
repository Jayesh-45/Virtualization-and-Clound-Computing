#!/bin/bash

roundrobin() {
    # Function for handling the round robin 
    local num_containers=$1
    iptables -t nat -A POSTROUTING -j MASQUERADE
    # Iterate through the desired number of containers
    for (( i=1; i<$num_containers; i++ )); do
        # Calculate the IP address for this container
        ip_address="168.0.0."$(($i + 2))

        # Calculate the weight for this container in the round-robin sequence
        weight=$(( num_containers - i + 1 ))

        # Construct the docker run command for this container
        iptables -t nat -A PREROUTING -p tcp --destination-port 8080 -m statistic --mode nth --every "$weight" --packet 0 -j DNAT --to-destination "$ip_address":5000

        echo "Added round robin rule for container with $ip_address"
    done
    ip_address="168.0.0."$(($num_containers + 2))
    iptables -t nat -A PREROUTING -p tcp --destination-port 8080 -j DNAT --to-destination "$ip_address":5000
    echo "Added round robin rule for container with $ip_address"
}

probabilistic() {
    local num_containers=$1
    local probability=1.0
    iptables -t nat -A POSTROUTING -j MASQUERADE
    for (( i=1; i<$num_containers; i++ )); do
        ip_address="168.0.0.$(($i + 2))"
        remaining_containers=$(( num_containers - i + 1 ))
        curr_prob=$(echo "scale=10; $probability / $remaining_containers" | bc)
        iptables -t nat -A PREROUTING -p tcp --destination-port 8080 -m statistic --mode random --probability $curr_prob -j DNAT --to-destination "$ip_address":5000
        probability=$(echo "scale=10; $probability - $curr_prob" | bc)
        echo "Added probabilistic rule for container with $ip_address with probability $curr_prob"
    done
    ip_address="168.0.0.$(($num_containers + 2))"
    iptables -t nat -A PREROUTING -p tcp --destination-port 8080 -j DNAT --to-destination "$ip_address":5000
    echo "Added probabilistic rule for container with $ip_address with probability $probability"
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [n] [r|p]"
    exit 1
fi

command=$2
n=$1

case $command in
    r)
        roundrobin $n
        ;;
    p)
        probabilistic $n
        ;;
    *)
        echo "Unknown command: $command"
        echo "Usage: $0 [n] [r|p]"
        exit 1
        ;;
esac
















# # Apply NAT rule
# #roundrobin
# iptables -t nat -A POSTROUTING -j MASQUERADE
# iptables -t nat -A PREROUTING -p tcp --destination-port 8080 -m statistic --mode random --probability 0.3 -j DNAT --to-destination 168.0.0.3:5000
# iptables -t nat -A PREROUTING -p tcp --destination-port 8080 -m statistic --mode random --probability 0.5 -j DNAT --to-destination 168.0.0.4:5000
# iptables -t nat -A PREROUTING -p tcp --destination-port 8080 -j DNAT --to-destination 168.0.0.5:5000


