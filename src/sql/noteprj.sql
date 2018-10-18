set names utf8;
drop database if exists noteprj;
create database noteprj charset=utf8;
use noteprj;
create table users(
	userid int primary key auto_increment,
	userName varchar(16) not null,
	userPwd varchar(128) not null,
	loginUid varchar(128) not null,
	loginUkey varchar(128) not null
);
insert into users values
	(null,'北京环威清洁','123456','2341242','fa31fsaf323332ds');

create table notes(
	nid int primary key auto_increment,
	groupid int not null,
	title varchar(16) not null,
	msg varchar(128) not null
);

insert into notes values
	(null,1,'车辆到达','车辆即将到达'),
	(null,1,'特殊天气','车辆即将到达'),
	(null,1,'紧急通知','车辆即将到达'),
	(null,1,'车辆故障','车辆即将到达'),
	(null,1,'指定人员','车辆即将到达');

create table groups(
	gid int primary key auto_increment,
	groupid int not null,
	gname varchar(32) not null
);

create table points(
	pid int primary key auto_increment,
	groupid int not null,
	leader varchar(32) not null,
	phone varchar(32) not null,
	lat varchar(32) not null,
	lon varchar(32) not null,
	addr varchar(32) not null
);

create table vels(
	vid int primary key auto_increment,
	groupid int not null,
	velid int not null,
	vNum varchar(16) not null,
	vKey varchar(128) not null,
	lat float not null,
	lng float not null,
	vState varchar(128) not null,
	vLocation varchar(128) not null,
	vSpeed float not null,
	oldPointId int not null
);

create table news(
	nid int primary key auto_increment,
	new varchar(256) not null,
	currtime DATETIME not null
);
