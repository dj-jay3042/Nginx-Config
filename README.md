# Nginx Configurator Script

This script automates the process of creating Nginx server configurations for a given web application. It also updates the `/etc/hosts` file with the specified host URL.

## Prerequisites

- Ensure that you have sudo privileges to execute the script.
- The script assumes that you have Nginx installed on your system.

## Usage

```bash
./nginx_configurator.sh <index_file_extension> <root_directory_name> <host_url>

