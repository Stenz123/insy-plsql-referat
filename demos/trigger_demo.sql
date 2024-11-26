-- Setup
drop table students;
create table students(
    name varchar(255) primary key,
    insy_grade number(3)
);
insert into students(name, insy_grade) VALUES ('Michi', 1);

create table student_logs(
    log_id number primary key,
    action_type varchar(10),
    action_timestamp timestamp,
    old_data varchar(255),
    new_data varchar(255),
    performed_by varchar(255)
);
create sequence student_logs_seq start with 1;

create or replace trigger insy_grade_logger
    before insert OR update OR delete on students
    for each row
declare
    v_old_data varchar(255);
    v_new_data varchar(255);
begin
    -- Handle old data for DELETE or UPDATE
    if deleting or updating then
        v_old_data := student_to_string(OLD);
    end if;

    -- Handle new data for INSERT or UPDATE
    if inserting or updating then
        v_new_data := student_to_string(NEW);
    end if;

    -- Insert log entry
    insert into student_logs (
        log_id,
        action_type,
        action_timestamp,
        old_data,
        new_data,
        performed_by
    ) values (
                 student_logs_seq.nextval,
                 case
                     when inserting then 'INSERT'
                     when updating then 'UPDATE'
                     when deleting then 'DELETE'
                     end,
                 systimestamp,
                 v_old_data,
                 v_new_data,
                 sys_context('USERENV', 'SESSION_USER')
             );
end;
/
/

--- helper

create or replace function student_to_string(a_student students%rowtype) return varchar2 is
begin
    return 'Name: ' || a_student.name || ', Grade: ' || a_student.insy_grade;
end;

