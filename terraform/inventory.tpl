[web]
%{ for ip in webservers ~}
${ip}
%{ endfor }
[web:vars]
ansible_python_interpreter=/usr/bin/python3.8
ansible_ssh_user=ubuntu