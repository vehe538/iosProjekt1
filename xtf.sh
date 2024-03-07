function help(){
	

	echo " script usage:"
	echo " xtf [FILTER] [COMMAND] [USER_NAME] [LOG]"
	
}

function list(){
		
	if [[ "$2" == *.gz ]]; then
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

function profit(){
	
	if ! [[ -v XTF_PROFIT ]]; then
		XTF_PROFIT=20
	fi

	mapfile -t stats < <(status "$1" "$2")

	for p in "${stats[@]}"; do
		num=$(echo "$p" | cut -d' ' -f3)
		curr=$(echo "$p" | cut -d' ' -f1)
		
		
		p=$(echo "0.$XTF_PROFIT")

			
		if (( $(echo "$num > 0" | bc -l) )); then
			num=$(echo "$num + $num * $p" | bc)
			echo "$curr : $num"
		else 
			echo "$curr : $num"	
		fi
	done
}


function status(){

	all_curr=()
	all_stats=()


	if [ "$2" == *.gz ]; then
		
		
		while IFS= read -r line; do

			curr=$(echo "$line" | cut -d';' -f3)
			stat=$(echo "$line" | cut -d';' -f3,4)
		
			all_curr+=("$curr")
			all_stats+=("$stat")

		done <<< "$(zgrep "$1" "$2")"
	

	else 

		while IFS= read -r line; do

			curr=$(echo "$line" | cut -d';' -f3)
			stat=$(echo "$line" | cut -d';' -f3,4)
		
			all_curr+=("$curr")
			all_stats+=("$stat")

		done <<< "$(grep "$1" "$2")"
	fi


	all_stats=($(for element in "${all_stats[@]}"; do echo "$element"; done | sort))
	all_curr=($(for element in "${all_curr[@]}"; do echo "$element"; done | sort))	

	results=()
	i=0
	j=0

	for c1 in "${all_curr[@]}"; do
		num1=$(echo "${all_stats[i]}" | cut -d';' -f2)
		
		j=0
		for c2 in "${all_curr[@]}"; do
			num2=$(echo "${all_stats[j]}" | cut -d';' -f2)
			

			if [ "$i" != "$j" ] && [ "$c1" == "$c2" ]; then
				num1=$(echo "$num1 + $num2" | bc)
		
			fi
			
			((j++))
		done
		
		if [ "$i" == $(echo "${#all_stats[@]}-1" | bc) ]; then
			results+="$c1 : $num1"
		else
			results+="$c1 : "$num1""$'\n'
		fi		
			
		((i++))
	
	done

	echo "${results[@]}" | uniq


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

	if [ "$1" == "profit" ]; then
	
		profit "$2" "$3"
	fi
fi

if [ $# == 5 ]; then
	
	date="$2 $3"

	if [ "$1" == "-a" ]; then
		
		for line in $(list $4 $5 | cut -d'\n'); do
			echo "$line"
		done
	fi
fi


