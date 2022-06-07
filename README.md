**challenge#1:**
**A 3-tier environment is a common setup. Use a tool of your choosing/familiarity create these resources. Please remember we will not be judged on the outcome but more focusing on the approach, style and reproducibility.**

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

3 tier application assumptions:

  -> Assuming an AWS account with admin users are already exists.
  -> Asuuming there is a code reposity and code already exists in the repository for UI and API applications( for maintainance CI/CD)
  -> Going with serverless or managed database to avoid additional maintainance overheads in the project.

Below infrastructure should be created/deployed:

  -> User interface docker micro service
  -> API micro service for backend operations
  -> A database for state

Infrastructure creation on AWS :(IAC) . Either one of the below setups can be used.

  a) Serverless approach:
      -> ecr repo
      -> Elastic Bean stack
      -> fargate
      -> route 53 & UI domain
      -> RDS
      -> apigateway
      -> lambda
      -> IAM

      Note : For code refere to the terraform files and modules in the same repository

   b) Traditional VM based approach:

      -> VPC, subnets , nacls
      -> EC2 , security groups
      -> elastic ip
      -> route 53 domain
      -> RDS

Inaddition to the above we can plan below CI/CD for maintainance of the application set up using any of the below approaches:

   a) Traditional local CI/CD tooling like jenkins and gitlab CI/CD
   b) Cloud Native tooling : AWS code build,codepilne , code deploy.
   
Below is the rough structure of the pipelines we need to create:

   a) CI/CD infra pipeline jenkins/gitlabCI:
      
      A webhook on the repository will be implemented as such whenever there is a commit to the master branch this pipeline gets triggered.
      In this infra repository terraform code related to infrastructure is maintained with backend state so that many people can work on infra 
      changes simultaneously.
      
        stage 1: checkout infra code from the infra repository
        stage 2: AWS authentication from node
        stage 3: IAC plan (terraform plan )
        stage 4: IAC deploy ( terraofrm deploy )

   b) CI/CD maintainance pipeline using jenkins/gitlabCI :
      
      A webhook on the repository will be implemented as such whenever there is a commit to the master branch this pipeline gets triggered.UI and API code is 
      maintained in this repository . Any changes to the code triggers new application docker creation.
      
        stage 1: checkout the code
        stage 2: linter and codecoverage
        stage 3: build 
        stage 4: unit testing
        stage 5: docker image creation
        stage 6: vulnerability scan
        stage 7: Integration testing
        stage 8: image push to nexus
        stage 9: push to ecr
        stage 10: upgrade ecs or ec2 docker-compose
        stage 11: sanity/smoke tests 


**Challenge#2:**
**We need to write code that will query the meta data of an instance within AWS and provide a json formatted output. The choice of language and implementation is up to you.
Bonus Points
The code allows for a particular data key to be retrieved individually**

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


This can be achived with ease using AWS CLI and BASH instead of any functional code/sdk ( unless we need it for integration purposes with existing code base)
Below is a simple shell script to achieve the same.

#!/bin/bash

read -p "      Please provide instance ID you want to explore: " instId
echo  "        What do you want from below?"
  echo -e "\n"
  echo "            1. Full metadata in JSON format"
  echo "            2. Instance Type"
  echo "            3. Public IP address "
  echo "            4. Launch time "
  echo "            5. Running Status   "
  echo "            6. Instance Profile  "
  echo ""
  read -p "      Please input your choice number & enter: " choice

  case $choice in
    "1") aws ec2 describe-instances --region us-west-2   --instance-ids $instId |jq
      ;;
    "2") aws ec2 describe-instances --region us-west-2   --instance-ids $instId |jq .Reservations[].Instances[].InstanceType
      ;;
    "3") aws ec2 describe-instances --region us-west-2   --instance-ids $instId |jq .Reservations[].Instances[].PublicIpAddress
      ;;
    "4") aws ec2 describe-instances --region us-west-2   --instance-ids $instId |jq .Reservations[].Instances[].LaunchTime
      ;;
    "5") aws ec2 describe-instances --region us-west-2   --instance-ids $instId |jq .Reservations[].Instances[].State.Name
      ;;
    "6") aws ec2 describe-instances --region us-west-2   --instance-ids $instId |jq .Reservations[].Instances[].IamInstanceProfile.Arn
      ;;
    *) echo -e "\n\n     ERR! WRONG CHOICE. PLEASE ENTER NUMBER BETWEEN 1 and 6  \n\n\n"
   esac
   
   
Note: This can be enhanced for error handling and nice clours can be added. Also we can easily add additional items data keys to the menu as per the need.   
   
   
**Challenge#3:**
**We have a nested object, we would like a function that you pass in the object and a key and get back the value. How this is implemented is up to you.
Example Inputs
object = {“a”:{“b”:{“c”:”d”}}}
key = a/b/c
object = {“x”:{“y”:{“z”:”a”}}}
key = x/y/z
value = a**

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Please refer to the simple python function created in the same repo (getvalue.py) to achive the above requirement using dictionary data structure.

def get_value(object : dict,key : str) -> str :
    val=object
    for i in key.split('/'): 
     if i!='' :
       try:
         val=val[i]
       except KeyError: # this catch is for wrong key strings
         val="Unknown key string"  
         break
       except TypeError as e: # this catch is for wrong/unexpected objects
         if str(e)=="string indices must be integers" :  
          val="Unexpected object" 
         break 
       except: # this is for rest all unknown errors
         val="Error"  
         print("Unknown Error")
         break  
     else: # this is for keys having extra backslash at the end
      val="wrong key standards"    
    return val  
	
some edge cases that i can think of :

 a) Input : object= {"a":{"b":{"c":"d"}}} key='a/b/'
   Output: "wrong key standards"
 b) Input: object= {"a":{"b":{"c":"d"}}} key='a/b'
   Output: {"c":"d"}
 c) Input: object= {"a":{"b":{"c":"d"}}} key='a/b/y'
   Output: "Unknown key string"
 d) Input: object= {"a":{"b":"c"}} key='a/b/c'
   Output: "Unexpected object" 
 e) Input: object= {"a":{"b":{"c":"d"}}} key='x/y/z' 
   Output: "Unknown key string"
	
