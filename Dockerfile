FROM node:10.13 AS builder
LABEL description="Shift Explorer Docker Image" version="1.5.0"

ARG DEBIAN_FRONTEND=noninteractive
ENV TOP=true
ENV TERM=xterm
ENV NPM_CONFIG_PREFIX=/home/shiftexplorer/.npm-global
ENV PATH=$PATH:/home/shiftexplorer/.npm-global/bin 
# optionally if you want to run npm global bin without specifying path

# Install Dependencies
WORKDIR /~
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential jq redis-server

FROM builder AS shiftuser
# Create shiftexplorer user & group
RUN useradd -ms /bin/bash shiftexplorer

# Configure Global NPM Folder
USER shiftexplorer
WORKDIR /home/shiftexplorer
RUN mkdir .npm-global && npm config set prefix "~/.npm-global" &&\ 
    export PATH=~/.npm-global/bin:$PATH && /bin/bash -c "source ~/.profile" &&\
    npm install -g pm2 grunt-cli

# Install Shift Explorer
FROM shiftuser as shiftexplorer
USER shiftexplorer
WORKDIR /home/shiftexplorer
# Copy Assets
COPY ./package.json .
# COPY ./package-lock.json .
RUN yarn
COPY --chown=shiftexplorer:shiftexplorer . .

# Run webpack build
RUN cd /home/shiftexplorer && yarn build:prd

USER shiftexplorer
WORKDIR /home/shiftexplorer
CMD ["node", "app.js"]
