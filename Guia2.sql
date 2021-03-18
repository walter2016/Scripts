CREATE OR REPLACE PROCEDURE update_salary(pemp_id NUMBER, pnew_salary NUMBER)
IS
    emp_name VARCHAR2(50);
    old_salsary NUMBER;

BEGIN

    SELECT FIRST_NAME || ' ' || LAST_NAME, SALARY
    INTO emp_name, old_salsary
    FROM EMPLOYEES
    WHERE employee_id = pemp_id;

    UPDATE EMPLOYEES
        SET SALARY = pnew_salary
        WHERE employee_id = pemp_id;

        DBMS_OUTPUT.PUT_LINE('Salary update for:' || emp_name || '. Old salary was: ' || old_salsary);

    END;
    /

BEGIN 
    update_salary(118,5001);
end;
/