DROP USER IF EXISTS 'lab7_user'@'%';

CREATE USER 'lab7_user'@'%' 
IDENTIFIED BY '';

GRANT ALL PRIVILEGES 
ON lab7.* 
TO 'lab7_user'@'%';