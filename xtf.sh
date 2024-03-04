function help(){
	

	echo " script usage:"
	echo " xtf [FILTER] [COMMAND] [USER_NAME] [LOG]"
	
}

function list(){
	if [ $# == 3 ]; then
		
		if [[ "$3" == *.gz ]]; then
			zgrep "$2" "$3"
		else
			grep "$2" "$3"
		fi
	
	elif [ $# == 2 ]; then

		if [ "$2" == *.gz ]; then
			zgrep "$1" "$2"
		else 
			grep "$1" "$2"
		fi
	fi
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	if [ $# == 1 ]; then 
		help
	else 
		echo "Unknown command"
	fi
fi




if [ "$1" == "list" ]; then
	
	list "$2" "$3" 
fi




