#!/bin/bash

#This Automation Script iterate through all the repos and 
#fetches all the stale branches which are morethan 60 days except master and UAT
#Cleanup all the remote branches (except UAT and master)
#$1 $2 $3 refers to read the credentials and Repositories from the commandline arguments


project=bFO-dev
cd ~
chmod 777 ~
mkdir $project
cd $project
git init
for repo in $3
do
	echo -e "\nYou are on $repo\n"
    git clone https://$1:$2@github.com/$project/$repo.git
    cd $repo
   	
	branchList=$(git branch -r | grep -v master | grep -v UAT | grep -v DEV | sed 's/origin\///')
	echo "$branchList"
	#printf '%s\n' "${branchList[@]}" | wc -w
	
	for branch in $branchList
	do
		echo $branch
		last_updated_date=$(git show -s --format=%ci origin/$branch)
		
		convertDate=$(echo $last_updated_date | cut -d' ' -f 1)
 
		last_updated_date=$(date -d "$convertDate" +'%s')
		
		current=$(date +'%s')
		day=$(( ( $current - $last_updated_date )/60/60/24 ))
		
		if [ "$day" -gt 60 ]; then
			

			echo -e "last commit on ${bold} $branch ${none}branch was $day days ago, deletion required\n\n"
			git push origin --delete $branch
					
		else
			echo -e "This brach is not matching the criteria of 60 days\n"
		fi
	done
	after_count=$(git branch -r | grep -v master | grep -v UAT | grep -v DEV | sed 's/origin\///')
	bc=$(printf '%s\n' "${branchList[@]}" | wc -w)
	ac=$(printf '%s\n' "${after_count[@]}" | wc -w)
	echo -e "-------------------------------------------------------\n"
	echo -e "$repo -> Current num of branches Before Cleanup : $bc"
	echo -e "$repo -> Current num of branches After Cleanup : $ac"	
	echo -e "-------------------------------------------------------\n"
	cd ..
	chmod 777 $repo
	rm -rf $repo
	
done
cd ..
	chmod 777 $project
	#remove .git hidden file and remove the directory
	remove_proj="$( find . -type d -name ".git" | xargs rm -rf )"
	chmod 777 $project
	rmdir $project
exit 