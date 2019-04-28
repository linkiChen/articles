##### 在CentOS 7上以rpm方式安装MySql 5.7

###### 1.下载MySql rpm包
https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.26-1.el7.x86_64.rpm-bundle.tar  <br>
将下载好的tar包上传到CentOS中 <br>

###### 2.安装MySql rpm的语言支持
[root@node-1 ~]# yum install -y perl

###### 3.安装MySql
由于rpm安装不仅仅是只有一个rpm文件，这几个rpm之间有依赖关系，所以需要按顺序执行如下的包安装  <br>
[root@node-1 ~]# rpm -ivh mysql-community-common-5.7.26-1.el7.x86_64.rpm  <br>
[root@node-1 ~]# rpm -ivh mysql-community-libs-5.7.26-1.el7.x86_64.rpm  <br>
[root@node-1 ~]# rpm -ivh mysql-community-client-5.7.26-1.el7.x86_64.rpm  <br>
[root@node-1 ~]# rpm -ivh mysql-community-server-5.7.26-1.el7.x86_64.rpm  <br>

执行完成后，MySQL就安装成功了，需要注意的是关于Mysql的几个目录：<br>
- 数据库目录：/var/lib/mysql/
- 命令配置：/usr/share/mysql/ (mysql.server命令及配置文件)
- 相关命令：/usr/bin (mysqladmin mysqldump等命令)
- 启动脚本：/etc/rc.d/init.d/ (启动脚本文件mysql的目录)
- 系统配置：/etc/my.cnf

###### 4.运行Mysql
Mysql安装完成后，可以通过如下命令启动Mysql  <br>
[root@node-1 ~]# systemctl start mysqld.service <br>

查看root用户的随机初始密码:  <br>
[root@node-1 ~]# /var/log/mysqld.log  <br>
找到如下信息，'localhost:'后的即是随机密码，可使用此密码登录mysql <br>
`A temporary password is generated for root@localhost: Gs=3jwGKauB0`
<br><br>
登录mysql并修改初始密码： <br>
[root@node-1 mysql-5.7.26]# mysql -uroot -p   <br>
Enter password:   <br>
mysql> set password = password('admin');_
<br><br>
设置远程访问  <br>
mysql> grant all privileges on *.* to 'root' @'%' identified by '123456'; <br>
mysql> flush privileges;

###### 5.密码设置
由于Mysql的默认用户密码策略限制，所以不能使用简单密码，我们可以通过修改密码验证策略来达到使用简单密码的目的  <br><br>
查看初始的密码策略 <br>
mysql> SHOW VARIABLES LIKE 'validate_password%';  <br>
<br>
修改密码验证强度： <br>
mysql> set global validate_password_policy=LOW; <br>

LOW的密码验证策略还是会限制密码找度为8,可以通过以下语句修改长度的验证:  <br>
mysql> set global validate_password_length=6;
