##!/bin/bash
echo "This tool is developed by Hunters_Box"

#starting sublist3r
sublist3r -d $1 -v -o domains.txt

#running assetfinder
assetfinder -subs-only $1 | tee -a domains.txt

#running findomain
findomain -t $1 | tee -a domains.txt

#running subfinder
subfinder -d $1 -o domains.txt

#removing duplicate entries
sort -u domains.txt -o domains.txt

#checking for alive domains
echo "\n\n[+] Checking for alive domains..\n"
cat domains.txt | httprobe | tee -a alive.txt

#formatting the data to json
cat alive.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > alive.json
cat domains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > domains.json
mkdir -p headers
mkdir -p responsebody

CURRENT_PATH=$(pwd)

for x in $(cat alive.txt)

do
        NAME=$(echo $x | awk -F/ '{print $3}')
        curl -sSL -X GET -H "X-Forwarded-For: evil.com" $x -I > "$CURRENT_PATH/headers/$NAME"
        curl -sSL -X GET -H "X-Forwarded-For: evil.com" -L $x > "$CURRENT_PATH/responsebody/$NAME"

done
