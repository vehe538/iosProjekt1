function help(){
	

	echo " script usage:"
	echo " xtf [FILTER] [COMMAND] [USER_NAME] [LOG]"
	
}

function list(){

	if [ $# == 3 ]; then

		grep "$2" "$3"

	elif [ $# == 2 ]; then
		
		grep "$1" "$2"
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
	
	list $2 $3
fi




