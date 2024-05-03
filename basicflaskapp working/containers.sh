#!/bin/bash

run_container() {
    # Function for handling the "run" command
    docker network create --subnet=168.0.0.0/24 subnett
    local num_containers=$1

    # Iterate through the desired number of containers
    for (( i=1; i<=$num_containers; i++ )); do
        # Calculate the IP address for this container
        ip_address="168.0.0."$(($i + 2))

        # Construct the docker run command for this container
        docker run -d -it --name "flaskapp$i" --network=subnett --ip="$ip_address" flaskappimg

        echo "Started container flaskapp$i with IP address $ip_address"
    done
}

stop_container() {
    # Function for handling the "stop" command
    local num_containers=$1

    # Iterate through the desired number of containers
    for (( i=1; i<=$num_containers; i++ )); do

        # Construct the docker stop command for this container
        docker stop "flaskapp$i" &

        echo "Stopped container flaskapp$i"
    done
}

remove_container() {
    # Function for handling the "remove" command
    # Function for handling the "stop" command
    local num_containers=$1

    # Iterate through the desired number of containers
    for (( i=1; i<=$num_containers; i++ )); do

        # Construct the docker stop command for this container
        docker rm "flaskapp$i"

        echo "Removed container flaskapp$i"
    done
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [run|stop|remove] [n]"
    exit 1
fi

command=$1
n=$2

case $command in
    run)
        run_container $n
        ;;
    stop)
        stop_container $n
        ;;
    remove)
        remove_container $n
        ;;
    *)
        echo "Unknown command: $command"
        echo "Usage: $0 [run|stop|remove] [n]"
        exit 1
        ;;
esac

echo "Done"

#commands for my reference
#docker stop $(docker ps -a -q)
#docker rm $(docker ps -a -q)
#docker run -it --cap-add=NET_ADMIN --network=subnett --ip=168.0.0.2 ldblrimg bash 

