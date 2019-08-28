-- version 1.0
--
-- 主机: localhost
-- 服务器版本:
-- CDH


-- 设置密码
-- set password = password('${MYSQL_PWD}');
-- 授权用户root使用密码passwd从任意主机连接到mysql服务器
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_PWD}' WITH GRANT OPTION;

use mysql;

-- update user set host = '%' where user = 'root';

select host,user from user;

flush privileges;

show variables like 'character%';