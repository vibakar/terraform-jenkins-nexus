### Jekins and Nexus

These terraform files provision ec2 servers and installs jenkins and nexus

Note: Add terraform.tfvars file and include tokens like below in order to run terraform

```
AWS_ACCESS_KEY = "XXXXXXXXXXXXXXXX"
AWS_SECRET_KEY = "XXXXXXXXXXXXXXXX"
```

Also make sure public key is available in this path ```~/.ssh/id_rsa.pub``` or change the path in the variable file
