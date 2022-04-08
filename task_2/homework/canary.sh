#!/bin/bash
for i in {1..10}
do

# Проверка canary deployment ingress percent 
test=$(curl --silent http://127.0.0.1 | grep head)

# Проверка canary: always
# test=$(curl -H "canary: always" --silent http://127.0.0.1 | grep head)
echo $test
done