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
    ides staff_list in ()
    update_salary(100,102,103);
end;


select * from employees where EMPLOYEE_ID in (100,102,103);












------------
select * from employees;

create or replace type employees_ids as table of number;
/
create or replace procedure salaryIncrease(emp_ids employees_ids)
is
begin
  for n in 1..emp_ids.count
  loop
      update employees
      set salary = salary+(0.06*salary)
      where employee_id=emp_ids(n);
  end loop;
end;
/
BEGIN
    salaryIncrease(employees_ids(100)) ;
END;

create or replace function invertirCadena(cadena VARCHAR2)
return varchar2
is
    output_no varchar2(100);
begin
  for n in 1..length(cadena)
  loop
    output_no :=output_no||''||substr(cadena,(length(cadena)-n+1),1);
  end loop;
  return  output_no;
end;

      select invertirCadena('HOLA') from dual;