#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Error: Please provide exactly 3 arguments."
    echo "Usage: $0 <index_file_extension> <root_directory_name> <host_url>"
    exit 1
fi

sudo echo "server {
	
	listen 80;

	root /var/www/html/$2;
	index index.$1;
	server_name $3;

	client_max_body_size 1024M;

	location / {
		add_header Access-Control-Allow-Origin \"http://$3\";
		try_files \$uri \$uri/ \$uri.$1?\$query_string;

			proxy_connect_timeout 6000s;
    		proxy_read_timeout    6000s;
    		proxy_send_timeout    6000s;
        }
	
	location /reply/ {
       		 rewrite ^/reply/id/(\d+)$ /reply?id=\$1 last;
   	}

	location /app/ {
		proxy_pass http://localhost:6001;
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection 'upgrade';
		proxy_set_header Host \$host;
		proxy_cache_bypass \$http_upgrade;
	}

	location ~ \.php$ {
		# With php-fpm unix sockets
		fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
		include         fastcgi_params;
		fastcgi_param   SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;
		fastcgi_param   SCRIPT_NAME        \$fastcgi_script_name;
		proxy_read_timeout 600s;
	
	}

}" > /etc/nginx/sites-available/$3.conf

sudo ln -s /etc/nginx/sites-available/$3.conf /etc/nginx/sites-enabled/
# Append the new entry to the /etc/hosts file
sudo echo "127.0.0.1 $3" | sudo tee -a /etc/hosts
# restart nginx service
sudo service nginx restart
