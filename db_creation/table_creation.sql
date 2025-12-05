DROP TABLE IF EXISTS employee_planned_activity CASCADE;
DROP TABLE IF EXISTS employee_skill_set CASCADE;
DROP TABLE IF EXISTS person_phone CASCADE;
DROP TABLE IF EXISTS salary CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS phone CASCADE;
DROP TABLE IF EXISTS skill_set CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS job_title CASCADE;
DROP TABLE IF EXISTS planned_activity CASCADE;
DROP TABLE IF EXISTS course_instance CASCADE;
DROP TABLE IF EXISTS course_layout CASCADE;
DROP TABLE IF EXISTS rules CASCADE;
DROP TABLE IF EXISTS teaching_activity CASCADE;
DROP TABLE IF EXISTS exam_hours_factors CASCADE;
DROP TABLE IF EXISTS admin_hours_factors CASCADE;


--CREATE TYPE period AS ENUM ('1', '2', '3', '4');


CREATE TABLE teaching_activity (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	activity_name VARCHAR(50) UNIQUE NOT NULL,
	factor DECIMAL(4,2) DEFAULT 1.0
);

CREATE TABLE planned_activity (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	course_instance_id INT NOT NULL,
	planned_hours INT NOT NULL,
	teaching_activity_id INT NOT NULL
);


CREATE TABLE course_instance (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	instance_id VARCHAR(50) UNIQUE NOT NULL,
	num_students INT NOT NULL,
	study_year VARCHAR(4) NOT NULL,
	course_layout_id INT NOT NULL
);

CREATE TABLE course_layout (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	course_code VARCHAR(50) NOT NULL,
	course_name VARCHAR(100) NOT NULL,
	min_students INT NOT NULL,
	max_students INT NOT NULL,
	hp DECIMAL(3,1),
	is_active BOOLEAN DEFAULT TRUE,
	study_period period NOT NULL
);

CREATE TABLE rules (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	allocation_limit INT
);

CREATE TABLE exam_hours_factors (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	exam_f1 DECIMAL(5,3),
	exam_f2 DECIMAL(5,3)
);

CREATE TABLE admin_hours_factors (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	admin_f1 DECIMAL(5,3),
	admin_f2 DECIMAL(5,3),
	admin_f3 DECIMAL(5,3)
);

INSERT INTO rules (allocation_limit)
VALUES (4);


--Examination hour = 32+ 0.725* #Students 
INSERT INTO exam_hours_factors (exam_f1, exam_f2)
VALUES (32, 0.725); 


--Admin hours = 2*HP+ 28+ 0.2* #Students 
INSERT INTO admin_hours_factors (admin_f1, admin_f2, admin_f3)
VALUES (2, 28, 0.2);

--course_instance
ALTER TABLE course_instance
ADD CONSTRAINT fk_course_layout_id
FOREIGN KEY (course_layout_id)
REFERENCES course_layout(id);

--planned_activity
ALTER TABLE planned_activity
ADD CONSTRAINT fk_course_instance_id
FOREIGN KEY (course_instance_id)
REFERENCES course_instance(id);


ALTER TABLE planned_activity
ADD CONSTRAINT fk_teaching_activity_id
FOREIGN KEY (teaching_activity_id)
REFERENCES teaching_activity(id);


