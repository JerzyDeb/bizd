CREATE OR REPLACE PACKAGE FUNCTIONS_PACK IS
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
END FUNCTIONS_PACK;

CREATE OR REPLACE PACKAGE BODY FUNCTIONS_PACK IS

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
    END;

    ------------------------------------------

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
    END;

    ------------------------------------------

    FUNCTION get_number_prefix(number VARCHAR2)
    RETURN VARCHAR2 IS
    prefix VARCHAR2(5);
    BEGIN
        prefix := '(' || SUBSTR(number, 1, 3) || ')';
        RETURN prefix;
    END;

    ------------------------------------------

    FUNCTION change_letters(given_text VARCHAR2)
    RETURN VARCHAR2 IS
    new_text VARCHAR2(255);
    BEGIN
        new_text := UPPER(SUBSTR(given_text, 1, 1)) || LOWER(SUBSTR(given_text, 2, LENGTH(given_text) -2)) || UPPER(SUBSTR(given_text, LENGTH(given_text) -1, 1));
        RETURN new_text;
    END;

    ------------------------------------------

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
    END;

    ------------------------------------------

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
    END;

END FUNCTIONS_PACK;