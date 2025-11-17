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
	course_layout_id INT NOT NULL,
	exam_hours_d NUMERIC,
	admin_hours_d NUMERIC
);

CREATE TABLE course_layout (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	course_code VARCHAR(50) NOT NULL,
	course_name VARCHAR(100) NOT NULL,
	min_students INT NOT NULL,
	max_students INT NOT NULL,
	hp DECIMAL(3,1),
	is_active BOOLEAN NOT NULL,
	study_period period NOT NULL
);

CREATE TABLE rules (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	allocation_limit INT
);

INSERT INTO rules (allocation_limit)
VALUES (4);

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
--??? where manager id
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
	employment_id VARCHAR(30) NOT NULL UNIQUE,
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
REFERENCES planned_activity(id);


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

--create the actual trigger
CREATE TRIGGER validate_num_students
	BEFORE INSERT OR UPDATE OF num_students
	ON course_instance 
	FOR EACH ROW 
	EXECUTE FUNCTION check_num_students();



--end trigger













