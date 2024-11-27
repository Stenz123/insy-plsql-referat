CREATE TABLE emp_backup AS
SELECT CAST(NULL AS DATE) AS backup_time, emp.*
FROM emp where 1 = 0;

ALTER TABLE emp_backup
    ADD CONSTRAINT emp_backup_pk PRIMARY KEY (empno, backup_time);

select * from emp_backup;

CREATE OR REPLACE PROCEDURE backup_emp_table IS
BEGIN
    INSERT INTO emp_backup (backup_time, empno, ename, job, mgr, hiredate, sal, comm, deptno)
    SELECT CURRENT_DATE, empno, ename, job, mgr, hiredate, sal, comm, deptno
    FROM emp;
    COMMIT;
END;
/

CALL BACKUP_EMP_TABLE();

DECLARE
    job_no NUMBER;
BEGIN
    DBMS_JOB.SUBMIT(
            job        => job_no,
            what       => 'backup_emp_table;',   -- procedure to execute
            next_date  => TRUNC(SYSDATE) + 1,   -- Start tomorrow at midnight
            interval   => 'FREQ=HOURLY;'  -- Run every day at midnight
    );
    DBMS_OUTPUT.PUT_LINE('Job Number: ' || job_no);
    COMMIT;
END;