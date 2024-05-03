FROM ubuntu:22.04
# install app dependencies
RUN apt-get update && apt-get install -y python3 python3-pip && apt-get install -y python3 python3-pip iptables sudo && apt-get install -y bc
RUN pip install flask==3.0.*
# Copy the load balancer script
COPY scriptt.sh /
RUN chmod +x scriptt.sh
#CMD sh -c /scriptt.sh 
