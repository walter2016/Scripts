--CREATE OR REPLACE PROCEDURE update_salary()




create or replace FUNCTION  cadena_invertida(cadena VARCHAR2) RETURNS   VARCHAR2
IS

    output_no VARCHAR2(100);

BEGIN
    for i in 1 .. length(cadena) loop
        output_no := output_no || '' ||
                     substr(cadena, (length(cadena) - i + 1), 1);
      end loop;

      dbms_output.put_line('La cadena no invertida es :' || cadena);
      dbms_output.put_line('La cadena  invertida es :' || output_no);
end;
/

begin
    cadena_invertida('Hola');
end;


CREATE PACKAGE personnel AS
   TYPE staff_list IS TABLE OF employees.employee_id%TYPE;
   PROCEDURE update_salary (empleos_buenos IN staff_list);
END personnel;
/

CREATE PACKAGE BODY personnel AS
 PROCEDURE update_salary (empleos_buenos staff_list) IS
  BEGIN
    FOR i IN empleos_buenos.FIRST..empleos_buenos.LAST
    LOOP
     UPDATE employees SET salary = salary*0.006
         WHERE employees.employee_id = empleos_buenos(i);
   END LOOP;
  END;
 END;
/

begin

    update_salary(staff_list(100,102,103));
end;


select * from employees where EMPLOYEE_ID in (100,102,103);

/////////////////////////////////////////////

CREATE OR REPLACE PACKAGE HR_PROCEDURES IS

    PROCEDURE AJUSTE_SALSARIAL(
        I_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        I_PORCENTAJE IN FLOAT
    );

    PROCEDURE OBTENER_DATOS_EMPLEADOS(
        I_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        O_FIRST_NAME OUT EMPLOYEES.FIRST_NAME%TYPE,
        O_LAST_NAME OUT EMPLOYEES.LAST_NAME%TYPE,
        O_EMAIL OUT EMPLOYEES.EMAIL%TYPE
    );

END HR_PROCEDURES;

CREATE OR REPLACE PACKAGE BODY HR_PROCEDURES IS

    PROCEDURE AJUSTE_SALSARIAL(
        I_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        I_PORCENTAJE IN FLOAT
    )
        IS
    BEGIN
        UPDATE EMPLOYEES
        SET SALARY=SALARY * (1 + I_PORCENTAJE)
        WHERE EMPLOYEE_ID = I_ID;
    END AJUSTE_SALSARIAL;

    PROCEDURE OBTENER_DATOS_EMPLEADOS(
        I_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
        O_FIRST_NAME OUT EMPLOYEES.FIRST_NAME%TYPE,
        O_LAST_NAME OUT EMPLOYEES.LAST_NAME%TYPE,
        O_EMAIL OUT EMPLOYEES.EMAIL%TYPE
    )
        IS
    BEGIN
        SELECT FIRST_NAME,
               LAST_NAME,
               EMAIL
        INTO
            O_FIRST_NAME,
            O_LAST_NAME,
            O_EMAIL
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = I_ID;

    END OBTENER_DATOS_EMPLEADOS;

END HR_PROCEDURES;
/

////////////////////////////////////////////////////////////////

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


/////////////////////////////////////////////////////////


CREATE OR REPLACE PACKAGE EXA1_QR11007 IS

    FUNCTION FUNT1_COUNT(TABLA VARCHAR2) RETURN INT;

    FUNCTION FUNT2_DATE(FECHA NVARCHAR2) RETURN DATE;

    PROCEDURE PROC1_CHANGE;