CREATE TABLE job_title (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	job_title VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE department (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	department_name VARCHAR(50) NOT NULL UNIQUE,
	manager_id INT
);
CREATE TABLE skill_set (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	skill VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE phone (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	phone_number VARCHAR(15) NOT NULL UNIQUE
);
CREATE TABLE salary (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	salary_amount INT NOT NULL,
	date_given DATE NOT NULL,
	employee_id INT NOT NULL,
	is_current BOOLEAN
);

CREATE TABLE person (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	personal_number VARCHAR(12) NOT NULL UNIQUE,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	street VARCHAR(100) NOT NULL,
	zip VARCHAR(6) NOT NULL
);

CREATE TABLE employee (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	employment_id INT GENERATED ALWAYS AS IDENTITY,
	job_title_id INT NOT NULL,
	person_id INT NOT NULL,
	department_id INT NOT NULL,
	manager_id INT,
	is_active BOOLEAN
);

CREATE TABLE employee_skill_set (
	skill_set_id INT NOT NULL,
	employee_id INT NOT NULL,
	PRIMARY KEY(skill_set_id,employee_id)
);

CREATE TABLE person_phone (
	person_id INT NOT NULL,
	phone_id INT NOT NULL,
	PRIMARY KEY (person_id, phone_id)
);

CREATE TABLE employee_planned_activity (
	employee_id INT NOT NULL,
	planned_activity_id INT,
	allocated_hours INT,
	PRIMARY KEY(employee_id,planned_activity_id)
);

--employee
ALTER TABLE employee
ADD CONSTRAINT fk_job_title_id
FOREIGN KEY (job_title_id)
REFERENCES job_title(id);

ALTER TABLE employee
ADD CONSTRAINT fk_person_id
FOREIGN KEY (person_id)
REFERENCES person(id);

ALTER TABLE employee
ADD CONSTRAINT fk_department_id
FOREIGN KEY (department_id)
REFERENCES department(id);

ALTER TABLE employee
ADD CONSTRAINT fk_manager_id__emp
FOREIGN KEY (manager_id)
REFERENCES employee(id);

--salary
ALTER TABLE salary
ADD CONSTRAINT fk_employee_id__salary
FOREIGN KEY (employee_id)
REFERENCES employee(id);

--department
ALTER TABLE department
ADD CONSTRAINT fk_manager_id__dep
FOREIGN KEY (manager_id)
REFERENCES employee(id);

--person phone
ALTER TABLE person_phone
ADD CONSTRAINT fk_person_id
FOREIGN KEY (person_id)
REFERENCES person(id);

ALTER TABLE person_phone
ADD CONSTRAINT fk_phone_id
FOREIGN KEY (phone_id)
REFERENCES phone(id)
ON DELETE CASCADE;

--employee skill set
ALTER TABLE employee_skill_set
ADD CONSTRAINT fk_employee_id__emp_skillset
FOREIGN KEY (employee_id)
REFERENCES employee(id);

ALTER TABLE employee_skill_set
ADD CONSTRAINT fk_skill_set_id
FOREIGN KEY (skill_set_id)
REFERENCES skill_set(id)
ON DELETE CASCADE;

--employee planned activity
ALTER TABLE employee_planned_activity
ADD CONSTRAINT fk_employee_id__emp_plannedactivity
FOREIGN KEY (employee_id)
REFERENCES employee(id);

ALTER TABLE employee_planned_activity
ADD CONSTRAINT fk_planned_activity_id
FOREIGN KEY (planned_activity_id) 
REFERENCES planned_activity(id)
ON DELETE CASCADE;




---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Trigger part----------------------------------------------

/*
--automatically calcualte and assign exam hours to one teacher
CREATE OR REPLACE FUNCTION calculate_exam_hours()
RETURNS TRIGGER AS $$
BEGIN
    --Delete existing exam planned activity for this course instance
    DELETE FROM planned_activity
    WHERE course_instance_id = NEW.id
      AND teaching_activity_id = (SELECT id FROM teaching_activity WHERE activity_name = 'Examination');
    

    INSERT INTO planned_activity(course_instance_id, planned_hours, teaching_activity_id)
    SELECT 
        NEW.id, 
        ROUND(ef.exam_f1 + ef.exam_f2 * NEW.num_students),
        ta.id
    FROM teaching_activity AS ta
    CROSS JOIN exam_hours_factors AS ef
    WHERE ta.activity_name = 'Examination'
      AND ef.id = (SELECT MAX(id) FROM exam_hours_factors);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calc_exam_hours
AFTER INSERT OR UPDATE ON course_instance
FOR EACH ROW
EXECUTE FUNCTION calculate_exam_hours();



--automatically calcualte and assign admin hours to one teacher
CREATE OR REPLACE FUNCTION calculate_admin_hours()
RETURNS TRIGGER AS $$

BEGIN
    --Delete existing admin planned activity for this course instance
    DELETE FROM planned_activity
    WHERE course_instance_id = NEW.id
      AND teaching_activity_id = (SELECT id FROM teaching_activity WHERE activity_name = 'Administration');
    
    --Insert new admin planned activity
    INSERT INTO planned_activity(course_instance_id, planned_hours, teaching_activity_id)
    SELECT 
        NEW.id, 
        ROUND(af.admin_f1 * cl.hp + af.admin_f2 + af.admin_f3 * NEW.num_students),
        ta.id
    FROM teaching_activity AS ta
    CROSS JOIN admin_hours_factors AS af
    JOIN course_layout AS cl ON cl.id = NEW.course_layout_id
    WHERE ta.activity_name = 'Administration'
      AND af.id = (SELECT MAX(id) FROM admin_hours_factors);
	 
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calc_admin_hours
AFTER INSERT OR UPDATE ON course_instance
FOR EACH ROW
EXECUTE FUNCTION calculate_admin_hours();



*/

--automatically calcualte and assign admin hours to one teacher
CREATE OR REPLACE FUNCTION calculate_admin_hours()
RETURNS TRIGGER AS $$
DECLARE
    old_activity_id INT;
    new_activity_id INT;
BEGIN
    -- Get the old admin activity ID if it exists
    SELECT id INTO old_activity_id
    FROM planned_activity
    WHERE course_instance_id = NEW.id
      AND teaching_activity_id = (SELECT id FROM teaching_activity WHERE activity_name = 'Administration')
    LIMIT 1;
    
    --Insert new admin planned activity
    INSERT INTO planned_activity(course_instance_id, planned_hours, teaching_activity_id)
    SELECT 
        NEW.id, 
        ROUND(af.admin_f1 * cl.hp + af.admin_f2 + af.admin_f3 * NEW.num_students),
        ta.id
    FROM teaching_activity AS ta
    CROSS JOIN admin_hours_factors AS af
    JOIN course_layout AS cl ON cl.id = NEW.course_layout_id
    WHERE ta.activity_name = 'Administration'
      AND af.id = (SELECT MAX(id) FROM admin_hours_factors)
    RETURNING id INTO new_activity_id;
    
    --If old activity existed transfer allocations to new activity
    IF old_activity_id IS NOT NULL THEN
        UPDATE employee_planned_activity
        SET planned_activity_id = new_activity_id,
            allocated_hours = (
                SELECT planned_hours 
                FROM planned_activity 
                WHERE id = new_activity_id
            )
        WHERE planned_activity_id = old_activity_id;
        
        
        DELETE FROM planned_activity WHERE id = old_activity_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER calc_admin_hours
AFTER INSERT OR UPDATE ON course_instance
FOR EACH ROW
EXECUTE FUNCTION calculate_admin_hours();




--automatically calcualte and assign exam hours to one teacher
CREATE OR REPLACE FUNCTION calculate_exam_hours()
RETURNS TRIGGER AS $$
DECLARE
    old_activity_id INT;
    new_activity_id INT;
BEGIN
    --Get the old exam activity ID if it exists
    SELECT id INTO old_activity_id
    FROM planned_activity
    WHERE course_instance_id = NEW.id
      AND teaching_activity_id = (SELECT id FROM teaching_activity WHERE activity_name = 'Examination')
    LIMIT 1;
    
    --Insert new exam planned activity
    INSERT INTO planned_activity(course_instance_id, planned_hours, teaching_activity_id)
    SELECT 
        NEW.id, 
        ROUND(ef.exam_f1 + ef.exam_f2 * NEW.num_students),
        ta.id
    FROM teaching_activity AS ta
    CROSS JOIN exam_hours_factors AS ef
    WHERE ta.activity_name = 'Examination'
      AND ef.id = (SELECT MAX(id) FROM exam_hours_factors)
    RETURNING id INTO new_activity_id;
    
    --If old activity existed transfer allocations to new activity
    IF old_activity_id IS NOT NULL THEN
        UPDATE employee_planned_activity
        SET planned_activity_id = new_activity_id,
            allocated_hours = (
                SELECT planned_hours 
                FROM planned_activity 
                WHERE id = new_activity_id
            )
        WHERE planned_activity_id = old_activity_id;
        
        
        DELETE FROM planned_activity WHERE id = old_activity_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER calc_exam_hours
AFTER INSERT OR UPDATE ON course_instance
FOR EACH ROW
EXECUTE FUNCTION calculate_exam_hours();




-----------------------------------------------------------------------------------------------------------
--generate course instance id
CREATE OR REPLACE FUNCTION generate_course_instance_id()
RETURNS TRIGGER AS $$
DECLARE 
	code VARCHAR;
BEGIN
	SELECT course_code INTO code
	FROM course_layout	
	WHERE NEW.course_layout_id = course_layout.id;


    NEW.instance_id := NEW.study_year || '-' || code || '-' || SUBSTRING(MD5(random()::text || clock_timestamp()::text) FROM 1 FOR 4);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_course_instance_id
BEFORE INSERT ON course_instance
FOR EACH ROW
EXECUTE FUNCTION generate_course_instance_id();





--allocation limit for teachers
CREATE OR REPLACE FUNCTION reject_if_more_than_limit_per_period()
RETURNS TRIGGER AS $$
DECLARE
    activity_count INT;
    activity_limit INT;
    new_period period;
BEGIN
--get the period for the new planned_activity
    SELECT cl.study_period
    INTO new_period
    FROM planned_activity pa
    JOIN course_instance ci ON pa.course_instance_id = ci.id
    JOIN course_layout cl ON ci.course_layout_id = cl.id
    WHERE pa.id = NEW.planned_activity_id;

--get the maximum allowed number of allocations (from rules table)
    SELECT allocation_limit
    INTO activity_limit
    FROM rules
    LIMIT 1;

--count existing activities for this employee in the same period
    SELECT COUNT(DISTINCT ci.id)
    INTO activity_count
    FROM employee_planned_activity epa
    JOIN planned_activity pa ON epa.planned_activity_id = pa.id
    JOIN course_instance ci ON pa.course_instance_id = ci.id
    JOIN course_layout cl ON ci.course_layout_id = cl.id
    WHERE epa.employee_id = NEW.employee_id AND cl.study_period = new_period;


    IF activity_count >= activity_limit THEN
        RAISE EXCEPTION 'Employee exceeds allocation limit (% activities) in period %',
            activity_limit, new_period;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reject_if_more_than_limit_per_period
BEFORE INSERT ON employee_planned_activity
FOR EACH ROW
EXECUTE FUNCTION reject_if_more_than_limit_per_period();


--------------------------



-- update is_current for salary when new row is inserted
CREATE OR REPLACE FUNCTION update_salary_is_current()
RETURNS TRIGGER AS $$
DECLARE
    most_recent_date date;
BEGIN
    SELECT MAX(date_given)
    INTO most_recent_date
    FROM salary
    WHERE employee_id = NEW.employee_id AND id <> NEW.id;

    IF most_recent_date is NULL OR NEW.date_given >= most_recent_date THEN
        UPDATE salary
        SET is_current = FALSE
        WHERE employee_id = NEW.employee_id AND id <> NEW.id;
        NEW.is_current = TRUE;
    ELSE
        NEW.is_current = FALSE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_salary_is_current
BEFORE INSERT ON salary
FOR EACH ROW
EXECUTE FUNCTION update_salary_is_current();




-- update is_active for course layout
CREATE OR REPLACE FUNCTION update_course_layout_is_active()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE course_layout
    SET is_active = FALSE
    WHERE course_code = NEW.course_code AND study_period = NEW.study_period AND id <> NEW.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_course_layout_is_active
AFTER INSERT ON course_layout
FOR EACH ROW
EXECUTE FUNCTION update_course_layout_is_active();




--trigger to check if num_students of each instance is between the minimum and maximum in course_layout 
CREATE OR REPLACE FUNCTION check_num_students()
RETURNS TRIGGER AS $$
DECLARE
	layout_min_students INT;
	layout_max_students INT;
BEGIN
	SELECT course_layout.min_students, course_layout.max_students
	INTO layout_min_students, layout_max_students
	FROM course_layout
	WHERE course_layout.id = NEW.course_layout_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Cannot find course layout for id: %', NEW.id;
	END IF;

	IF NEW.num_students < layout_min_students THEN
		RAISE EXCEPTION 'Number of students (%) is below minimum (%)', NEW.num_students, layout_min_students;
    END IF;

	IF NEW.num_students > layout_max_students THEN
		RAISE EXCEPTION 'Number of students (%) is above maximum (%)', NEW.num_students, layout_max_students;
	END IF;


	
	RETURN NEW;

END;

$$ LANGUAGE plpgsql;


CREATE TRIGGER validate_num_students
	BEFORE INSERT OR UPDATE OF num_students
	ON course_instance 
	FOR EACH ROW 
	EXECUTE FUNCTION check_num_students();





---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------VIEW part----------------------------------------------


--View for average teacher salary
CREATE OR REPLACE VIEW avg_teacher_salary AS
SELECT AVG(s.salary_amount) AS avg_salary
FROM salary AS s
WHERE s.is_current = TRUE;

SELECT * FROM avg_teacher_salary;



--view for planned cost
CREATE OR REPLACE VIEW planned_cost AS
SELECT 
	ci.id,
	cl.course_code,
    ci.instance_id,
    cl.study_period,
    ci.study_year,
	ci.num_students,
	SUM(pa.planned_hours * ta.factor) * (SELECT avg_salary FROM avg_teacher_salary) / 1000 AS planned_cost_ksek
FROM course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id = cl.id
JOIN planned_activity AS pa ON pa.course_instance_id = ci.id
JOIN teaching_activity AS ta ON ta.id = pa.teaching_activity_id
GROUP BY ci.id, cl.course_code, ci.instance_id, cl.study_period, ci.study_year;

--view for actual allocated cost
CREATE OR REPLACE VIEW allocated_cost AS
SELECT 
	ci.id,
    cl.course_code,
	SUM(emp_pa.allocated_hours * ta.factor * s.salary_amount) / 1000 AS allocated_cost_ksek
FROM course_instance AS ci	
JOIN course_layout AS cl ON ci.course_layout_id = cl.id
JOIN planned_activity AS pa ON pa.course_instance_id = ci.id
JOIN employee_planned_activity AS emp_pa ON emp_pa.planned_activity_id = pa.id
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
JOIN employee e ON e.id = emp_pa.employee_id
JOIN salary s ON s.employee_id = e.id
WHERE s.is_current = TRUE
GROUP BY ci.id,cl.course_code,ci.instance_id,cl.study_period,ci.study_year;