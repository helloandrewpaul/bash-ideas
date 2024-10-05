#!/bin/bash

domain=$1

RED="\033[1;31m"
RESET="\033[0m"

base_dir="$domain"
info_path="$base_dir/info"
subdomain_path="$base_dir/subdomains"
screenshot_path="$base_dir/screenshots"

for path in "$info_path" "$subdomain_path" "$screenshot_path"; do
    if [ ! -d "$path" ]; then
        mkdir -p "$path"
        echo "Created directory: $path"

    fi
done

echo -e "${RED} [+] Checking who it is... ${RESET}"
whois "$domain" > "$info_path/whois.txt"

echo -e "${RED} [+] Launching subfinder... ${RESET}"
subfinder -d "$domain" > "$subdomain_path/found.txt"

echo -e "${RED} [+] Checking what's alive... ${RESET}"
cat "$subdomain_path/found.txt" | grep "$domain" | sort -u | httprobe -prefer-https | grep https | sed 's/https\?:\/\///' | tee -a "$subdomain_path/alive.txt"

echo -e "${RED} [+] Taking screenshots... ${RESET}"
gowitness scan file -f "$subdomain_path/alive.txt" --screenshot-path "$screenshot_path/" --no-http