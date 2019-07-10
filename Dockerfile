FROM nodered/node-red-docker
USER root
RUN npm install -g node-red-contrib-redis

