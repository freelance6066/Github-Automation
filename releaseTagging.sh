#!/bin/bash

#This Automation Script iterate through all the repos and fetches master and UAT branches based on user's input
#Performs release tagging based on user's input mentioning R4.0 or R4.1

echo -e "Enter your GitHub Usernmae"
read -r user_name
echo -e "Enter your GitHub Token"
read -s token

echo -e "Enter ReleaseID (R4.0 or R4.1):"
read -r releaseID

echo -e "Enter the branch name (master or UAT) for Release tagging:"
read -r branch

echo -e "Enter json file with full path(for ex, /Documents/PersonalRepo/branchCommitse.json):"
read -r file

project=freelance6066
currentYear=$(date +'%Y')
underscore=_
REPOS="$(jq ".repositories[].repoName" branchCommitseUAT.json | cut -d'"' -f 2)"

cd ~
chmod 777 ~
mkdir $project
cd $project
git init
for repo in $REPOS
do
	
			echo -e "\n------You are on $repo for release tagging------\n"
			git clone https://$user_name:$token@github.com/$project/$repo.git
			
			cd $repo
			#Get the branch list based on previous clone
			branchList=$(git branch -r | grep 'master\|UAT$' | sed -e 's,.*/\(.*\),\1,' | sort -u)
		
			for br in $branchList
			do
				
					if [ "$br" == "$branch" ]; then
						git checkout $branch
						#Create release tag format
						releaseTag=$currentYear$underscore$releaseID$underscore$repo$underscore$branch
						echo -e "\nHere is the release tag formed: $releaseTag"
						#Get the latest Commit-ID of the branch
						commitID=$(cat $file | jq --arg keyvar $repo -r '.repositories[] | select( .repoName==$keyvar) | .id')
							
							
							#Create git tag and push tags into remote
							git tag -a $releaseTag $commitID -m "$releaseTag"
							git push --tags
							echo -e "\nTagging has been completed on -> $repo\n\n"
							
						
					fi
				
			done
		
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
