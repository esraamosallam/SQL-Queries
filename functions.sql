--1 Create Scalar function name GetEmployeeSupervisor Type: Scalar Description: Returns the name of an employee's supervisor based on their SSN

create or alter function GetEmployeeSuperviso(@SSN int)
returns varchar(20)
  begin 
    DECLARE @name VARCHAR(20)
       SELECT @name = s.Fname
	   FROM Employee e ,Employee s
	   WHERE  e.SSN  = @ssn and e.Superssn= s.SSN
	   RETURN @name
  end 
  select dbo.GetEmployeeSuperviso(112233)

---2Create Inline Table-Valued Function GetHighSalaryEmployees 
--Description: Returns a table of employees with salaries higher than a specified amount. 
 

create OR ALTER function GetHighSalaryEmployees(@no int)
returns table
as
return
(
 SELECT e.Fname
 FROM Employee e
 WHERE e.Salary > @no
)

select * from GetHighSalaryEmployees(800)

--3Create function with name GetTotalSalary Type: Scalar Function Description: Calculates and returns the total salary of all employees in the specified department
CREATE or alter FUNCTION GetTotalSalary (@department int)
RETURNS int
AS
BEGIN
    DECLARE @totalSalary int

    SELECT @totalSalary = SUM(e.Salary)
    FROM Employee e ,Departments d
    WHERE d.Dnum = @department and e.Dno=d.Dnum

    RETURN @totalSalary
END
select dbo.GetTotalSalary(30)


---4Create function with GetDepartmentManager Type: Inline Table-Valued Function Description: Returns the manager's name and details for a specific department

create  OR ALTER function GetDepartmentManager(@dbmanger int)
returns table
as 
return 
(select e.Fname ,d.Dname,d.MGRSSN,d.[MGRStart Date]
 FROM Employee e,Departments d
 WHERE d.MGRSSN=e.SSN and d.Dnum=@dbmanger
)
SELECT * FROM GetDepartmentManager(10)

---5Create multi-statements table-valued function that takes a string parameter 
--If string='first name' returns student first name 
--If string='last name' returns student last name  
--If string='full name' returns Full Name from student table  
--Note: Use “ISNULL()” function 
create or alter function GetStudentss(@format varchar(10))
returns @t table (ename varchar(30))
as
 BEGIN
     IF @format = 'first name'
	 BEGIN 
		 INSERT @t 
		 SELECT isnull( s.St_Fname,'not found')
		 FROM Student s
      END
    ELSE IF @format = 'last name'
	 BEGIN 
		 INSERT @t 
		 SELECT isnull(s.St_Lname,'not found')
		 FROM Student s
      END
	  ELSE IF  @format = 'full name'
      BEGIN 
		 INSERT @t 
		 SELECT  isnull(s.St_Fname+' '+ s.St_Lname,'not found')
		 FROM Student s
      END

	 RETURN
 end

 select * from GetStudentss('first name')
   
---6 Table-Valued Function - Get Instructors with Null Evaluation: This function returns a table containing the details of instructors who have null evaluations for any course
create or alter function GetInstructorss()
returns @t table(ename varchar(30))
as
begin
INSERT @t
select i.Ins_Name 
from Instructor i ,Ins_Course c
where  i.Ins_Id=c.Ins_Id and c.Evaluation is null
RETURN
end

select* from GetInstructorss()
 
 --7Table-Valued Function - Get Top Students: This function returns a table containing the top students based on their average grades
 create or alter function  GetTopStudents()
returns @t table(D INT,ename varchar(30))
as
begin
INSERT @t
select TOP 2 AVG (C.Grade),S.St_Fname
from Student s ,Stud_Course C
where S.St_Id=C.St_Id
group by s.St_Fname
order by AVG (C.Grade) desc
RETURN
end

select* from GetTopStudents()

---8Table-Valued Function - Get Students without Courses: This function returns a table containing details of students who are not registered for any course
--Table-Valued Function - Get Students without Courses: 
--This function returns a table containing details of
--students who are not registered for any course.
 
create or alter function  GetStudentswithoutCourses()
returns @t table(ename varchar(30))
as
begin
INSERT @t
select S.St_Fname
from Student s
where s.St_Fname not in( select s.St_Fname from Student s ,Stud_Course C where s.St_Id=c.St_Id)
RETURN
end

select* from GetStudentswithoutCourses()