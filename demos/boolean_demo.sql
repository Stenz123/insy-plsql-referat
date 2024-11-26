
create or replace function number_demo_function return number is
begin
    return 1;
end;

create or replace function boolean_demo_function return boolean is
begin
    return true;
end;

select number_demo_function()
from dual;

select  boolean_demo_function()
from dual;