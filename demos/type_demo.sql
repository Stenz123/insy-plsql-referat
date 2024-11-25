-- Setup
drop table students;
create table students(
    name varchar(255) primary key,
    insy_grade number(3)
);
insert into students(name, insy_grade) VALUES ('Michi', 1);


-------------------

select *
from students;

CREATE OR REPLACE PROCEDURE greet_student(a_name varchar) IS
    v_grade number(1);
BEGIN
    select insy_grade into v_grade from students where students.name = a_name;
    DBMS_OUTPUT.PUT_LINE('Hello there ' || a_name || '! Your Current grade is ' || v_grade);
end;

BEGIN
    greet_student('Michi');
end;





--- UPDATE

DROP TABLE students;

create table students(
     name varchar(255) primary key,
     insy_grade number(3,2)
);

insert into students(name, insy_grade) VALUES ('Michi', 1.5);
