-- ZADANIE 1

CREATE TABLE DEPARTMENTS_ARCHIVE
(
    DEPARTMENT_ID   NUMBER,
    DEPARTMENT_NAME VARCHAR(255),
    CLOSED_DATE     DATE,
    LAST_MANAGER    VARCHAR(255)
);

CREATE OR REPLACE TRIGGER add_to_archive
    AFTER DELETE
    ON DEPARTMENTS
    FOR EACH ROW
DECLARE
    manager VARCHAR(255);
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME INTO manager FROM EMPLOYEES WHERE EMPLOYEE_ID = :OLD.MANAGER_ID;
    INSERT INTO DEPARTMENTS_ARCHIVE (DEPARTMENT_ID, DEPARTMENT_NAME, CLOSED_DATE, LAST_MANAGER)
    VALUES (:OLD.DEPARTMENT_ID, :OLD.DEPARTMENT_NAME, SYSDATE, manager);
END;

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES (300, 'EDUCATION', 205, 1700);
DELETE
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'EDUCATION';


-- ZADANIE 2

CREATE TABLE BURGLARS(
    BURGLAR_ID NUMBER GENERATED BY DEFAULT AS IDENTITY,
    ADDING_BY VARCHAR2(255),
    DATA DATE
);

CREATE OR REPLACE TRIGGER catch_burglar
BEFORE INSERT OR UPDATE ON EMPLOYEES
FOR EACH ROW
BEGIN
    IF :NEW.SALARY < 2000 OR :NEW.SALARY > 26000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Błędne zarobki.');
    END IF;
END;

BEGIN
    INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
    VALUES (567, 'Jan', 'Kowalski', 'jkow@wp.pl', '123456789', TO_DATE('2023-11-26', 'YYYY-MM-DD'), 'AD_VP', 27000, NULL, NULL, NULL);
    EXCEPTION WHEN OTHERS THEN
        INSERT INTO BURGLARS (ADDING_BY, DATA)
        VALUES (USER, SYSDATE);
        DBMS_OUTPUT.PUT_LINE('Błędne zarobki');
END;
select * from burglars;

-- ZADANIE 3

CREATE SEQUENCE new_employee_seq;
CREATE OR REPLACE TRIGGER employee_sequence
BEFORE INSERT ON EMPLOYEES
FOR EACH ROW
BEGIN
    SELECT new_employee_seq.NEXTVAL INTO :NEW.EMPLOYEE_ID FROM DUAL;
END;

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (555, 'Jan', 'Kowalski', 'jkow@wp.pl', '123456789', TO_DATE('2023-11-26', 'YYYY-MM-DD'), 'AD_VP', 2000, NULL, NULL, NULL);


-- ZADANIE 4

CREATE OR REPLACE TRIGGER prevent_job_grades_operations
BEFORE INSERT OR UPDATE OR DELETE ON JOB_GRADES
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'Operacja niedozwolona.');
END;
BEGIN
    INSERT INTO JOB_GRADES (GRADE, MIN_SALARY, MAX_SALARY)
    VALUES ('A', 123, 456);
    DELETE FROM JOB_GRADES WHERE GRADE='A';
    UPDATE JOB_GRADES SET GRADE='B' WHERE GRADE='A';
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Zła akcja');
END;


-- ZADANIE 5

CREATE OR REPLACE TRIGGER prevent_job_salaries
BEFORE UPDATE ON JOBS
FOR EACH ROW
BEGIN
    :NEW.MIN_SALARY := :OLD.MIN_SALARY;
    :NEW.MAX_SALARY := :OLD.MAX_SALARY;
END;
UPDATE JOBS SET MIN_SALARY=111, MAX_SALARY=222 WHERE JOB_ID='AD_VP';