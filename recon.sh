#!/bin/bash

DATE=$(date +"%b-%d-%Y")
URL=$1
DIR=$2
OUTPUT="${URL}-test-${DATE}.txt"

mkdir "${DIR}" && cd $_

sleep 0.5


wget "http://${URL}/robots.txt" -O "robots-${OUTPUT}"

sleep 0.5

whatweb "http://${URL}" > "whatweb-${OUTPUT}"