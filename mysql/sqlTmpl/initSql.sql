GRANT USAGE ON *.* TO 'root'@'%' IDENTIFIED BY ${PASSWORD} WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY ${PASSWORD};