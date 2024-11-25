-- *** SUBTYPES *** --
-- Local
DECLARE
    SUBTYPE percentage_t IS PLS_INTEGER RANGE 0..100;

    --percent percent_pkg.percentage_t := 90;

    --percent   percentage_t := 200;
    percent   percentage_t := 58;
BEGIN
    DBMS_OUTPUT.PUT_LINE(percent);
end;

-- Global
CREATE OR REPLACE PACKAGE percent_pkg
IS
    SUBTYPE percentage_t IS PLS_INTEGER RANGE 0..100;
END;

DROP PACKAGE percent_pkg;
