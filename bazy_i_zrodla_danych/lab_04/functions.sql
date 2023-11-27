-- ZADANIE 1

CREATE OR REPLACE FUNCTION get_job_name(job_id_p JOBS.JOB_ID%TYPE)
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
END;

DECLARE
    job_name JOBS.JOB_TITLE%TYPE;
BEGIN
    job_name := get_job_name(1);
    DBMS_OUTPUT.PUT_LINE('Praca: ' || job_name);
END;


-- ZADANIE 2

CREATE OR REPLACE FUNCTION get_employee_full_salary(employee_id_p EMPLOYEES.EMPLOYEE_ID%TYPE)
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
END;

DECLARE
    employee_salary EMPLOYEES.SALARY%TYPE;
BEGIN
    employee_salary := get_employee_full_salary(100);
    DBMS_OUTPUT.PUT_LINE('Całkowita wypłata: ' || employee_salary);
END;


-- ZADANIE 3

CREATE OR REPLACE FUNCTION get_number_prefix(number VARCHAR2)
RETURN VARCHAR2 IS
prefix VARCHAR2(5);
BEGIN
    prefix := '(' || SUBSTR(number, 1, 3) || ')';
    RETURN prefix;
END;

DECLARE
    number_prefix VARCHAR2(5);
BEGIN
    number_prefix := get_number_prefix('+48731472623');
    DBMS_OUTPUT.PUT_LINE('Numer kierunkowy: ' || number_prefix);
END;


-- ZADANIE 4

CREATE OR REPLACE FUNCTION change_letters(given_text VARCHAR2)
RETURN VARCHAR2 IS
new_text VARCHAR2(255);
BEGIN
    new_text := UPPER(SUBSTR(given_text, 1, 1)) || LOWER(SUBSTR(given_text, 2, LENGTH(given_text) -2)) || UPPER(SUBSTR(given_text, LENGTH(given_text) -1, 1));
    RETURN new_text;
END;

DECLARE
    new_text VARCHAR2(255);
BEGIN
    new_text := change_letters('aaaABbbbbCccc');
    DBMS_OUTPUT.PUT_LINE('Zamieniony tekst: ' || new_text);
END;


-- ZADANIE 5

CREATE OR REPLACE FUNCTION get_birth_date(pesel VARCHAR2)
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
END;

DECLARE
    birth_date VARCHAR2(10);
BEGIN
    birth_date := get_birth_date('98041711987');
    DBMS_OUTPUT.PUT_LINE('Data urodzenia: ' || birth_date);
END;


-- ZADANIE 6

CREATE OR REPLACE FUNCTION get_country_employees_departments(
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

END;


DECLARE
    result BOOLEAN;
    departments_count NUMBER;
    employees_count NUMBER;
BEGIN
    result := get_country_employees_departments('United States of America', departments_count,employees_count);
    DBMS_OUTPUT.PUT_LINE('Liczba departamentów: ' || departments_count);
    DBMS_OUTPUT.PUT_LINE('Liczba pracowników: ' || employees_count);
END;