for i in {1..15}
do 
test=$(curl --silent http://localhost:31865 | grep head)
echo $test
done