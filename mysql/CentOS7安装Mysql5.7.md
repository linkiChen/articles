### 在CentOS 7上安装Mysql-5.7.23

###### 1.卸载系统自带的Mariadb(如果没有则略过) <br>
[root@node-2 ~]# rpm -qa|grep mariadb <br>
mariadb-libs-5.5.60-1.el7_5.x86_64 <br>
[root@node-2 ~]# rpm -e --nodeps mariadb-libs-5.5.60-1.el7_5.x86_64

###### 2.删除etc目录下的my.cnf文件(如果有的话)
[root@node-2 ~]# rm /etc/my.cnf

###### 3.检查mysql是否存在(如果存在,则进行卸载)
[root@node-2 ~]# rpm -qa|grep mysql

###### 4.检查mysql组和用户是否存在,如果不存在则创建(为mysql创建用户)
[root@node-2 ~]# cat /etc/group |grep mysql   <br>
[root@node-2 ~]# cat /etc/passwd |grep mysql

###### 5.创建mysql用户组

[root@node-2 ~]# groupadd mysql   <br>
创建mysql用户并将此用户加入到mysql用户组  <br>
[root@node-2 ~]# useradd -g mysql mysql <br>
为mysql添加密码  <br>
[root@node-2 ~]# passwd mysql <br>
更改用户 mysql 的密码 。<br>
新的 密码：  <br>
无效的密码： 密码少于 8 个字符 <br>
重新输入新的 密码：  <br>
passwd：所有的身份验证令牌已经成功更新。 <br>

###### 6.将mysql安装到指定目录下,这里安装到/var下
将mysql压缩文件解压  <br>
[root@node-2 ~]# tar -zxvf mysql-5.7.23-linux-glibc2.12-x86_64.tar.gz <br>
将解压后的文件移动到/var下,并重全名主mysql-5.7  <br>
[root@node-2 ~]# mv mysql-5.7.23-linux-glibc2.12-x86_64 /var/mysql-5.7

###### 7.更改mysql-5.7所属的组和用户
[root@node-2 mysql-5.7]# cd /var/ <br>
[root@node-2 var]# chown -R mysql mysql-5.7/  <br>
[root@node-2 var]# chgrp -R mysql mysql-5.7/

###### 8.创建数据库数据的保存文件夹，并更改所属的级和用户
[root@node-2 var]# mkdir -p mysql-5.7/data  <br>
[root@node-2 var]# chown -R mysql:mysql mysql-5.7/data/

###### 9.在/etc下新建配置文件my.cnf，并在该文件内添加以下配置

```
[mysql]
# 设置mysql客户端默认字符集
default-character-set=utf8
[mysqld]
skip-name-resolve
# 设置3306端口
port = 3306
# 设置mysql的安装目录
basedir=/var/mysq-5.7
# 设置mysql数据库的数据的存放目录
datadir=/var/mysq-5.7/data
# 允许最大连接数
max_connections=200
# 服务端使用的字符集默认为8比特编码的latin1字符集
character-set-server=utf8
# 创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
lower_case_table_names=1
max_allowed_packet=16M
# mysql 不允许使用root运行mysql server，所以指定使用mysql用户运行
user=mysql
```

###### 10.安装和初始化mysql
[root@node-2 var]# cd /var/mysql-5.7/bin/ <br>
[root@node-2 bin]# ./mysqld --initialize --user=mysql --basedir=/var/mysql-5.7 --datadir=/var/mysql-5.7/data  <br>
记下安装时打印的带有[Note]的一行信息，因为这里包含了root用户的初始密码  <br>
[Note] A temporary password is generated for root@localhost: lKB>:=fLg7Ea

###### 11.设置mysql的启动项
[root@node-2 bin]# cp ../support-files/mysql.server /etc/init.d/mysqld  <br>
[root@node-2 bin]# chown 777 /etc/my.cnf  <br>
[root@node-2 bin]# chmod +x /etc/init.d/mysqld  <br>

启动mysql就可以使用init.d下的mysqld来操作了  <br>
[root@node-2 bin]# /etc/init.d/mysqld restart <br>

设置开机启动
[root@node-2 bin]# chkconfig --level 35 mysqld on <br>
[root@node-2 bin]# chmod +x /etc/rc.d/init.d/mysqld <br>
[root@node-2 bin]# chkconfig --add mysqld <br>


将mysql bin添加到系统环境中  <br>
[root@node-2 bin]# vi /etc/profile  <br>
	 `export PATH=$PATH:/var/mysql-5.7/bin` <br>
[root@node-2 bin]# source /etc/profile

###### 12.使用root的初始密码登录不了，所以使用另一种方法:
[root@node-2 ~]# mysql -uroot -p  <br>
Enter password: <br>
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)

先在/etc/my.cnf 的[mysqld] 下添加一行参数 <br>
[root@node-2 ~]# vi /etc/my.cnf <br>
	`skip-grant-tables`
重启mysql <br>
[root@node-2 ~]# service mysqld restart <br>
Shutting down MySQL.. SUCCESS!  <br>
Starting MySQL. SUCCESS!  <br>

使用root用户免密登录  <br>
[root@node-2 ~]# mysql -uroot -p  <br>
Enter password: <br>
Welcome to the MySQL monitor.  Commands end with ; or \g. <br>

因为使用了skip-grant-tables,所以还不能直接修改密码  <br>
```
mysql> set PASSWORD=PASSWORD('admin');   
ERROR 1290 (HY000): The MySQL server is running with the --skip-grant-tables option so it cannot execute this statement
mysql>
```

先刷新一下权限 <br>
`mysql> flush privileges;`  <br>
再创建一下root用户或者修改，这里选择创建并授权 <br>
```
mysql> create user 'root'@'%' identified by 'admin';
mysql> grant all privileges on *.* to 'root'@'%';
Query OK, 0 rows affected (0.00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)
```

删除原有的root用户 <br>
`
mysql> delete from user where user='root' and host='localhost';
`

将/etc/my.cnf中的skip-grant-tables注释或者删掉并重启mysql <br>
```
[root@node-2 ~]# service mysqld restart
Shutting down MySQL.. SUCCESS!
Starting MySQL. SUCCESS!  
```
