use Finalproject
GO

--student
drop PROCEDURE if EXISTS update_insert_student_all
GO
create PROCEDURE update_insert_student_all(
    @SUID VARCHAR(50),
    @student_firstname varchar(50),
    @student_lastname varchar(50),
    @student_email varchar(50),
    @student_degree varchar(20),
    @student_college varchar(20),
    @student_dorm varchar(20),
    @student_status varchar(20)
) as BEGIN
    if exists (select * from students where SUID=@SUID) BEGIN
        update students set student_firstname=@student_firstname,
        student_lastname=@student_lastname,
        Student_email=@student_email,
        Student_degree=@student_degree,
        Student_college=@student_college,
        Student_dorm=@student_dorm,
        Student_status=@student_status
        where SUID=@SUID
        END
        else begin
        declare @id int = (select max(student_id) from students) + 1
        insert into students(SUID,student_firstname,student_lastname,Student_email,Student_degree,Student_college,Student_dorm,Student_status)
            values(@SUID,@student_firstname,@student_lastname,@student_email,@student_degree,@student_college,@student_dorm,@student_status)
    END
END

--Course mode zezhou
drop PROCEDURE if EXISTS upsert_course_mode
GO
create PROCEDURE upsert_course_mode(
    @course_code varchar(20),
    @course_name varchar(200),
    @course_mode varchar(20)
) as BEGIN
    if exists (select * from Courses where Course_code=@course_code) BEGIN
        update Courses set 
        Course_name=@course_name,
        Course_mode=@course_mode where Course_code=@course_code
        END
        else begin
        declare @id int = (select max(Course_id) from Courses) + 1
        insert into courses(Course_code,Course_name,Course_mode)values(@course_code,@course_name,@course_mode) 
    END
end

--view course mode zezhou
drop PROCEDURE if EXISTS v1_course_mode
GO
create PROCEDURE v1_course_mode(
    @SUID varchar(20)
) as BEGIN
    select StudentID,SUID,student_firstname+' '+student_lastname as student_name,Course_code,
    Course_mode from Student_Course 
        join students on student_id = StudentID
        join Courses on Course_id = CourseID
        where SUID=@SUID
END

--Application zezhou
drop PROCEDURE if EXISTS update_Application_check
GO
create PROCEDURE update_Application_check(
    @Application_id varchar(20),
    @Application_student_id varchar(20),
    @Applicaiton_admin_id varchar(20)
) as begin
    if exists (select * from students where student_id=@Application_student_id and Student_status='Red') BEGIN
        update Applications SET
        Application_status = 'No' ,
        Application_admin_id = null where Application_id=@Application_id
        END
        else BEGIN
        update Applications SET
        Application_admin_id=@Applicaiton_admin_id where Application_id=@Application_id
    END
    END
go

--Trigger application zezhou
drop trigger if exists t_application_approve
GO
create trigger t_application_approve
    on Applications after INSERT,update
    as BEGIN
        update Applications set
            Application_admin_id = inserted.Application_admin_id,
            Application_status = case when inserted.Application_admin_id is null then 'No' else 'Yes' end
        from inserted
        where Applications.Application_id = inserted.Application_id
    END
go

--report, auto change status of student with duration>10 to red
drop PROCEDURE if EXISTS update_travel_report
GO
create PROCEDURE update_travel_report(
    @Report_date date,
    @Destination varchar(50),
    @Duration int,
    @Report_student_id int
) as BEGIN
    if exists (select * from students where student_id=@Report_student_id and @Duration >=10) begin
        update students SET
        Student_status = 'Red' where student_id=@Report_student_id
        declare @id1 int = (select max(Report_id) from Reports) + 1
        insert into Reports(Report_date,Destination,Duration,Report_student_id) 
        values (@Report_date,@Destination,@Duration,@Report_student_id) 
        end
        else BEGIN
        declare @id2 int = (select max(Report_id) from Reports) + 1
        insert into Reports(Report_date,Destination,Duration,Report_student_id) 
        values (@Report_date,@Destination,@Duration,@Report_student_id)
    end
END
GO

