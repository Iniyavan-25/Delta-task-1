#!/bin/bash

core_home="/home/core"

declare -A mentor_capacities
while IFS=',' read -r mentor capacity; do
    mentor_home="$core_home/mentors/${mentor}/$(echo $mentor | tr '[:upper:]' '[:lower:]')_mentor"
    mentor_capacities[$mentor]=$capacity
    > "$mentor_home/allocatedMentees.txt"  
done < "$core_home/mentorDetails.txt"

allocate_mentee () {
    local mentee=$1
    local preference=$2
    local mentor_home="$core_home/mentors/${preference}/$(echo $preference | tr '[:upper:]' '[:lower:]')_mentor"
    local allocated_file="$mentor_home/allocatedMentees.txt"

    if [[ ${mentor_capacities[$preference]} -gt 0 ]]; then
        echo "$mentee" >> "$allocated_file"
        mentor_capacities[$preference]=$((mentor_capacities[$preference]-1))
        return 0
    fi
    return 1
}

for mentee_dir in $core_home/mentees/*; do
    mentee=$(basename "$mentee_dir")
    IFS=' ' read -ra prefs <<< "$(cat "$mentee_dir/domain_pref.txt")"
    for pref in "${prefs[@]}"; do
        allocate_mentee "$mentee" "$pref" && break
    done
done

