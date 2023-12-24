--use iti
--done1Create a stored procedure to show the total number of students per department
create or alter proc stud_depart 
as
select d.dept_id, count( s.st_id) as total_num
from student s,Department d
where d.dept_id=d.dept_id 
group by d.dept_id
execute stud_depart

--use iti
--done2Create a trigger to prevent anyone from inserting a new record in the Department table. Print a message for the user to tell him that “he can’t insert a new record in that table”
create or alter trigger t_prev
on department  
instead of insert
as
select 'you can’t insert a new record in that table'
insert into Department (Dept_Desc)values('corn')

--use iti
--3done Create a trigger on student table after insert to add Row in a Student Audit table (Server User Name, Date, Note) where the note will be “username Insert New Row with Key=Id in table student”
create table student_audit
(
	Server_User_Name  varchar(100),  
	datee date, 
	Note varchar(100)
)
select SUSER_NAME(),GETDATE()
create or alter trigger t_addrow
on student
after insert
as
begin
insert into student_audit ( Server_User_Name ,  datee , Note )values(SUSER_NAME(),GETDATE(),'username Insert New Row with Key=Id in table student')
end

insert into Student(St_Id,St_Fname) values(344,'sss')
select * from student_audit

--Use CompanySD
--done6Create a trigger that prevents users from altering any table in Company DB
create  or alter trigger t_prevent
on database
for alter_table
as
select 'you cannot alter a table in comany db'
rollback

alter table departments add esraa varchar

--5doneCreate an Audit table with the following structure ProjectNo	UserName ModifiedDate Hours_Old Hours_New
create table auditworks(ProjectNo int,UserName varchar(50),ModifiedDate date,Hours_Old int,Hours_New int)
create trigger th
on works_for
after update
as
begin
if update(hours)
begin
insert into auditworks(ProjectNo ,UserName )values(2,'esraa')
end
end


--explain
update works_for
set hours=30
select *from auditworks 

select * from Works_for
select * from Employee














--4doneCreate a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. The procedure should take 3 parameters (old Emp. SSN, new Emp. SSN and the project number) and it will be used to update works_for table. (use exists)
create or alter proc update_works_for
@old_emp_ssn  int , @new_emp_ssn int , @project_number int 
as 
begin
IF EXISTS (select *from Works_for where @new_emp_ssn=ESSn and  @project_number = Pno ) 
begin
update Works_for 
set @new_emp_ssn=Essn where @old_emp_ssn=ESSn and @project_number = Pno
select 'changed'
end
else 
begin
select 'no changed ' 
end 
end
execute update_works_for