


--generate course instance id
CREATE OR REPLACE FUNCTION generate_course_instance_id()
RETURNS TRIGGER AS $$
DECLARE 
	code VARCHAR;
BEGIN
	SELECT course_code INTO code
	FROM course_layout	
	WHERE NEW.course_layout_id = course_layout.id;


    NEW.instance_id := NEW.study_year || '-' || code || '-' || floor(random() * 1000)::int;
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
    SELECT COUNT(*)
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


