-- version 1.0
--
-- 主机: localhost
-- 服务器版本:
-- CDH


-- 为hive建库hive
create database hive DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
-- activity monitor
create database amon DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
-- 为oozie建库oozie
create database oozie DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
-- 为hue建库hue
create database hue DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
create database reports DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
create database navaud DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
create database navmeta DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

show databases;