
--examination hours
CREATE OR REPLACE VIEW examination_hours AS
SELECT ci.id, cl.course_code, ci.instance_id, cl.course_name,
		(32 + 0.725*ci.num_students) AS exam_hours

FROM course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id = cl.id;



--administration hours
CREATE OR REPLACE VIEW admin_hours AS
SELECT ci.id, cl.course_code, ci.instance_id, cl.course_name,
		(2*cl.hp + 28 + 0.2*ci.num_students) AS admin_hours
		
FROM course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id = cl.id;