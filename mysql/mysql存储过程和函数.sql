/*存储过程和函数

一、存储过程
1 含义：一组预先编译好的SQL语句的集合，可理解成批处理语句
  - 提高代码的重用性
  - 简化操作
  - 减少了编译次数，并且减少了和数据库服务器的连接次数，提高了效率

2 创建语法
CREATE PROCEDURE 存储过程名(参数列表)
BEGIN
  存储过程体(合法的SQL语句)
END

2.1 参数类型：
  - IN：该参数可以作为输入，也就是该参数需要调用方传入值
  - OUT：该参数可以作为输出，也就是该参数可以作为返回值
  - INOUT：即可作为输入参数，也可作为输出参数

2.2 如果存储过程体仅仅只有一句话，BEGIN END可以省略，存储过程体中的每条SQL语句的结尾要求必须加分号
    存储过程的结尾可以使用DELIMITER重新设置  如：
    delimiter 结束标记
*/

# 空参数存储过程
CREATE PROCEDURE procedure_01()
BEGIN
	INSERT INTO jobs VALUES('JAVA_DEV','Java developer',6000,30000);
END

# 调用
CALL procedure_01()

# 带IN类型参数
CREATE PROCEDURE procedure_02(IN jobId varchar(10)) 
BEGIN
	SELECT * FROM jobs WHERE job_id = jobId;
END

CALL procedure_02('HR_REP')

# 带IN类型参数，并使用变量
CREATE PROCEDURE procedure_03(IN job_id varchar(10))
BEGIN
	DECLARE result varchar(50); # 声明一个变量
	select job_title INTO result FROM jobs WHERE jobs.job_id = job_id;
	SELECT result;
END

CALL procedure_03('HR_REP');

# 带OUT类型的参数
CREATE PROCEDURE procedure_04(IN job_id varchar(10),OUT jt VARCHAR(50))
BEGIN
	SELECT job_title INTO jt FROM jobs WHERE jobs.job_id = job_id;
END

# SET @job_title; # 可以不声明变量而直接使用
CALL procedure_04('HR_REP',@job_title);
SELECT @job_title;
