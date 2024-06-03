#!/bin/bash

# Directory paths
core_home="/home/core"
mentees_dir="$core_home/mentees"

display_status() {
    local domain_filter=$1
    local mentees_total=$(ls -l $mentees_dir | grep '^d' | wc -l)

    echo "Task Submission Status:"

    for task in task1 task2 task3; do
        local mentee_count=0
        local mentee_list=()

        for mentee_home in $mentees_dir/*; do
            if [ -n "$domain_filter" ] && [ ! -d "$mentee_home/$domain_filter" ]; then
                continue
            fi

            if [ -d "$mentee_home/$domain_filter/$task" ]; then
                if [ "$(ls -A $mentee_home/$domain_filter/$task)" ]; then
                    mentee_count=$((mentee_count+1))
                    mentee_list+=("$(basename $mentee_home)")
                fi
            fi
        done

        local submission_rate=$(echo "scale=2; $mentee_count / $mentees_total * 100" | bc)
        echo -e "\n$task - $submission_rate% submitted"
        echo "Mentees who submitted $task:"
        for mentee in "${mentee_list[@]}"; do
            echo "$mentee"
        done
    done
}

if [ $# -eq 1 ]; then
    display_status "$1"
else
    display_status
fi
