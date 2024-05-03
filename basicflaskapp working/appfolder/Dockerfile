FROM ubuntu:22.04
# install app dependencies
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip install flask==3.0.*
# copy the flask app

COPY app.py /
# final configuration and running the application with exposed port
ENV FLASK_APP=app
EXPOSE 5000

CMD python3 app.py
