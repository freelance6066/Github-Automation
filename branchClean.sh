#! /bin/bash

echo "Enter Org Name"
read -r org_name
echo "Enter repo"
read -r repo_name
echo "Enter Username"
read -r user_name
echo "Enter Personal Auth Token"
read -s token

branch_list=$(curl -s -u $user_name:$token https://api.github.com/repos/$org_name/$repo_name/branches | jq '.[].name'|grep -iv 'UAT*\|master')
echo -e "${branch_list[*]}\n"

for branch in $branch_list;do
	api_branch_name=$(echo $branch | cut -d'"' -f 2)
	echo -e "\n\n\*********************"$api_branch_name"*********************"
	
	last_updated_date=$(curl -s -u $user_name:$token https://api.github.com/repos/$org_name/$repo_name/branches/$api_branch_name | jq '.commit.commit.author.date')
	
	api_last_updated_date=$(echo $last_updated_date | cut -d'"' -f 2)
	
	current_date=$(date +'%s')
	echo -e "\n\nPresent DATE $(date) IN SECONDS::"$current_date"\n"
	last_updated_date_sec=$(date --date "$api_last_updated_date" +'%s')
	echo -e "Branch Last Updated DATE $api_last_updated_date IN SECONDS--->"$last_updated_date_sec"\n\n"
	
	num_of_days=$((($current_date - $last_updated_date_sec)/(60*60*24)))
	
	
	if [ "$num_of_days" -gt 20 ];
	then
	echo -e "Branch-> $api_branch_name is updated $num_of_days days ago\n"
	
	fi
done