END EXA1_QR11007;
/
CREATE OR REPLACE PACKAGE BODY EXA1_QR11007 IS


    FUNCTION FUNT1_COUNT(TABLA Varchar2) RETURN INT
        IS
        contador INT;
    BEGIN

        IF (UPPER(TABLA) = 'EMPLOYEES') THEN
            select count(*) into contador from EMPLOYEES;
        elsif (UPPER(TABLA) = 'COUNTRIES') then
            select count(*) into contador from COUNTRIES;
        elsif (UPPER(TABLA) = 'DEPARTMENTS') then
            select count(*) into contador from DEPARTMENTS;
        elsif (UPPER(TABLA) = 'JOB_HISTORY') then
            select count(*) into contador from JOB_HISTORY;
        elsif (UPPER(TABLA) = 'JOBS') then
            select count(*) into contador from JOBS;
        elsif (UPPER(TABLA) = 'LOCATIONS') then
            select count(*) into contador from LOCATIONS;
        ELSE
            select count(*) into contador from REGIONS;
        end if;

        return contador;
    END FUNT1_COUNT;


    FUNCTION FUNT2_DATE(FECHA NVARCHAR2) RETURN DATE
        IS
        i_fecha DATE;
    BEGIN
        -- select TO_DATE(i_fecha,'DD/MM/YYYY') into i_fecha from dual;
        SELECT TO_CHAR(TO_DATE(i_fecha, 'MM/DD/YYYY'), 'MM/DD/YYYY') into i_fecha FROM dual;

        return i_fecha;

    END FUNT2_DATE;

    PROCEDURE PROC1_CHANGE
        is

    begin

        EXECUTE IMMEDIATE 'CREATE TABLE r_temp AS SELECT  CAST(region_id as NUMBER(10,0)) region_id, region_name FROM regions';

        EXECUTE IMMEDIATE 'RENAME  regions TO region_2';
        EXECUTE IMMEDIATE 'rename r_temp to regions';
        EXECUTE IMMEDIATE 'alter table countries drop constraint COUNTR_REG_FK';
        EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX "HR"."REG_ID_PK2" ON "HR"."REGIONS" ("REGION_ID")';
        EXECUTE IMMEDIATE 'ALTER TABLE "HR"."REGIONS" ADD CONSTRAINT "REG_ID_PK2" PRIMARY KEY ("REGION_ID") USING INDEX "HR"."REG_ID_PK2"  ENABLE';
        EXECUTE IMMEDIATE 'ALTER TABLE "HR"."COUNTRIES" ADD CONSTRAINT "COUNTR_REG_FK" FOREIGN KEY ("REGION_ID") REFERENCES "HR"."REGIONS" ("REGION_ID") ENABLE';


    end PROC1_CHANGE;


END EXA1_QR11007;

SELECT EXA1_QR11007.FUNT2_DATE('02-05-2020')
FROM DUAL;

////////////////////////////////////////

CREATE TABLE HR.WS_BUSQUEDA
(
    busqueda_id     NUMBER GENERATED BY DEFAULT AS IDENTITY,
    fecha_ejecucion DATE           not null,
    palabra_buscar  VARCHAR2(50)   NOT NULL,
    respuesta_ws    VARCHAR2(4000) NOT NULL,
    PRIMARY KEY (busqueda_id)
);
/

create or replace package busqueda_ws IS

    procedure buscar_ws(
        I_PALABRA IN WS_BUSQUEDA.palabra_buscar%TYPE
    );

END busqueda_ws;


create or replace package body busqueda_ws IS

    procedure buscar_ws(
        I_PALABRA IN WS_BUSQUEDA.palabra_buscar%TYPE
    )
        IS

        req  UTL_HTTP.REQ;
        resp UTL_HTTP.RESP;
        val  VARCHAR2(4000);
        str  varchar2(4000);
    BEGIN
        req := UTL_HTTP.BEGIN_REQUEST('http://api.plos.org/search?q=title:' || I_PALABRA);
        resp := UTL_HTTP.GET_RESPONSE(req);
        LOOP
            UTL_HTTP.READ_LINE(resp, val, TRUE);
            DBMS_OUTPUT.PUT_LINE(val);
            insert into HR.WS_BUSQUEDA(fecha_ejecucion,palabra_buscar,respuesta_ws) VALUES (SYSDATE,I_PALABRA,val);
        END LOOP;


    EXCEPTION
        WHEN
            UTL_HTTP.END_OF_BODY
            THEN
                UTL_HTTP.END_RESPONSE(resp);

    END buscar_ws;

END busqueda_ws;


BEGIN

    busqueda_ws.buscar_ws('COVID');

end;


select * from WS_BUSQUEDA

insert into HR.WS_BUSQUEDA(fecha_ejecucion,palabra_buscar,respuesta_ws) VALUES (SYSDATE,'I_PALABRA','val');

