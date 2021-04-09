
#pre-commit hook for Trigger bypass
for t in $trfile;do
	result=$(sed '/\/\*/,/*\//d' $t | grep -vE '^\s*(#|$|//|@|-)' | head -3 | grep -q -i "Utils_SDF_Methodology.canTrigger")
	if [[ $? != 0 ]]; then
	#if ! grep -q -i "Utils_SDF_Methodology.canTrigger" $t; then
		cat <<\EOF
Error: Attempt to add a trigger $t

This can cause problems.

Found trigger without Bypass trigger,Hence rejecting the commit. Please recommit with BYPass
EOF
	#echo "Found validation rule without Bypass Validation rule,Hence rejecting the commit. Please recommit with BYPass";
		git config --get commit.template
		git reset -q HEAD -- .
		git status -z -u
		exit 1;
	fi
done
