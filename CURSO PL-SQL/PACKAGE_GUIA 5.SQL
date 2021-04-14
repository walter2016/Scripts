CREATE OR REPLACE PACKAGE TUTORIA_5 IS


    PROCEDURE UPDATE_EMPLOYEE(EMP_IDS VARCHAR2);

    FUNCTION invertir_Cadena(CADENA VARCHAR2) RETURN VARCHAR2;


END TUTORIA_5;

CREATE OR REPLACE PACKAGE BODY TUTORIA_5 IS

    PROCEDURE UPDATE_EMPLOYEE(EMP_IDS VARCHAR2)
        IS

    BEGIN
        EXECUTE IMMEDIATE 'UPDATE HR.EMPLOYEES SET SALARY=2600 WHERE EMPLOYEE_ID IN (' || EMP_IDS || ')';
    END UPDATE_EMPLOYEE;

    function invertir_Cadena(cadena VARCHAR2) return varchar2
        is
        output_no varchar2(100);
    begin
        for n in 1..length(cadena)
            loop
                output_no := output_no || '' || substr(cadena, (length(cadena) - n + 1), 1);
            end loop;
        return output_no;
    end invertir_Cadena;

END TUTORIA_5;


/

begin
    TUTORIA_5.UPDATE_EMPLOYEE('120,123');
end;


    SELECT  TUTORIA_5.INVERTIR_CADENA('hola') FROM DUAL;
