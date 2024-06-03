#!/bin/bash

core_user="core"

useradd -m "$core_user"

core_home=$(getent passwd "$core_user" | cut -d: -f6)
mkdir -p "$core_home/mentors" "$core_home/mentees"

for domain in Webdev Appdev Sysad; do
    mkdir -p "$core_home/mentors/$domain"
    mentor_user="${domain,,}_mentor"
    useradd -m -d "$core_home/mentors/$domain/$mentor_user" -s /bin/bash "$mentor_user"
    mkdir -p "$core_home/mentors/$domain/$mentor_user/submittedTasks/task1" \
             "$core_home/mentors/$domain/$mentor_user/submittedTasks/task2" \
             "$core_home/mentors/$domain/$mentor_user/submittedTasks/task3"
    touch "$core_home/mentors/$domain/$mentor_user/allocatedMentees.txt"
    chmod -R 700 "$core_home/mentors/$domain/$mentor_user"
done

for i in {1..10}; do
    mentee_user="mentee$i"
    useradd -m -d "$core_home/mentees/$mentee_user" -s /bin/bash "$mentee_user"
    touch "$core_home/mentees/$mentee_user/domain_pref.txt" \
          "$core_home/mentees/$mentee_user/task_completed.txt" \
          "$core_home/mentees/$mentee_user/task_submitted.txt"
    chmod -R 700 "$core_home/mentees/$mentee_user"
done

chmod -R 750 "$core_home/mentors"
chmod -R 750 "$core_home/mentees"
setfacl -m u:$core_user:rwx "$core_home/mentors" "$core_home/mentees"

touch "$core_home/mentees_domain.txt"
chmod 622 "$core_home/mentees_domain.txt"
setfacl -m u:$core_user:rw "$core_home/mentees_domain.txt"
setfacl -m u::--- "$core_home/mentees_domain.txt" 
for mentee_user in "$core_home/mentees/"*; do
    setfacl -m u:"$(basename "$mentee_user")":w "$core_home/mentees_domain.txt"
done

