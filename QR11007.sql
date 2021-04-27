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