#!/bin/bash

mentee_submit() {
    local domain=$(head -n 1 "$HOME/domain_pref.txt" | awk '{print $1}') # Assume first preference is the active domain
    local task_dir="$HOME/$domain"
    local task_name="task$1"

    mkdir -p "$task_dir/$task_name"
    echo "$(date): $task_name submitted in $domain" >> "$HOME/task_submitted.txt"

    echo "Task $task_name submitted under $domain."
}

mentor_check() {
    local mentor_domain=$(basename "$HOME")
    local submitted_dir="$HOME/submittedTasks"

    while read mentee; do
        local mentee_home="/home/core/mentees/$mentee"
        local mentee_tasks="$mentee_home/$mentor_domain"

        for task_dir in "$mentee_tasks"/*; do
            local task_name=$(basename "$task_dir")
            ln -s "$task_dir" "$submitted_dir/$task_name-$mentee" 2>/dev/null
            if [ "$(ls -A "$task_dir")" ]; then
                echo "$mentee: $task_name completed" >> "$mentee_home/task_completed.txt"
            fi
        done
    done < "$HOME/allocatedMentees.txt"

    echo "Task checking and linking completed for $mentor_domain."
}

if [[ $USER == mentee* ]]; then
    if [ "$#" -ne 1 ]; then
        echo "Usage: submitTask <task_number>"
        exit 1
    fi
    mentee_submit "$1"
elif [[ $USER == *mentor ]]; then
    mentor_check
else
    echo "This tool is not available for your user type."
fi
