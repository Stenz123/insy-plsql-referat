--- Demo Fibbonaci

create or replace function fibbonaci(n in number) return number is
    v_last_number number := 0;
    v_current_number number := 1;
    v_temp number;
begin
    FOR i in 2..n LOOP
        v_temp:=v_last_number;
        v_last_number:=v_current_number;
        v_current_number := v_last_number + v_temp;
    end loop;
    return v_current_number;
end;

select fibbonaci(9) from dual;




--- Demo Parameter Modi

CREATE OR REPLACE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2 ) IS
BEGIN
    p_phone_no := '('  || SUBSTR (p_phone_no,1,3) ||
                  ') ' || SUBSTR (p_phone_no,4,3) ||
                  '-'  || SUBSTR (p_phone_no,7);
END format_phone;

DECLARE
    v_phone_no VARCHAR2(255) := '+431234567';
BEGIN
    format_phone(v_phone_no);
    DBMS_OUTPUT.PUT_LINE(v_phone_no); -- (+43) 123-4567
END;
