# RF Showcase : PulseTile + Node Red  + Redis 
## OS tools in action - from the Ripple Foundation





## Installation Guide
Please put project to your home folder (~), you should have installed docker and docker-compose on your machine.
If you will not use home folder, please change paths in docker-compose.yml. Nginx config file locates in **nginx/conf.d**.
In our nginx we have default config like 
``` 
server {
        listen       80;
        listen       [::]:80;
        server_name  127.0.0.1;
        location / {
            root  /nodered-nginx/html;
            index  index.html index.htm;
        }
}
```
When you will deploy to dev/prod server you should change **server_name** with IP address of the server or domain name, e.g. **server_name nodered.example.com**

After that you should go to nodered-nginx folder and type ``` docker-compose up -d ```, all containers will download and install needed packages.
This version contains, containers for Nginx, Redis and NodeRed, also it has already built files for PulseTile in **nginx/html** folder. 

## Update UI Builds
In root folder we have **updateUI.sh** file, for updating latest UI builds, you just need open terminal and type ``` chmod +x uploadUI.sh ``` and  ```./updateUI.sh```. It will automatically update needed files for frontend side. 

## Youtube Explainer

[![Overview of PulseTile on Youtube on Redis](https://img.youtube.com/vi/SYcUhV7Hshw/0.jpg)](https://www.youtube.com/watch?v=SYcUhV7Hshw)

## Links to related repos

PulseTile  (UX/UI frontend)
https://github.com/PulseTile/PulseTile-RA/tree/nodered-demo

NodeRed (for API flows) on Redis (for persistence)  - via Docker
https://github.com/RippleOSI/NodeRed-JSON-Redis-exp2

these components are pulled together in this demo



