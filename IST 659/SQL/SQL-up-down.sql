--Final project SQL UP&DOWN file
if not exists(select * from sys.databases where name='Finalproject')
    create database Finalproject
GO

use Finalproject
GO
--DOWN
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_Reports_Report_student_id')
    alter table Reports drop constraint fk_Reports_Report_student_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_Tests_Test_student_id')
    alter table Tests drop constraint fk_Tests_Test_student_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_FeverRecords_Fever_student_id')
    alter table FeverRecords drop constraint fk_FeverRecords_Fever_student_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_Student_Course_StudentID')
    alter table Student_Course drop constraint fk_Student_Course_StudentID
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_Student_Course_CourseID')
    alter table Student_Course drop constraint fk_Student_Course_CourseID
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_Applications_Applicaiton_Student_id')
    alter table Applications drop constraint fk_Applications_Applicaiton_Student_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_Applications_Application_admin_id')
    alter table Applications drop constraint fk_Applications_Application_admin_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_Admin_Function_AdministratorID')
    alter table Admin_Function drop constraint fk_Admin_Function_AdministratorID
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_Admin_Function_FunctionID')
    alter table Admin_Function drop constraint fk_Admin_Function_FunctionID


drop table if EXISTS Administrators

drop table if EXISTS Admin_Function

drop table if EXISTS Applications

drop table if EXISTS Student_Course

drop table if exists FeverRecords

drop table if exists Tests

drop table if exists Reports

drop table if exists students

drop table if exists Courses

drop table if EXISTS Functions
--UP Metadata
create table students(
    student_id int identity not null,
    SUID varchar(50) NOT NULL,
    student_firstname varchar(50) not NULL,
    student_lastname varchar(50) not null,
    Student_email varchar(50) not null,
    Student_degree varchar(20) not null,
    Student_college varchar(20) not null,
    Student_dorm varchar(20) not null,
    Student_status varchar(20) not null,
    constraint pk_students_student_id primary key(student_id),
    constraint u_SUID unique (SUID),
    constraint u_Student_email unique (Student_email),
    constraint ck_Student_degree check (Student_degree='undergraduate' or Student_degree='graduate' or Student_degree='doctor' ),
    constraint ck_Student_dorm check (Student_dorm='on campus' or Student_dorm='off campus'),
    constraint ck_Student_status check (Student_status='Red' or Student_status='Green')
)

create table Reports (
    Report_id int identity not null,
    Report_date date not null,
    Destination varchar(50) not null,
    Duration int not null,
    Report_student_id int not null,
    CONSTRAINT pk_Reports_Report_id PRIMARY key(Report_id),
    CONSTRAINT fk_Reports_Report_student_id foreign KEY (Report_student_id) REFERENCES students(student_id)
)

create table Tests (
    Test_id int identity not null,
    Test_date date not null,
    Test_result varchar(20) not null,
    Test_student_id int not null,
    CONSTRAINT pk_Tests_Test_id PRIMARY KEY (Test_id),
    CONSTRAINT ck_Test_result check (Test_result= 'positive' or Test_result='negative'),
    constraint fk_Tests_Test_student_id foreign KEY (Test_student_id) REFERENCES students (student_id)
)

create table Administrators(
    Administrator_id int identity not null,
    Admin_id varchar(50) not null,
    Admin_firstname varchar(50) not null,
    Admin_lastname VARCHAR(50) not null,
    CONSTRAINT pk_Administrators_Administrator_id PRIMARY KEY (Administrator_id),
    CONSTRAINT u_Admin_id unique (Admin_id)
)

create table Applications (
    Application_id int identity not null,
    Application_activity varchar(50) not null,
    Application_number int not null,
    Application_date date not null,
    Applicaiton_Student_id int not null,
    Application_admin_id int null,
    Application_status char(3) null,
    CONSTRAINT pk_Applications_Application_id PRIMARY KEY(Application_id),
    CONSTRAINT fk_Applications_Applicaiton_Student_id foreign KEY(Applicaiton_Student_id) REFERENCES students(student_id),
    CONSTRAINT fk_Applications_Application_admin_id foreign key(Application_admin_id) REFERENCES Administrators(Administrator_id)
)

create table FeverRecords(
    Record_id int identity not null,
    Record_temperature float not null,
    Record_contact varchar(20) not null,
    Record_date date not null,
    Fever_student_id int not null,
    CONSTRAINT pk_FeverRecords_Record_id PRIMARY key (Record_id),
    CONSTRAINT fk_FeverRecords_Fever_student_id FOREIGN KEY (Fever_student_id) references students (student_id),
    CONSTRAINT ck_Record_contact check(Record_contact='Yes' or Record_contact= 'No')
)

create table Courses(
    Course_id int identity not null,
    Course_code varchar(20) not null,
    Course_name varchar(200) not null,
    Course_mode varchar(20) not null,
    CONSTRAINT pk_Courses_Course_id PRIMARY key(Course_id),
    CONSTRAINT u_Course_code unique(Course_code),
    constraint ck_Course_mode check(Course_mode='Online' or Course_mode='In person')
)

create table Student_Course(
    StudentID int not null,
    CourseID int not null,
    CONSTRAINT pk_Student_Course_StudentID_CourseID primary key (StudentID,CourseID),
    CONSTRAINT fk_Student_Course_StudentID foreign KEY (StudentID) references students(student_id),
    CONSTRAINT fk_Student_Course_CourseID foreign KEY (CourseID) references Courses (Course_id)
)

create table Functions(
    Function_id int identity not null,
    Function_code varchar(20) not null,
    Function_name varchar(20) not null,
    constraint pk_Functions_Function_id PRIMARY KEY (Function_id),
    CONSTRAINT u_Function_code unique(Function_code)
)

create table Admin_Function(
    AdministratorID int not null,
    FunctionID int not null,
    CONSTRAINT pk_Admin_Function_AdministratorID_FunctionID PRIMARY key (AdministratorID,FunctionID),
    CONSTRAINT fk_Admin_Function_AdministratorID foreign KEY (AdministratorID) REFERENCES Administrators(Administrator_id),
    constraint fk_Admin_Function_FunctionID foreign KEY (FunctionID) references Functions(Function_id)
)

--UP data
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

--Verify
select * from students

select * from Reports

select * from Tests

select * from FeverRecords

select * from Courses

select * from Student_Course

select * from Administrators

select * from Applications

select * from Functions

select * from Admin_Function