#!/bin/bash
cd /home/ubuntu/app
sudo nohup java -jar -Dserver.port=8080 \
    *.jar > /dev/null 2> /dev/null < /dev/null &