/**
	常见函数(内置的)

	调用：SELECT 函数名(实参列表) [FROM 表];
		特点：
			1. 叫什么(函数名)
			2. 干什么(函数功能)
		分类：
			1. 单行函数
			如：concat、length、ifnull等
			2. 分组函数
			功能：做统计使用，又称为统计函数、聚合函数、组函数
**/

-- -----------------------------------------------------------------------------------
# 一、字符函数
# 1. length 获取参数值的字节数,注意(汉字)不同的字符集长度不同,
# 可通过 SHOW VARIABLES LIKE '%CHARACTER%'; 查看服务器及客户端的字符集
SELECT LENGTH('john') as john_len;

# 2. CONCAT(str1,str2,...) 拼接字符串
SELECT CONCAT(last_name,'-',first_name) 姓名 FROM employees;

# 3. UPPER(str) LOWER(str) 大小写转换
SELECT UPPER('jacky') up;
SELECT LOWER('LEO') low;

# 4. SUBSTR,SUBSTRING 这两个函数都有四个重载的方法
SELECT SUBSTR('This is MYSQL func learn' FROM 9 FOR 5) out_put;
SELECT SUBSTRING('This is MYSQL func learn' FROM 6 FOR 2) AS out_put;

# 5. INSTR(str,substr) 返回子串第一次出现的索引，如果找不到就返回0
SELECT INSTR('My name is Jacky','name') idx;
SELECT INSTR('My name is Jacky','Leo') idx;

# 6. TRIM([remstr FROM] str)
SELECT LENGTH(TRIM(' leo ')) tr;
SELECT TRIM('a' FROM 'aaaaa leo aa jacky aaaa') tr;

# 7. LPAD(str,len,padstr)、RPAD(str,len,padstr) 左右填充

# 8. `REPLACE`(str,from_str,to_str) 替换
SELECT REPLACE('My name is leo','leo','jacky') rep;

-- -----------------------------------------------------------------------------------

# 二、数学函数
# ROUND(x)、ROUND(x,d) 四舍五入
SELECT ROUND(-1.55) rou;
SELECT ROUND(1.567,2) rou;

# CEIL(X) 向上取整，返回>= 该参数的最小整数
SELECT CEIL(-1.02) ceil;

# FLOOR(X)向下取整，返回<=该参数的最大整数
SELECT FLOOR(-9.78) flo;

# TRUNCATE(X,D) 截断
SELECT TRUNCATE(2.463,2) trun;

# MOD(N,M) 取余
SELECT MOD(12,5) m;

-- -----------------------------------------------------------------------------------

# 三、日期函数
# NOW() 返回服务器当前日期+时间
SELECT NOW() now;

# CURDATE() 返回服务器当前日期
SELECT CURDATE() cd;

# CURTIME() 返回服务器当前时间
SELECT CURTIME() ct;

# YEAR(date)、YEAR_xxx() 获取指定日期的年、月、日、小时...
SELECT YEAR(now()) y;
SELECT YEAR('2018-2-28') Y;

SELECT YEARWEEK(NOW()) YW;

SELECT MONTHNAME(NOW()) MN;

# STR_TO_DATE(str,format)将合法的日期字符串按指定格式转换为日期
#	格式符		功能
#	%Y				四位的年份
#	%y				两个的年份
#	%m				两个的月份
#	%c				一位/两位的月份
# %d				日
#	%H				24小时制的小时
#	%h				12小时制的小时
#	%i				分钟
#	%s				秒
SELECT str_to_date('2019-04-29 22:30:30','%Y-%m-%d') std;

# DATE_FORMAT(date,format) 将日期转换为指定格式的字符串
SELECT DATE_FORMAT(NOW(),'%Y/%m/%d') df;

-- -----------------------------------------------------------------------------------

# 四、其他函数
# VERSION() `DATABASE`() `USER`()
SELECT VERSION() v;
SELECT DATABASE() db;
SELECT USER() usr;

-- -----------------------------------------------------------------------------------
# 五、流程控制函数
# IF(expr1,expr2,expr3)、 IF ELSE的效果

SELECT IF(3>5,'3大于5','3小于5') jug;

# CASE 1
/*
	CASE 要判断的字段或表达式
	WHEN 常量1 THEN 要显示的值或语句
	WHEN 常量2 THEN 要显示的值或语句
	...
	ELSE 要显示的值或语句
	END
*/
/*查询员工的工资，要求
	部门=30，显示的工资为1.1倍
	部门=40，显示的工资为1.2倍	
	部门=50，显示的工资为1.3倍
	其他部门，显示原工资
*/
SELECT salary,department_id,
CASE department_id
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary
END as 最终工资
FROM employees;

# CASE 2
/*
	CASE
	WHEN 条件1 THEN 要显示的值或语句
	WHEN 条件2 THEN 要显示的值或语句
	WHEN 条件3 THEN 要显示的值或语句
	ELSE 要显示的值或语句
	END
*/
/*
	查询员工工资情况
	如果工资>20000，显示A级
	如果工资>15000，显示B级
	如果工资>10000，显示C级
	否则	显示D级
*/

SELECT salary,
CASE 
WHEN salary > 20000 THEN 'A'
WHEN salary > 15000 THEN 'B'
WHEN salary > 10000 THEN 'C'
ELSE 'D'
END AS 工资级别
FROM employees;
