-- ZADANIE 1

DECLARE
  max_number NUMBER;
BEGIN
  SELECT MAX(DEPARTMENT_ID) INTO max_number FROM DEPARTMENTS;
  INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
  VALUES (max_number + 10, 'EDUCATION');
END;


-- ZADANIE 2

DECLARE
  max_number NUMBER;
BEGIN
  SELECT MAX(DEPARTMENT_ID) INTO max_number FROM DEPARTMENTS;
  INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
  VALUES (max_number + 10, 'EDUCATION', 3000);
END;


-- ZADANIE 3

CREATE TABLE NEW_TABLE(
    NEW_TABLE_NUMBER VARCHAR(2)
);

DECLARE
    value VARCHAR(2);
BEGIN
   FOR i IN 1..10 LOOP
        value := i;
        IF value NOT IN (4, 6) THEN
            INSERT INTO NEW_TABLE (NEW_TABLE_NUMBER)
            VALUES (value);
        END IF;
    END LOOP;
END;


-- ZADANIE 4

DECLARE
  countries_info COUNTRIES%ROWTYPE;
BEGIN
    SELECT * INTO countries_info
    FROM COUNTRIES
    WHERE COUNTRY_ID = 'CA';
    DBMS_OUTPUT.PUT_LINE(countries_info.COUNTRY_NAME);
    DBMS_OUTPUT.PUT_LINE(countries_info.REGION_ID);
END;


-- ZADANIE 5

DECLARE
    TYPE type_departments_name IS TABLE OF DEPARTMENTS.DEPARTMENT_NAME%TYPE
    INDEX BY PLS_INTEGER;
    dep_names type_departments_name;
    step PLS_INTEGER := 10;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT DEPARTMENTS.DEPARTMENT_NAME INTO dep_names(i)
        FROM DEPARTMENTS
        WHERE DEPARTMENTS.DEPARTMENT_ID = i * step;
    END LOOP;
    FOR i IN dep_names.FIRST..dep_names.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT NAME: ' || dep_names(i));
    END LOOP;
END;


-- ZADANIE 6

DECLARE
    TYPE type_departments IS TABLE OF DEPARTMENTS%ROWTYPE
    INDEX BY PLS_INTEGER;
    deps type_departments;
    step PLS_INTEGER := 10;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT * INTO deps(i)
        FROM DEPARTMENTS
        WHERE DEPARTMENTS.DEPARTMENT_ID = i * step;
    END LOOP;
    FOR i IN deps.FIRST..deps.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT ID: ' || deps(i).DEPARTMENT_ID);
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT NAME: ' || deps(i).DEPARTMENT_NAME);
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT MANAGER: ' || deps(i).MANAGER_ID);
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT LOCATION: ' || deps(i).LOCATION_ID);
        DBMS_OUTPUT.PUT_LINE('============================================');
    END LOOP;
END;


-- ZADANIE 7

DECLARE
    CURSOR last_name_salary IS
    SELECT LAST_NAME, SALARY
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = 50;
    employee last_name_salary%ROWTYPE;