-- view power list zezhou
drop PROCEDURE if exists Admin_power_list
go
create PROCEDURE Admin_power_list(
    @Admin_id varchar(9)
) as BEGIN
    select Admin_id,Admin_firstname+' '+Admin_lastname as admin_name,Function_code,
    Function_name from Admin_Function 
        join Administrators on Administrator_id = AdministratorID
        join Functions on Function_id = FunctionID
        where Admin_id=@Admin_id
END
go

--view student-red-course-inperson to find 'red'student with in-person class
create view v_student_course as
    select StudentID,SUID,student_firstname+' '+student_lastname as student_name,Student_email,Student_status,Course_code,
    Course_mode from Student_Course 
        join students on student_id = StudentID
        join Courses on Course_id = CourseID
        where Student_status = 'Red' and Course_mode= 'In person'

drop view if EXISTS v_student_course  

--Fever record
drop procedure if EXISTS upsert_student_fever
GO
create PROCEDURE upsert_student_fever(
    @Record_tem float,
    @Record_con char(3),
    @Record_date date,
    @Fever_student_id int
) as BEGIN
    if exists(select * from students where student_id=@Fever_student_id and @Record_con = 'Yes') begin
        update students SET
        Student_status = 'Red' where student_id = @Fever_student_id
        declare @id3 int = (select max(Record_id) from FeverRecords) + 1
        insert into FeverRecords(Record_temperature,Record_contact,Record_date,Fever_student_id)
            values(@Record_tem,@Record_con,@Record_date,@Fever_student_id)
        END
        else BEGIN
        declare @id4 int = (select max(Record_id) from FeverRecords) + 1
        insert into FeverRecords(Record_temperature,Record_contact,Record_date,Fever_student_id)
            values(@Record_tem,@Record_con,@Record_date,@Fever_student_id)
    END
END
go

--Test result zezhou
drop procedure if EXISTS upsert_student_test
GO
create PROCEDURE upsert_student_test(
    @test_date date,
    @test_result char(8),
    @test_student_id int
) as BEGIN
    if exists (select * from students where student_id=@test_student_id and @test_result='negative') BEGIN
        UPDATE students SET
        Student_status = 'Green' where student_id = @test_student_id
        declare @id3 int = (select max(Test_id) from Tests) + 1
        insert into Tests(Test_date,Test_result,Test_student_id) values (@test_date,@test_result,@test_student_id)
        END
        else BEGIN
        declare @id4 int = (select max(Test_id) from Tests) + 1
        insert into Tests(Test_date,Test_result,Test_student_id) values (@test_date,@test_result,@test_student_id)
    END
END
go

--Approve set the admin_id into applicaiton_admin_id
drop procedure if EXISTS update_approve
GO
create PROCEDURE update_approve(
    @admin_id int,
    @application_id int
) as BEGIN
    update Applications SET
    Application_admin_id = @admin_id where Application_id=@application_id
END
go

--Verify
--student
select * from students
EXEC update_insert_student_all 205387290,'Jack','Ma','Jack@syr.edu','graduate','Ischool','off campus','Red'
EXEC update_insert_student_all 205387211,'Jackey','xxxx','Jackey@syr.edu','undergraduate','Ischool','on campus','Red'
select * from students

--Course
select * from Courses
EXEC upsert_course_mode 'Ist 678','Common for Info professionals','Online'
EXEC upsert_course_mode 'SCM 651','Business Analysis','In person'
select * from Courses

--Course view
EXEC v1_course_mode 205387290

--Application
--check
select * from Applications where Application_id = 1
update Applications set Application_admin_id = 1 where Application_id = 1
select * from Applications where Application_id = 1

select * from Applications
EXEC update_Application_check 1,1,1 
select * from Applications

--view student-course
select * from v_student_course
select * from INFORMATION_SCHEMA.VIEWS

--report
select * from Reports
select * from students
EXEC update_travel_report '2020-11-11' ,'Los Angeles',13,3
select * from Reports
select * from students

--power list
EXEC Admin_power_list 123456789

--Fever record
select * from students
select * from FeverRecords
EXEC upsert_student_fever 100, 'Yes','2020-9-13',4
select * from students
select * from FeverRecords

--Test result Red=> Green
select * from Tests
select * from students
EXEC upsert_student_test '2020-12-3','negative',1
select * from Tests
select * from students

--Approve
select * from Applications
EXEC update_approve 1,1
select * from Applications