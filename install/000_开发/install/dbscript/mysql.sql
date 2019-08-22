-- version 1.0
--
-- 主机: localhost
-- 服务器版本:
-- CDH


-- 设置密码
-- set password = password('Risk@2018');
-- 授权用户root使用密码passwd从任意主机连接到mysql服务器
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Risk@2018' WITH GRANT OPTION;
flush privileges;

show variables like 'character%';
