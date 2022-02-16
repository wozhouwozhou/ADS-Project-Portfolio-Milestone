--Sample data
--Students
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387290,'Jack','Ma','Jack@syr.edu','graduate','Ischool','off campus','Green')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387291,'Tony','Ma','Tony@syr.edu','graduate','Ischool','off campus','Green')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387292,'Jacob','Michael','Jacob@syr.edu','undergraduate','Whitman','on campus','Green')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387293,'Aiden','Ethan','Aiden@syr.edu','undergraduate','Newhouse','on campus','Green')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387294,'Matthew','Ethan','Matthew@syr.edu','undergraduate','Newhouse','on campus','Green')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387295,'Nicholas','Joshua','Nicholas@syr.edu','undergraduate','David B. Falk','on campus','Green')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387296,'Michael','Ryan','Michael@syr.edu','undergraduate','Maxwell','on campus','Green')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387297,'Andrew','Caden','Andrew@syr.edu','doctor','Law','off campus','Green')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387298,'Tyler','Dylan','Tyler@syr.edu','doctor','Arts and Sciences','off campus','Red')
insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
values (205387299,'Jaden','Zachary','Jaden@syr.edu','graduate','Architecture','off campus','Red')

--Reports
insert into Reports(Report_date,Duration,Destination,Report_student_id) values ('2020-9-11',12,'Los Angeles',1)
insert into Reports(Report_date,Duration,Destination,Report_student_id) values ('2020-8-11',5,'Boston',2)
insert into Reports(Report_date,Duration,Destination,Report_student_id) values ('2020-10-11',6,'Augusta',6)
insert into Reports(Report_date,Duration,Destination,Report_student_id) values ('2020-8-24',2,'Detroit',2)
insert into Reports(Report_date,Duration,Destination,Report_student_id) values ('2020-11-14',6,'Hawaii ',6)

--Tests
insert into Tests(Test_date,Test_result,Test_student_id) values ('2020-9-10','negative',1)
insert into Tests(Test_date,Test_result,Test_student_id) values ('2020-9-11','negative',2)
insert into Tests(Test_date,Test_result,Test_student_id) values ('2020-9-10','negative',3)
insert into Tests(Test_date,Test_result,Test_student_id) values ('2020-10-11','negative',5)
insert into Tests(Test_date,Test_result,Test_student_id) values ('2020-10-11','negative',1)
select * from Tests

--FeverRecords
insert into FeverRecords(Record_temperature,Record_contact,Record_date,Fever_student_id) 
values(101, 'No','2020-8-29',1)
insert into FeverRecords(Record_temperature,Record_contact,Record_date,Fever_student_id) 
values(102.5, 'No','2020-9-29',8)
insert into FeverRecords(Record_temperature,Record_contact,Record_date,Fever_student_id) 
values(101.2, 'Yes','2020-8-2',9)
insert into FeverRecords(Record_temperature,Record_contact,Record_date,Fever_student_id) 
values(101, 'No','2020-8-7',7)
insert into FeverRecords(Record_temperature,Record_contact,Record_date,Fever_student_id) 
values(100, 'Yes','2020-10-9',4)

--Courses
insert into Courses(Course_code,Course_name,Course_mode)values('Ist 659','Data Administration Concepts and Database Management','Online')
insert into Courses(Course_code,Course_name,Course_mode)values('Ist 615','Cloud Management','In person')
insert into Courses(Course_code,Course_name,Course_mode)values('Ist 618','Data Analysis','Online')
insert into Courses(Course_code,Course_name,Course_mode)values('Ist 422','Data Warehouse','Online')
insert into Courses(Course_code,Course_name,Course_mode)values('Ist 959','Economic for info professionals','Online')
insert into Courses(Course_code,Course_name,Course_mode)values('Ist 678','Common for Info professionals','In person')


--Student_Course
insert into Student_Course(StudentID,CourseID) values(1,1)
insert into Student_Course(StudentID,CourseID) values(1,2)
insert into Student_Course(StudentID,CourseID) values(1,3)
insert into Student_Course(StudentID,CourseID) values(2,1)
insert into Student_Course(StudentID,CourseID) values(3,5)
insert into Student_Course(StudentID,CourseID) values(4,6)
insert into Student_Course(StudentID,CourseID) values(8,3)
insert into Student_Course(StudentID,CourseID) values(10,2)
select * from Student_Course

--Administrators
insert into Administrators(Admin_id,Admin_firstname,Admin_lastname) values (123456789,'Alice','Phcyfic')
insert into Administrators(Admin_id,Admin_firstname,Admin_lastname) values (923456789,'Connor','Logan')
insert into Administrators(Admin_id,Admin_firstname,Admin_lastname) values (183456789,'Caleb','Noah')

--Applications
insert into Applications(Application_activity,Application_number,Application_date,Applicaiton_Student_id)
values('Party', 6,'2020-8-31',1)
insert into Applications(Application_activity,Application_number,Application_date,Applicaiton_Student_id)
values('Party', 10,'2020-9-30',5)
insert into Applications(Application_activity,Application_number,Application_date,Applicaiton_Student_id)
values('Group meeting', 9,'2020-11-30',4)
insert into Applications(Application_activity,Application_number,Application_date,Applicaiton_Student_id)
values('Basketball match', 13,'2020-9-22',6)
insert into Applications(Application_activity,Application_number,Application_date,Applicaiton_Student_id)
values('Street demonstration', 8,'2020-12-1',3)
select * from Applications

--Functions
insert into Functions(Function_code,Function_name) values ('A1','Approve')
insert into Functions(Function_code,Function_name) values ('A2','Update')
insert into Functions(Function_code,Function_name) values ('A3','Announcement')

--Admin_Function
insert into Admin_Function(AdministratorID,FunctionID) values(1,1)
insert into Admin_Function(AdministratorID,FunctionID) values(1,2)
insert into Admin_Function(AdministratorID,FunctionID) values(2,1)
insert into Admin_Function(AdministratorID,FunctionID) values(2,2)
insert into Admin_Function(AdministratorID,FunctionID) values(2,3)
insert into Admin_Function(AdministratorID,FunctionID) values(3,1)
