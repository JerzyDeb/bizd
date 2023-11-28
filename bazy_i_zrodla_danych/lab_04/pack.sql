CREATE OR REPLACE PACKAGE xd IS
    FUNCTION get_job_name(job_id_p JOBS.JOB_ID%TYPE) RETURN JOBS.JOB_TITLE%TYPE;
    FUNCTION get_employee_full_salary(employee_id_p EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN EMPLOYEES.SALARY%TYPE;
    FUNCTION get_number_prefix(number VARCHAR2) RETURN VARCHAR2;
    FUNCTION change_letters(given_text VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_birth_date(pesel VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_country_employees_departments(
        country_name_input IN COUNTRIES.COUNTRY_NAME%TYPE,
        departments_count OUT NUMBER,
        employees_count OUT NUMBER
    ) RETURN BOOLEAN;
    PROCEDURE add_to_archive(ID IN DEPARTMENTS.DEPARTMENT_ID%TYPE, NAME IN DEPARTMENTS.DEPARTMENT_NAME%TYPE, MANAGER IN DEPARTMENTS.MANAGER_ID%TYPE);
    PROCEDURE catch_burglar(NEW_SALARY IN EMPLOYEES.SALARY%TYPE);
    PROCEDURE employee_seq;
    PROCEDURE prevent_job_grades_operations;
    PROCEDURE prevent_job_salaries(OLD_MIN_SALARY IN OUT JOBS.MIN_SALARY%TYPE,OLD_MAX_SALARY IN OUT JOBS.MAX_SALARY%TYPE);
END xd;


CREATE OR REPLACE PACKAGE BODY xd IS
    -- ZADANIE 1
    FUNCTION get_job_name(job_id_p JOBS.JOB_ID%TYPE)
    RETURN JOBS.JOB_TITLE%TYPE IS
    result JOBS.JOB_TITLE%TYPE;
    BEGIN
        SELECT JOB_TITLE INTO result
        FROM JOBS
        WHERE JOB_ID = job_id_p;
        RETURN result;

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brak pracy o takim ID. Kod błędu: ' || SQLCODE);
        RETURN NULL;
    END get_job_name;

    ------------------------------------------
    -- ZADANIE 2
    FUNCTION get_employee_full_salary(employee_id_p EMPLOYEES.EMPLOYEE_ID%TYPE)
    RETURN EMPLOYEES.SALARY%TYPE IS
    result EMPLOYEES.SALARY%TYPE;
    year_salary EMPLOYEES.SALARY%TYPE;
    pct NUMBER;
    BEGIN
        SELECT SALARY * 12, COMMISSION_PCT INTO year_salary, pct
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = employee_id_p;
        IF pct IS NULL THEN
            pct := 1;
        END IF;
        result := year_salary * pct;
        RETURN result;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brak pracownika o takim ID. Kod błędu: ' || SQLCODE);
        RETURN NULL;
    END get_employee_full_salary;

    ------------------------------------------
    -- ZADANIE 3
    FUNCTION get_number_prefix(number VARCHAR2)
    RETURN VARCHAR2 IS
    prefix VARCHAR2(5);
    BEGIN
        prefix := '(' || SUBSTR(number, 1, 3) || ')';
        RETURN prefix;
    END get_number_prefix;

    ------------------------------------------
    -- ZADANIE 4
    FUNCTION change_letters(given_text VARCHAR2)
    RETURN VARCHAR2 IS
    new_text VARCHAR2(255);
    BEGIN
        new_text := UPPER(SUBSTR(given_text, 1, 1)) || LOWER(SUBSTR(given_text, 2, LENGTH(given_text) -2)) || UPPER(SUBSTR(given_text, LENGTH(given_text) -1, 1));
        RETURN new_text;
    END change_letters;

    ------------------------------------------
    -- ZADANIE 5
    FUNCTION get_birth_date(pesel VARCHAR2)
    RETURN VARCHAR2 IS
    birth_date VARCHAR2(10);
    year VARCHAR2(4);
    month VARCHAR2(2);
    day VARCHAR2(2);
    BEGIN
        IF TO_NUMBER(SUBSTR(PESEL, 1, 2)) < 20 THEN
            year := '20' || SUBSTR(PESEL, 1, 2);
        ELSE
            year := '19' || SUBSTR(PESEL, 1, 2);
        END IF;
        month := SUBSTR(PESEL, 3, 2);
        day := SUBSTR(PESEL, 5, 2);
        birth_date := year || '-' || month || '-' || day;
        RETURN birth_date;
    END get_birth_date;

    ------------------------------------------
    -- ZADANIE 6
    FUNCTION get_country_employees_departments(
        country_name_input IN COUNTRIES.COUNTRY_NAME%TYPE,
        departments_count OUT NUMBER,
        employees_count OUT NUMBER
    ) RETURN BOOLEAN IS
    BEGIN
        SELECT
        COUNT(DISTINCT DEPARTMENTS.DEPARTMENT_ID),
        COUNT(DISTINCT EMPLOYEES.EMPLOYEE_ID)
        INTO  departments_count, employees_count
        FROM DEPARTMENTS
        INNER JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID
        INNER JOIN COUNTRIES ON LOCATIONS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        LEFT JOIN EMPLOYEES ON DEPARTMENTS.DEPARTMENT_ID = EMPLOYEES.DEPARTMENT_ID
        WHERE COUNTRIES.COUNTRY_NAME = country_name_input;
        RETURN TRUE;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Brak państwa o takiej nazwie. Kod błędu: ' || SQLCODE);
            RETURN FALSE;

            WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Więcej niż 1 państwo o takiej nazwie. Kod błędu: ' || SQLCODE);
            RETURN FALSE;
    END get_country_employees_departments;

    ------------------------------------------
    -- ZADANIE 7
    PROCEDURE add_to_archive(ID IN DEPARTMENTS.DEPARTMENT_ID%TYPE, NAME IN DEPARTMENTS.DEPARTMENT_NAME%TYPE, MANAGER IN DEPARTMENTS.MANAGER_ID%TYPE) IS
        last_manager VARCHAR(255);
    BEGIN
        SELECT FIRST_NAME || ' ' || LAST_NAME INTO last_manager FROM EMPLOYEES WHERE EMPLOYEE_ID = MANAGER;
        INSERT INTO DEPARTMENTS_ARCHIVE (DEPARTMENT_ID, DEPARTMENT_NAME, CLOSED_DATE, LAST_MANAGER)
        VALUES (ID, NAME, SYSDATE, last_manager);
    END add_to_archive;
    ------------------------------------------
    -- ZADANIE 8

    PROCEDURE catch_burglar(NEW_SALARY IN EMPLOYEES.SALARY%TYPE) IS
    BEGIN
        IF NEW_SALARY < 2000 OR NEW_SALARY > 26000 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Błędne zarobki.');
        END IF;
    END catch_burglar;
    ------------------------------------------
    -- ZADANIE 9

    PROCEDURE employee_seq IS
    BEGIN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE new_employee_seq START WITH 1 INCREMENT BY 1';
    END employee_seq;
    ------------------------------------------
    -- ZADANIE 10

    PROCEDURE prevent_job_grades_operations IS
    BEGIN
        RAISE_APPLICATION_ERROR(-20001, 'Operacja niedozwolona.');
    END prevent_job_grades_operations;

    ------------------------------------------
    -- ZADANIE 10
    PROCEDURE prevent_job_salaries(OLD_MIN_SALARY IN OUT JOBS.MIN_SALARY%TYPE,OLD_MAX_SALARY IN OUT JOBS.MAX_SALARY%TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Nie można zmienić ceny');
    END prevent_job_salaries;
END xd;


------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER xddd
    AFTER DELETE
    ON DEPARTMENTS
    FOR EACH ROW
BEGIN
    xd.ADD_TO_ARCHIVE(:OLD.DEPARTMENT_ID, :OLD.DEPARTMENT_NAME, :OLD.MANAGER_ID);
END;

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES (300, 'EDUCATION', 205, 1700);
DELETE
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'EDUCATION';
------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER xddd1
    AFTER DELETE
    ON DEPARTMENTS
    FOR EACH ROW
BEGIN
    xd.ADD_TO_ARCHIVE(:OLD.DEPARTMENT_ID, :OLD.DEPARTMENT_NAME, :OLD.MANAGER_ID);
END;


------------------------------------------------------------------------------------------------------------