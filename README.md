awsma
======

AWSMA (AWS Multiple Accounts) is a simple tool to aid DevOps in managing multiple AWS accounts on the CLI. It also includes a tool to create an ssh config file from an AWS account, albiet it is not mature yet. 

Prequisites
-----------

* jq (http://stedolan.github.io/jq/)
* bash 

Installation
------------

   sudo pip install git+git://github.com/Flux7Labs/jamoora.git

You must source mkaws.sh file before you can use mkaws. You can add this to your ~/.bashrc file.

   source mkaws.sh 

Test
----

* To create a new aws client environment 

   mkaws clientX

  mkaws will create a new environment and switch to that environment 


* To leave a client environment 

   deactive 

* To switch to an existing aws client environment 

   workon clientX



