function help(){
	

	echo " script usage:"
	echo " xtf [FILTER] [COMMAND] [USER_NAME] [LOG]"
	
}

function list(){
		
	if [[ "$#" == *.gz ]]; then
		zgrep "$1" "$2"
	else
		grep "$1" "$2"
	fi
	
}





function lcurrency(){
	
	
	all_curr=()

	for line in "$(grep "$1" "$2")"; do
		
		curr=$(echo "$line" | cut -d';' -f3)
		all_curr+=("$curr")

	done
	
	echo "${all_curr[@]}" | sort -u

}


function status(){

	all_curr=()
	all_stats=()
 
	
	while IFS= read -r line; do

		curr=$(echo "$line" | cut -d';' -f3)
		stat=$(echo "$line" | cut -d';' -f3,4)
		
		all_curr+=("$curr")
		all_stats+=("$stat")

	done <<< "$(grep "$1" "$2")"

	

	echo "${all_stats[@]}" | sort
	results=()
	i=0
	j=0

	for c1 in $(echo "${all_curr[@]}" | sort); do
		num1=$(echo "${all_stats[i]}" | cut -d';' -f2)
		results[i]="$num1"
		j=0

		for c2 in $(echo "${all_curr[@]}" | sort); do
			num2=$(echo "${all_stats[j]}" | cut -d';' -f2)

			if [ "$j" -gt "$i" ] && [ "$c1" == "$c2" ]; then
				results[i]=$(echo "${results[i]} + $num2" | bc)

			fi
			
			((j++))
		done
		
		results[i]="${results[i]} : "$c1""$'\n'

		((i++))
	done

	echo $'\n'
	echo "${results[@]}"


}



if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	if [ $# == 1 ]; then 
		help
	else 
		echo "Unknown command"
	fi
fi



if [ $# == 2 ]; then

	list "$1" "$2"
fi


if [ $# == 3 ]; then

	if [ "$1" == "list" ]; then
	
		list "$2" "$3" 
	fi


	if [ "$1" == "list-currency" ]; then
	
		lcurrency "$2" "$3"
	fi

	if [ "$1" == "status" ]; then

		status "$2" "$3"

	fi
fi


