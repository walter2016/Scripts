--Bloque anonimo

DECLARE 
	v_store_name stores.store_name%TYPE:='London';
	n_year int:=2018;
	n_order_count int;
BEGIN
	select count(*)
	into n_order_count
	from orders o 
	inner join stores s 
		on o.store_id = s.store_id
	where extract(year from o.order_datetime)=n_year
	and s.tore_name=v_store_name
	group by s.store_name, extract(year from o.order_datetime);
	dbms_output.put_line('Total de ordenes para '|| v_store_name||' en' ||n_year||':'||n_order_count);
	
END;

--Funciones
--IN se comporta como constante
--OUT parametros que no proveen valor pero son asignados y retornados
--IN OUT proveen valor y son asignados y retornados io
CREATE OR REPLACE FUNCTION obtener_conteo_ordenes_por_tienda_y_anio(
i_store_name IN stores.store_name%TYPE,
i_year IN INT
)
RETURN int IS
n_order_count int;
BEGIN
	select count(*)
	into n_order_count
	from orders o 
	inner join stores s 
		on o.store_id = s.store_id
	where extract(year from o.order_datetime)=i_year
	and s.tore_name=i_store_name
	group by s.store_name, extract(year from o.order_datetime);
	RETURN(n_order_count);
end;

select obtener_conteo_ordenes_por_tienda_y_anio('Berlin',2018) from dual;
DROP FUNCTION obtener_conteo_ordenes_por_tienda_y_anio;

--Procedimientos (son bloques anonimos almacenados), ejecutan acciones no retornan nada
--Ejemplo 1:
CREATE OR REPLACE PROCEDURE insertar_tienda(
i_nombre IN stores.store_name%TYPE DEFAULT' Desconocido',
i_loc IN stores.physical_address%TYPE DEFAULT 'Desconocido'
)
IS
BEGIN
	INSERT INTO STORES(STORE_NAME,PHYSICAL_ADDRESS)
	VALUES(i_nombre,i_loc);
end insertar_tienda;

BEGIN
	insertar_tienda();
	insertar_tienda('Training','New york');
	insertar_tienda(i_loc => 'BOSTON');
END;
DROP PROCEDURE insertar_tienda;

--Ejemplo 2:

CREATE OR REPLACE PROCEDURE ajuste_salarial(
i_id IN EMPLOYEES.employee_id%TYPE,
i_porcentaje IN FLOAT
)
IS
BEGIN
	UPDATE EMPLOYEES
	SET SALARY = SALARY + (1+i_porcentaje)
	WHERE EMPLOYEE_ID=i_id;
end ajuste_salarial;
BEGIN
	ajuste_salarial(100,0.1);
END;

--Ejemplo 3:

CREATE OR REPLACE PROCEDURE obtener_datos_empleado(
i_id IN EMPLOYEES.employee_id%TYPE,
o_first_name OUT EMPLOYEES.first_name%TYPE,
o_last_name OUT EMPLOYEES.last_name%TYPE,
)
IS
BEGIN
	SELECT FIRST_NAME, LAST_NAME
	INTO o_first_name,o_last_name
	FROM EMPLOYEES
	WHERE EMPLOYEE_ID=i_id
end obtener_datos_empleado;

BEGIN
	obtener_datos_empleado(100);
END;


--Paquetes (agrupar objetos almacenados en la BD) 
--cabecera y cuerpo
--declare: variable,cursores, excepciones, funciones procedimientos
DROP PROCEDURE ajuste_salarial;
DROP PROCEDURE obtener_datos_empleado;

CREATE OR REPLACE PACKAGE hr_procedures IS 
	
	PROCEDURE ajuste_salarial(
		i_id IN EMPLOYEES.employee_id%TYPE,
		i_porcentaje IN FLOAT);
	
	PROCEDURE obtener_datos_empleado(
		i_id IN EMPLOYEES.employee_id%TYPE,
		o_first_name OUT EMPLOYEES.first_name%TYPE,
		o_last_name OUT EMPLOYEES.last_name%TYPE,
		);

END hr_procedures;

CREATE OR REPLACE PACKAGE BODY hr_procedures IS
	
	PROCEDURE ajuste_salarial(
		i_id IN EMPLOYEES.employee_id%TYPE,
		i_porcentaje IN FLOAT
		) IS 
		BEGIN
			UPDATE EMPLOYEES
			SET SALARY = SALARY + (1+i_porcentaje)
			WHERE EMPLOYEE_ID=i_id;
		end ajuste_salarial;
	
	PROCEDURE obtener_datos_empleado(
		i_id IN EMPLOYEES.employee_id%TYPE,
		o_first_name OUT EMPLOYEES.first_name%TYPE,
		o_last_name OUT EMPLOYEES.last_name%TYPE,
		) IS
		BEGIN
			SELECT FIRST_NAME, LAST_NAME
			INTO o_first_name,o_last_name
			FROM EMPLOYEES
			WHERE EMPLOYEE_ID=i_id
		end obtener_datos_empleado;
END hr_procedures;

DECLARE
BEGIN
	hr_procedures.ajuste_salarial(100);
	hr_procedures.obtener_datos_empleado(100);
END;

DROP PACKAGE ;
DROP PACKAGE BODY;



















