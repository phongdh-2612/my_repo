#!/bin/bash
# install httpd
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
cat > /var/www/html/index.html <<EOF
<h1>Hello World from $(hostname -f)</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>

EOF
