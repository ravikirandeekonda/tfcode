#!/bin/bash
# This script is run as the root user on the instance when it first boots.
# It is responsible for setting up the instance to run the compute service.
# This script is called from the cloud-init user data script.

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y python3 python3-pip
sudo apt install -y git
sudo apt install docker.io -y
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Compute Service</title>
</head>
<body>
<h1>Compute Service</h1>
<p>This is the compute service.</p>
</body>
</html>
EOF
sudo systemctl restart apache2
sudo systemctl enable docker

