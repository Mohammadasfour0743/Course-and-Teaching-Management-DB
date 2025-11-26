/*
--examination hours
CREATE OR REPLACE VIEW examination_hours AS
SELECT ci.id, cl.course_code, ci.instance_id, cl.course_name,
		(exam_f1 + exam_f2*ci.num_students) AS exam_hours

FROM course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id = cl.id
JOIN exam_hours_factors AS ef ON ef.id = (SELECT MAX(id) FROM exam_hours_factors);



--administration hours
CREATE OR REPLACE VIEW administration_hours AS
SELECT ci.id, cl.course_code, ci.instance_id, cl.course_name,
		(admin_f1*cl.hp + admin_f2 + admin_f3*ci.num_students) AS admin_hours
		
FROM course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id = cl.id
JOIN admin_hours_factors AS af ON af.id = (SELECT MAX(id) FROM admin_hours_factors);

*/