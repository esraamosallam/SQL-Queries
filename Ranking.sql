--1
--Identifying the Top Instructors by Average Evaluation Score: 

--*Run these queries first: 

--1)alter table Ins_Course add  evaluation_int int :

alter table Ins_Course  
add evaluation_int int 
select*from Ins_Course  

--2)update Ins_Course set evaluation_int =100 where evaluation='Good'  
update Ins_Course 
set evaluation_int =100 where evaluation='Good'
select*from Ins_Course 

--3)update Ins_Course set evaluation_int =200 where evaluation='VGood'
update Ins_Course 
set evaluation_int =200 where evaluation='VGood'
select*from Ins_Course 

--4)update Ins_Course set evaluation_int =400 where evaluation='Distinct' 
update Ins_Course 
set evaluation_int =400 where evaluation='Distinct'
select*from Ins_Course 

--*Use the "Ins_Course" table to calculate the average evaluation score for each instructor. 
select*from Ins_Course 

SELECT Ins_Id , AVG (evaluation_int) as [Average evaluation score]
FROM Ins_Course
group by Ins_Id

-- *Rank the instructors based on their average evaluation scores and identify the top instructors with the highest scores.

with cte 
as (
SELECT * , AVG (evaluation_int) over (PARTITION BY Ins_Id) as [Average evaluation score]   
FROM Ins_Course 
  
) 

SELECT *, RANK() OVER( ORDER BY [Average evaluation score]desc) AS ranking

FROM cte 


--select * , ROW_NUMBER() over (order by evaluation_int desc) as RN
--from Ins_Course 

--2
--Identifying the Top Topics by the Number of Courses: 

--1)Use the "Topic" and "Course" tables to count the number of courses available for each topic. 
select*from Course c
select * from Topic t 

select  t.Top_Id , COUNT(c.Crs_Id) AS [Number Of cources]
from Course c , Topic t  
where c.Top_Id=t.Top_Id
group by  t.Top_Id


--2)Rank the topics based on the count of courses and identify the most popular topics with the highest number of courses.
with cte 
as 
( 
select distinct t.Top_Id , COUNT(c.Crs_Id) over (PARTITION BY t.Top_Id ) as [Number_Of_cources]
from Topic t , Course c 
where c.Top_Id=t.Top_Id
)

select * , DENSE_RANK() over (order by Number_Of_cources desc) as DR
from cte


--3)Finding Students with the Highest Overall Grades: 

--Use the "Stud_Course" table to calculate the total grades for each student across all courses. 

select * from Stud_Course 

SELECT Crs_Id, St_Id,sum(Grade)OVER(PARTITION BY St_Id ) as total_grades
FROM Stud_Course

--Rank the students based on their total grades and identify the students with the highest overall grades. 

with cte as 
(
select * ,  DENSE_RANK() over (order by total_grades desc) as ranking
from (
select St_Id, sum(Grade)OVER(PARTITION BY St_Id ) as total_grades
from Stud_Course
) as newtable
)
select * from cte
where ranking =1




--Use CompanySD 
--1.Employee Ranking within Departments: Challenge: You want to rank employees within each department based on their salaries
select * from Employee 

with cte 
as 
( select Fname , Salary , Dno
  from employee 
      ) 

    SELECT * , RANK() OVER(PARTITION BY Dno ORDER BY Salary desc) AS ranking
    FROM cte  

--2.Employee Ranking by Project Contributions: Challenge: You want to rank employees based on the number of hours they worked on each project.
select * from Employee  
select *from Works_for

with cte 
as 
( select e.SSN , e.Fname , w.Pno , w.Hours
  from employee e , Works_for w 
  where e.SSN=w.ESSn
      ) 
  SELECT * ,RANK() OVER(ORDER BY Hours desc) AS ranking
  FROM cte  


--3.Project Ranking by Employee Contributions: Challenge: You want to rank projects based on the total number of hours worked on each project. 

select * from Employee 
select *from Works_for 

with cte 
as 
( select e.SSN , e.Fname , w.Pno , sum(w.Hours)OVER(PARTITION BY w.Pno ) as total_hours
  from employee e , Works_for w 
  where e.SSN=w.ESSn
      ) 
  SELECT * ,DENSE_RANK() OVER(ORDER BY total_hours desc) AS ranking
  FROM cte 


--4.Department Ranking by Project Count: Challenge: You want to rank departments based on the number of projects they have. 

select *from Project

with cte 
as 
( select Dnum, Pnumber,Pname , count(Pnumber)OVER(PARTITION BY Dnum ) as number_of_projects
  from Project 
      ) 
	  SELECT * ,DENSE_RANK() OVER(ORDER BY number_of_projects desc) AS ranking
  FROM cte 
