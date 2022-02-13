# Instructions
### Terraform
* in your terraform file under terraform/terraform.tf change the awsprops to match your known environment. things such as VPC-ID, SUBNET-ID and SSH-KEYNAME
* make sure your awscredentials file is using the absolute path. you will need to create an ssh key in aws and download it or you wont be able to remote into the host at all. Anisble needs this key. 

make sure to initialize your terraform workspace in the /terraform directory by running: 
`terraform init`

run plan to see what it will execute before you go full ham:
`terraform plan`
then when ready
`terraform apply`
review the work you did and watch the system for errors. 


On successful completion an ansible inventory file will be created in the ansible directory

### Ansible
* ansible will ship the entire codebase to the EC2 by design for this demonstration.
* ansible will setup a WSGI flask application using nginx and systemD for managing the app
* ansible can run this from your laptop or work desktop without the need to be networked over a direct connect
* ansible will open up port 80 for proxy requests

navigate to the anisble directory and run the following command:

`ansible-playbook -i inventory.ini playbook.yml --key-file "~/.ssh/mykey.pem"`
 
 * if you have more than one host you are working with you should specify the key in the inventory file that is generated from the terraform template
 
 Once completed you should see the website at your public_ip address on port 80.
