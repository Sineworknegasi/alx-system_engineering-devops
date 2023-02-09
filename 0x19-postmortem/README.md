Postmortem Nginx Server Issue

This is a postmortem document about a server that needed to be fixed because of an error in its configuration.
Issue Summary:
The outage was issued the February 3, 2023, it takes about minutes to be fixed.
The problem was preventing the server from running so the connections were disabled and there was no Nginx service available, so all users were affected even the admins.
Root Cause:
There were 3 main failures in the configuration of the server:
The Nginx configuration files in /etc/nginx/ had no proper user permissions. In order to run a ngix server, the nginx user should be able to access these files with read and write permissions.
The Nginx configuration files didn't have the proper ownership.
In the configuration file /etc/nginx/sites-enabled/default was a bad configuration, usually, the server should allow income connections in port 8080, but it was set to port 80.
There was an Apache process running and using the needed port.
Timeline (format bullet point, format: time - keep it short, 1 or 2 sentences):
The issue was detected February 3, 2023 in the morning, it was detected by verifying the current process running on the server.
I used the ps -auxf command, there was no Nginx process running, also check with sudo service nginx status and the output showed that it was disabled.
Debugging, Actions, and process to fix the Issue:
 First I tried to run the service with the command sudo service nginx start, the server was running but it has problems to work, the connections were not allowed on port 8080. So I stopped the service and changed the configuration file: /etc/nginx/sites-enabled/default.
 I realized that the nginx processes weren’t running from the right user, and checked for the folder permissions, then I changed it, also changed ownership of the configuration folder /etc/nginx/ .
Then, I killed the apache server that was running to avoid conflicts with a special flat to be sure that previous processes with the same name were able.
Finally, restart the nginx service.
Commands used:
sudo chmod uo+rw /etc/nginx/nginx.conf
sudo chown nginx:nginx -R /etc/nginx/
sed -i “s/80/8080/” /etc/nginx/sites-enabled/default
pkill -o apache2
su nginx -c “service nginx restart”
Debugging the services processes was enough to find the problem.
(what parts of the system were investigated, what were the assumption on the root cause of the issue)
Things that can be improved/fixed :
The original configuration of the server should be correctively done set only for nginx server running, not any other web service to avoid conflicts and issues.
When setting nginx ensure the ownership and permissions to be correctly set, the user and group for this is nginx.
List of tasks to address the issue:

Patch nginx server configuration files
 Verify and change permissions and ownership on configuration folder and files.
Kill other web server services running.
