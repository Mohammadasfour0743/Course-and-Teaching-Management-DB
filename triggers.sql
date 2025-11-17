
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


