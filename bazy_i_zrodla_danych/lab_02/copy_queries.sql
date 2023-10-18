CREATE TABLE jobs AS SELECT * FROM hr.jobs;
CREATE TABLE job_history AS SELECT * FROM hr.job_history;
CREATE TABLE employees AS SELECT * FROM hr.employees;
CREATE TABLE job_grades AS SELECT * FROM hr.job_grades;
CREATE TABLE regions AS SELECT * FROM hr.regions;
CREATE TABLE locations AS SELECT * FROM hr.locations;
CREATE TABLE departments AS SELECT * FROM hr.departments;
CREATE TABLE countries AS SELECT * FROM hr.countries;

ALTER TABLE jobs ADD PRIMARY KEY(job_id);
ALTER TABLE job_history ADD PRIMARY KEY(employee_id, start_date);
ALTER TABLE employees ADD PRIMARY KEY(employee_id);
ALTER TABLE job_grades ADD PRIMARY KEY(grade);
ALTER TABLE regions ADD PRIMARY KEY(region_id);
ALTER TABLE locations ADD PRIMARY KEY(location_id);
ALTER TABLE departments ADD PRIMARY KEY(department_id);
ALTER TABLE countries ADD PRIMARY KEY(country_id);


ALTER TABLE departments
    MODIFY(
        manager_id REFERENCES employees(employee_id),
        location_id REFERENCES locations(location_id)
    );

ALTER TABLE employees
    MODIFY(
        manager_id REFERENCES employees(employee_id),
        job_id  REFERENCES jobs(job_id),
        department_id REFERENCES departments(department_id)
    );

ALTER TABLE locations
    MODIFY(
        country_id REFERENCES countries(country_id)
    );


ALTER TABLE countries
    MODIFY(
        region_id REFERENCES regions(region_id)
    );


ALTER TABLE job_history
    MODIFY(
        employee_id REFERENCES employees(employee_id),
        department_id REFERENCES departments(department_id),
        job_id REFERENCES jobs(job_id)
    );


