--1 Create a view that shows the project number and name along with the total number of hours worked on each project
create view vproject
as
select  Pname , Pnumber,SUM(Hours) as total_num_of_H
from dbo.Project,dbo.Works_for
where Pnumber=Pno
group by Pname , Pnumber

--2 Create a view that displays the project number and name along with the name of the department managing the project, ordered by project number
create view vpdepart
as
select Pnumber,Pname,Dname
from dbo.Project,dbo.Departments
where dbo.Project.Dnum=dbo.Departments.Dnum
select* from vpdepart
order by Pnumber 
--3 Create a view that shows the project name and location along with the total number of employees working on each project
alter view plocemp
as
select Pname ,Plocation ,count(SSN) as total_num
from  dbo.Project,dbo.Employee
where Dno=Dnum
group by Pname ,Plocation
 --4 Create a view that displays the department number, name, and the number of employees in each department.
 create view departemp
 as
 select Dnum,Dname,count(SSN) as the_num_of_emp
 from dbo.Departments,dbo.Employee
 where Dno=Dnum
 group by Dnum,Dname
 --5 Create a view that shows the names of employees who work on more than one project, along with the count of projects they work on.
 create  view emproject
 as
 select Fname,Lname,count(Pnumber) as count_project
 from dbo.Employee,dbo.Project
 where Dno=Dnum
 group by Fname,Lname
 --6 Create a view that displays the average salary of employees in each department, along with the department name. 
 create  view empdepart
 as
 select avg(salary) as avg_salary ,Dname
 from dbo.Employee , dbo.Departments
 where Dno=Dnum
 group by Dname

 --7 Create a view that lists the names and age of employees and their dependents in a single result set.
create view empdependt
as
select Fname,(year(getdate())-year(Employee.Bdate)) as agemp ,(year(getdate())-year(Dependent.Bdate)) as agedepent ,Dependent_name
from dbo.Employee,dbo.Dependent
where SSN=ESSN


--8 Create a view that displays the names of employees who have dependents, along with the number of dependents each employee has. 
create view empdepentent2
as
select Fname,count(ESSN) as num_of_depents
from dbo.Employee ,dbo.Dependent
where ESSN=SSN
group by Fname , Lname
--9Create a new user defined data type named loc with the following Criteria: 
--nchar(2) 
--default: NY  
--create a rule for this data type : values in (NY,DS,KW)) and associate it to 	the location column in new table named project2 with (name ,location)

create TYPE loc1 from nchar(2) ;
go
create default def as 'NY'
go
create rule R as @x in ('NY','DS','KW')
go
sp_bindrule  R , loc1
go
sp_bindefault  def , loc1
go
create table project3
(
name nchar (2),
location loc1
)



