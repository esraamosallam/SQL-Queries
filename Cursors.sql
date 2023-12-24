--Use Cursor For the following Problems 
--done Problem 1: Calculate Total Salary for Each Department
--Description: Calculate the total salary for each department and display the department name along with the total salary
DECLARE c1 CURSOR
for
select dname,sum(salary) as total_salay
from employee ,departments
where dnum=dno
group by dname
for read only
declare @dname nvarchar(50),@sal int
open c1
fetch c1 into @dname,@sal
while @@FETCH_STATUS=0
begin
select @dname,@sal
fetch c1 into @dname,@sal
end
close c1
deallocate c1
--Problem 2: Update Employee Salaries Based on Department
--Description: Update employee salaries by increasing them by a certain percentage for a specific department.
declare c2 cursor
for
select e.salary,Dnum
from employee e,departments d
where dnum=dno
for update
declare @sal int,@dnum int
open c2
fetch c2 INTO @sal,  @dnum
while @@FETCH_STATUS=0
begin
if(@dnum=20)
begin
update Employee set salary=salary*1.2
where current of c2
end
fetch c2 INTO @sal,  @dnum
end
close c2
deallocate c2
select salary,dnum from Employee,Departments
--error!!! encrease all

--done Problem 3: Calculate Average Project Hours per Employee
--Description: Calculate the average number of hours each employee has worked on projects, and display their names along with the calculated average hours
declare c3 cursor
for 
select fname,avg(w.hours)
from Employee e, works_for w
where ssn=essn
group by fname
for read only
declare @name nvarchar(50),@avg int
open c3
fetch c3 into  @name,@avg
while @@FETCH_STATUS=0
begin
select @name,@avg
fetch c3 into @name,@avg
end
close c3
deallocate c3
--done Problem 4:  in employee table Check if Gender='M' add 'Mr Befor Employee name    
--else if Gender='F' add Mrs Befor Employee name  then display all names  
--use cursor for update
declare c4 cursor
for
select fname,sex 
from Employee
for update
declare @nam nvarchar (50),@update nvarchar(50)
open c4
fetch c4 into @nam , @update
while @@FETCH_STATUS=0
begin
if(@update='mrm')
begin
update Employee set fname='mr'+fname
where current of c4
end
else
begin
update employee set fname='ms'+fname
where current of c4
end
fetch c4 into @nam, @update
end
close c4
deallocate c4
select sex ,fname from Employee


--Use iti_new
--Index   
--1Create an index on column (Hiredate) that allow u to cluster the data in the table Department. What will happen? 
create clustered index cindex
	on department(manager_hiredate)
--2Create an index that allows you to enter unique ages in the student table. What will happen?  
create unique index uni_index  
on student(st_age)
--create a non-clustered index on column(Dept_Manager) that allows you to enter a unique instructor id in the table Department. 
create unique index uni_index  
on department(dept_manager)


