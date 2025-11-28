
--Check that total allocated hours for an activity is less than the planned hours
CREATE OR REPLACE FUNCTION validate_allocated_hours()
RETURNS TRIGGER AS $$
DECLARE
    total_allocated INT;
    total_planned INT;
BEGIN
    -- Get total planned hours for this activity
    SELECT planned_hours INTO total_planned
    FROM planned_activity
    WHERE id = NEW.planned_activity_id;
    
    --Calculate total allocated hours (including this new allocation)
    SELECT COALESCE(SUM(allocated_hours), 0) + NEW.allocated_hours
    INTO total_allocated
    FROM employee_planned_activity
    WHERE planned_activity_id = NEW.planned_activity_id
      AND (employee_id != NEW.employee_id OR TG_OP = 'INSERT');
    
    
    IF total_allocated > total_planned THEN
        RAISE EXCEPTION 'Total allocated hours (%) exceeds planned hours (%) for planned_activity_id %',
            total_allocated, total_planned, NEW.planned_activity_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_allocated_hours
BEFORE INSERT OR UPDATE ON employee_planned_activity
FOR EACH ROW
EXECUTE FUNCTION validate_allocated_hours();




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


