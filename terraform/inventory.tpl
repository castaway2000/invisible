[web]
%{ for ip in webservers ~}

[web:vars]
ansible_python_interpreter=/usr/bin/python3.8