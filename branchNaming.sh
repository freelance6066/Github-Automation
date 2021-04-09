#prehook branch naming convention
LC_ALL=C

local_branch="$(git rev-parse --abbrev-ref HEAD)"
RED='\033[0;1;31m'

valid_branch_regex="^(BFOAC|ACMDM|BFOPROD|EAFS|EASALES|EASP|EACCC|CTIGLOBAL|CCCCHAT|CCCCASE|CCCINT|CCCOCM|GENESYS|BFOFS|SAPFS|WM|ORCLFS|BFOI2P|BFOKNO|bFOS|BFOMOBI|BFOMA|BFOPRM|IC|cIAM|BFOTEC)\-[0-9]+$"

error="Incorrect Branch name-> $local_branch\n 
git branch names must adhere to this format:\n $valid_branch_regex \n

Your commit will be rejected. You should rename your branch to a valid name and try again."

if [[ ! $local_branch =~ $valid_branch_regex ]];then
	
    echo -e "${RED}ERROR:$error"
	exit 1
fi

exit 0