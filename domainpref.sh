#!/bin/bash

mentee_home=$(getent passwd "$USER" | cut -d: -f6)
domain_pref_file="$mentee_home/domain_pref.txt"
core_mentees_file="/home/core/mentees_domain.txt" 

echo "Enter up to three domain preferences (e.g., Webdev, Appdev, Sysad), separated by spaces:"
read -a domains

echo "Your domain preferences are: ${domains[@]}" > "$domain_pref_file"

echo "$USER: ${domains[@]}" >> "$core_mentees_file"

for domain in "${domains[@]}"; do
    mkdir -p "$mentee_home/$domain"
done

