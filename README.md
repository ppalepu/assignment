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
  
      -> ECR repo 
      -> Elastic Bean stack       
      -> route 53 & UI domain 
      -> Cloudfront distribution
      -> RDS 
      -> apigateway 
      -> lambda 
      -> IAM 
      -> Cloudwatch logging

      Note : This cannot be implemented in the given time
      

   b) Traditional VM based approach:

      -> VPC, subnets 
      -> Staticwebapp on S3 
      -> Cloudfront distribution
      -> route 53 domain 
      -> lambda for api
      -> apigateway for lambda api
      -> DynamoDB/RDS 
      
      Note : Terraform main file is implemented for this approach and it deals with modules. Could not implement finer details of modules in the given time .
      Thats a big task . But based on the main file , my idea on module implementation can be understood.

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

Please refer to getInstanceMeta.sh for the code.   
   
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
	
