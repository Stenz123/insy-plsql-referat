CREATE OR REPLACE PACKAGE finance_pkg AS
    -- Public variable
    g_tax_rate NUMBER;

    FUNCTION calculate_tax(p_amount NUMBER) RETURN NUMBER;
END finance_pkg;

CREATE OR REPLACE PACKAGE BODY finance_pkg AS

    -- Private variable
    v_default_rate NUMBER := 0.05;

    -- Implementation of calculate_tax function
    FUNCTION calculate_tax(p_amount NUMBER) RETURN NUMBER IS
    BEGIN
        IF g_tax_rate IS NULL THEN
            RETURN p_amount * v_default_rate;  -- Using private variable
        ELSE
            RETURN p_amount * g_tax_rate;      -- Using public variable
        END IF;
    END calculate_tax;

END finance_pkg;

BEGIN
    finance_pkg.g_tax_rate := 0.07; -- Set the public variable
    DBMS_OUTPUT.PUT_LINE('Tax: ' || finance_pkg.calculate_tax(1000));
END;