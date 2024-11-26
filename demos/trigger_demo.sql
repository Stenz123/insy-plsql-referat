
CREATE TABLE customers (
    NAME VARCHAR(50),
    SALARY DECIMAL(10, 2)
);
delete from customers where 1 = 1;
select * from customers;

CREATE OR REPLACE TRIGGER display_and_check_salary_changes
    BEFORE DELETE OR INSERT OR UPDATE ON customers
    FOR EACH ROW
DECLARE
    sal_diff number;
BEGIN
    sal_diff := :NEW.salary  - :OLD.salary;
    IF sal_diff <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be decreased');
    end if;

    dbms_output.put_line('Old salary: ' || :OLD.salary);
    dbms_output.put_line('New salary: ' || :NEW.salary);
    dbms_output.put_line('Salary difference: ' || sal_diff);
END;

INSERT INTO CUSTOMERS (NAME, SALARY)
VALUES ('Michi', 100);

UPDATE customers
SET salary = 120
WHERE name = 'Michi';

UPDATE customers
SET salary = 80
WHERE name = 'Michi';
