#!/bin/bash

none='\033[00m'
bold='\033[1m'

branch_list=$(git branch -r | grep -v master | grep -v UAT | sed 's/origin\///')
repo_name=$(git config --local remote.origin.url|sed -n 's#.*/\([^.]*\)\.git#\1#p')
echo -e "\nYou are on ${bold}$repo_name${none}\n"
echo -e "\nAvailable Branches :"	
echo -e "${branch_list[*]}\n"
for branch in $branch_list
do
 echo $branch
 last_updated_date=$(git show -s --format=%ci origin/$branch)
 #echo -e "\n$last_updated_date"
 convertDate=$(echo $last_updated_date | cut -d' ' -f 1)
 
 last_updated_date=$(date -d "$convertDate" +'%s')
 #echo -e "\n$last_updated_date\n"
 current=$(date +'%s')
 day=$(( ( $current - $last_updated_date )/60/60/24 ))
 echo -e "last commit on ${bold} $branch ${none}branch was $day days ago\n"
 if [ "$day" -gt 60 ]; then
        
			git push origin :$branch
		
 else
	echo -e "There are no braches matching the criteria of 60 days"
 fi
done
