#!/bin/bash

mode=$1
if [ -z "$mode" ];
then
    echo "Please provide mode to run"
    echo "Available options include:"
    echo "dev, gen, start"
else
    if [ -e "./package-lock.json" ];
    then
        rm package-lock.json
    fi
    npm install
    if [ ! -e "./package-lock.json" ]
    then
    echo "error with npm install, exiting...."
    exit
    fi
    if [[ "$mode" == "dev" ]];
    then
        echo "running in dev mode"
        npm run dev
    elif [[ "$mode" == "start" ]];
    then
        echo "running the start script"
        npm run start
    elif [[ "$mode" == "gen" ]];
    then
        echo "running the generate script"
        npm run generate
    else
        echo "Valid options include:"
        echo "dev, generate, start"
    fi
fi