BEGIN
    OPEN last_name_salary;
    LOOP
        FETCH last_name_salary INTO employee;
        EXIT WHEN last_name_salary%NOTFOUND;
        IF employee.SALARY > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(employee.LAST_NAME || ' - nie dawać podwyżki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(employee.LAST_NAME || ' - dać podwyżkę');
        END IF;
    END LOOP;
    CLOSE last_name_salary;
END;


-- ZADANIE 8

DECLARE
    CURSOR salary_between(
        min_salary EMPLOYEES.SALARY%TYPE,
        max_salary EMPLOYEES.SALARY%TYPE,
        first_name_part EMPLOYEES.FIRST_NAME%TYPE) IS
    SELECT FIRST_NAME, LAST_NAME, SALARY
    FROM EMPLOYEES
    WHERE UPPER(FIRST_NAME) LIKE '%' || UPPER(first_name_part) || '%' AND SALARY BETWEEN min_salary and max_salary;
    employee salary_between%ROWTYPE;
BEGIN
    OPEN salary_between(1000, 5000, 'a');
    DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 1000-5000 i częścią imienia "a" lub "A": ');
    LOOP
        FETCH salary_between INTO employee;
        EXIT WHEN salary_between%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('- ' || employee.FIRST_NAME || ' ' || employee.LAST_NAME);
    END LOOP;
    CLOSE salary_between;
    OPEN salary_between(5000, 20000, 'u');
        DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 5000-20000 i częścią imienia "u" lub "U": ');
    LOOP
        FETCH salary_between INTO employee;
        EXIT WHEN salary_between%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('- ' || employee.FIRST_NAME || ' ' || employee.LAST_NAME);
    END LOOP;
    CLOSE salary_between;
END;


-- ZADANIE 9A

CREATE OR REPLACE PROCEDURE insert_job(
    job_id_input IN JOBS.JOB_ID%TYPE,
    job_title_input IN JOBS.JOB_TITLE%TYPE
) IS
BEGIN
    INSERT INTO JOBS (JOB_ID, JOB_TITLE) VALUES (job_id_input, job_title_input);
    EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Istnieje już praca o takim ID');
END;

BEGIN
    insert_job('AD_VP', 'TEST'); -- Powinien wywołać się wyjątek
    insert_job('AD_VP1', 'TEST');
END;


-- ZADANIE 9B

CREATE OR REPLACE PROCEDURE modify_job_title(
    job_id_input IN JOBS.JOB_ID%TYPE,
    job_title_input IN JOBS.JOB_TITLE%TYPE
) IS
NO_JOBS_UPDATED EXCEPTION;
PRAGMA EXCEPTION_INIT(NO_JOBS_UPDATED, -20000);
BEGIN
    UPDATE JOBS
    SET JOB_TITLE = job_title_input
    WHERE JOB_ID = job_id_input;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE NO_JOBS_UPDATED;
    END IF;
    EXCEPTION WHEN NO_JOBS_UPDATED THEN
    DBMS_OUTPUT.PUT_LINE('Nie zaktualizowano żadnego rekordu. Kod błędu: ' || SQLCODE);
END;

BEGIN
    modify_job_title('AD_VV', 'TEST'); -- Powinien wywołać się wyjątek
    modify_job_title('AD_VP1', 'TEST MODYFIKACJI'); -- Rekord dodany w zadaniu 9A
END;


-- ZADANIE 9C

CREATE OR REPLACE PROCEDURE delete_job(
    job_id_input IN JOBS.JOB_ID%TYPE
) IS
NO_JOBS_DELETED EXCEPTION;
PRAGMA EXCEPTION_INIT(NO_JOBS_DELETED, -20000);
BEGIN
    DELETE FROM JOBS
    WHERE JOB_ID = job_id_input;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE NO_JOBS_DELETED;
    END IF;
    EXCEPTION WHEN NO_JOBS_DELETED THEN
    DBMS_OUTPUT.PUT_LINE('Nie usunięto żadnego rekordu. Kod błędu: ' || SQLCODE);
END;

BEGIN
    delete_job('123456'); -- Powinien wywołać się wyjątek
    delete_job('AD_VP1'); -- Rekord dodany w zadaniu 9A
END;


-- ZADANIE 9D

CREATE OR REPLACE PROCEDURE get_employees_info(
    employee_id_input IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    employee_last_name OUT EMPLOYEES.LAST_NAME%TYPE,
    employee_salary OUT EMPLOYEES.SALARY%TYPE
) IS
BEGIN
    SELECT LAST_NAME, SALARY INTO employee_last_name, employee_salary
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = employee_id_input;
END;

CREATE OR REPLACE PROCEDURE show IS
    employee_last_name EMPLOYEES.LAST_NAME%TYPE;
    employee_salary EMPLOYEES.SALARY%TYPE;
BEGIN
    get_employees_info(123, employee_last_name, employee_salary);
	dbms_output.put_line(employee_last_name || ' ' || employee_salary);
END;

BEGIN
    show();
END;


-- ZADANIE 9E

CREATE SEQUENCE employees_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE OR REPLACE PROCEDURE insert_employee(
    employee_first_name IN EMPLOYEES.FIRST_NAME%TYPE DEFAULT 'Jan',
    employee_last_name IN EMPLOYEES.LAST_NAME%TYPE DEFAULT 'Kowalski',
    employee_email IN EMPLOYEES.EMAIL%TYPE DEFAULT 'jan.kowalski@wp.pl',
    employee_phone_number IN EMPLOYEES.PHONE_NUMBER%TYPE DEFAULT '123456789',
    employee_hire_date IN EMPLOYEES.HIRE_DATE%TYPE DEFAULT TO_DATE('2023-11-26', 'YYYY-MM-DD'),
    employee_commission_pct IN EMPLOYEES.COMMISSION_PCT%TYPE DEFAULT NULL,
    employee_manager_id IN EMPLOYEES.MANAGER_ID%TYPE DEFAULT NULL,
    employee_job_id IN EMPLOYEES.JOB_ID%TYPE DEFAULT 'AD_VP',
    employee_department_id IN EMPLOYEES.DEPARTMENT_ID%TYPE DEFAULT NULL,
    employee_salary in EMPLOYEES.SALARY%TYPE
) IS
generated_employee_id EMPLOYEES.EMPLOYEE_ID%TYPE;
TOO_HIGH_SALARY EXCEPTION;
PRAGMA EXCEPTION_INIT(TOO_HIGH_SALARY, -20000);
BEGIN
    IF employee_salary > 20000 THEN
        RAISE TOO_HIGH_SALARY;
    ELSE
        SELECT employees_seq.NEXTVAL INTO generated_employee_id FROM DUAL;
        INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
        VALUES (generated_employee_id, employee_first_name, employee_last_name, employee_email, employee_phone_number, employee_hire_date, employee_job_id, employee_salary, employee_commission_pct, employee_manager_id, employee_department_id);
    END IF;
    EXCEPTION WHEN TOO_HIGH_SALARY THEN
    DBMS_OUTPUT.PUT_LINE('Wynagrodzenie większe od 20000. Kod błędu: ' || SQLCODE);
END;

BEGIN
    insert_employee(employee_salary => 2000);
end;
