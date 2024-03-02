function greet(){

	echo "nazdar $1"

}

greet "Mesik"


echo "prvy argument $1"
echo "tolkoto penazi mas $2"

if [ $2 -gt 20 ]; then
	echo "si bohac celkom"
else 
	echo "chudak..."
fi
