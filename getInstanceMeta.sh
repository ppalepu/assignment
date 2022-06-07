#!/bin/bash

read -p " Please provide instance ID you want to explore: " instId 
echo " What do you want from below?" echo -e "\n" 
echo " 1. Full metadata in JSON format" 
echo " 2. Instance Type" 
echo " 3. Public IP address " 
echo " 4. Launch time " 
echo " 5. Running Status " 
echo " 6. Instance Profile " 
echo "" read -p " Please input your choice number & enter: " choice

case $choice in

"1") aws ec2 describe-instances --region us-west-2 --instance-ids $instId |jq 
  ;; 
"2") aws ec2 describe-instances --region us-west-2 --instance-ids $instId |jq .Reservations[].Instances[].InstanceType 
  ;; 
 "3") aws ec2 describe-instances --region us-west-2 --instance-ids $instId |jq .Reservations[].Instances[].PublicIpAddress 
  ;; 
 "4") aws ec2 describe-instances --region us-west-2 --instance-ids $instId |jq .Reservations[].Instances[].LaunchTime 
  ;; 
 "5") aws ec2 describe-instances --region us-west-2 --instance-ids $instId |jq .Reservations[].Instances[].State.Name
  ;; 
 "6") aws ec2 describe-instances --region us-west-2 --instance-ids $instId |jq .Reservations[].Instances[].IamInstanceProfile.Arn 
  ;; 
  *) echo -e "\n\n ERR! WRONG CHOICE. PLEASE ENTER NUMBER BETWEEN 1 and 6 \n\n\n" 
  esac
