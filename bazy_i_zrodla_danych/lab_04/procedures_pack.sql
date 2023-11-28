CREATE OR REPLACE PACKAGE PROCEDURE_PACK IS
    PROCEDURE test_get_job_name(job_id_p IN JOBS.JOB_ID%TYPE);
    PROCEDURE test_get_employee_full_salary(employee_id_p IN EMPLOYEES.EMPLOYEE_ID%TYPE);
    PROCEDURE test_get_number_prefix(number IN VARCHAR2);
    PROCEDURE test_change_letters(given_text IN VARCHAR2);
    PROCEDURE test_get_birth_date(pesel IN VARCHAR2);
    PROCEDURE get_country_employees_departments(country_name_input IN COUNTRIES.COUNTRY_NAME%TYPE);
END PROCEDURE_PACK;

CREATE OR REPLACE PACKAGE BODY PROCEDURE_PACK IS
    PROCEDURE test_get_job_name(job_id_p IN JOBS.JOB_ID%TYPE) IS
    job_name JOBS.JOB_TITLE%TYPE;
    BEGIN
        job_name := FUNCTIONS_PACK.get_job_name(job_id_p);
        DBMS_OUTPUT.PUT_LINE('Praca: ' || job_name);
    END;

    -------------------------------------------------------------------

    PROCEDURE test_get_employee_full_salary(employee_id_p IN EMPLOYEES.EMPLOYEE_ID%TYPE) IS
    employee_salary EMPLOYEES.SALARY%TYPE;
    BEGIN
        employee_salary := FUNCTIONS_PACK.get_employee_full_salary(employee_id_p);
        DBMS_OUTPUT.PUT_LINE('Całkowita wypłata: ' || employee_salary);
    END;

    -------------------------------------------------------------------

    PROCEDURE test_get_number_prefix(number IN VARCHAR2) IS
    result VARCHAR2(255);
    BEGIN
        result := FUNCTIONS_PACK.get_number_prefix('+48731472623');
        DBMS_OUTPUT.PUT_LINE('Numer kierunkowy: ' || result);
    END;

    -------------------------------------------------------------------

    PROCEDURE test_change_letters(given_text IN VARCHAR2) IS
    result VARCHAR2(255);
    BEGIN
        result := FUNCTIONS_PACK. change_letters(given_text);
        DBMS_OUTPUT.PUT_LINE('Zamieniony tekst: ' || result);
    END;

    -------------------------------------------------------------------

    PROCEDURE test_get_birth_date(pesel IN VARCHAR2) IS
    result VARCHAR2(255);
    BEGIN
        result := get_birth_date(pesel);
        DBMS_OUTPUT.PUT_LINE('Data urodzenia: ' || result);
    END;

    -------------------------------------------------------------------

    PROCEDURE get_country_employees_departments(country_name_input IN COUNTRIES.COUNTRY_NAME%TYPE) IS
    result BOOLEAN;
    departments_count NUMBER;
    employees_count NUMBER;
    BEGIN
        result := FUNCTIONS_PACK.get_country_employees_departments(country_name_input, departments_count,employees_count);
        DBMS_OUTPUT.PUT_LINE('Liczba departamentów: ' || departments_count);
        DBMS_OUTPUT.PUT_LINE('Liczba pracowników: ' || employees_count);
    END;

END PROCEDURE_PACK;