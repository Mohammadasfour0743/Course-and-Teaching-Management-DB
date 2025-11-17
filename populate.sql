INSERT INTO teaching_activity (activity_name, factor)
VALUES 
('Lecture', 3.75),
('Seminar', 1.75),
('Lab', 1.25),
('Exam Supervision', 1.50);


INSERT INTO course_layout (course_code, course_name, min_students, max_students, hp, is_active, study_period)
VALUES
('DH2642', 'Mobile Development', 10, 60, 7.5, TRUE, '1'),
('DH2642', 'Mobile Development', 10, 60, 3.0, FALSE, '1'),
('DH2401', 'Algorithms and Data Structures', 20, 120, 7.5, TRUE, '2'),
('DH2620', 'Operating Systems', 15, 80, 7.5, TRUE, '1');


INSERT INTO course_instance (instance_id, num_students, study_year, course_layout_id, exam_hours_d, admin_hours_d)
VALUES
('MD2025-1', 45, '2025', 1, 10, 5),
('ALGO2025-1', 80, '2025', 3, 15, 8),
('OS2025-1', 30, '2025', 4, 12, 6);




INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES
-- Mobile Development
(1, 20, 1),  -- Lecture
(1, 10, 2),  -- Seminar
(1, 15, 3),  -- Lab

-- Algorithms and Data Structures
(2, 25, 1),
(2, 20, 2),

-- Operating Systems
(3, 18, 1),
(3, 12, 3);




INSERT INTO job_title (job_title)
VALUES
('Lecturer'),
('Professor'),
('Teaching Assistant'),
('Administrator');



INSERT INTO person (personal_number, first_name, last_name, street, ZIP)
VALUES
('199001011234', 'Anna', 'Svensson', 'Sveavägen 12', '11122'),
('198506152233', 'Erik', 'Johansson', 'Lindhagensgatan 45', '11280'),
('199811052178', 'Maria', 'Lindgren', 'Valhallavägen 99', '11428'),
('197512302145', 'Karl', 'Andersson', 'Kungsgatan 3', '11143');


INSERT INTO department (department_name, manager_id)
VALUES
('Computer Science', NULL),
('Engineering', NULL);




INSERT INTO employee (employment_id, job_title_id, person_id, department_id, manager_id, is_active)
VALUES
('EMP001', 2, 1, 1, NULL, TRUE),  -- Anna Svensson (Professor) first employee, no manager
('EMP002', 1, 2, 1, 1, TRUE),    -- Erik reports to Anna
('EMP003', 3, 3, 1, 1, TRUE),    -- Maria reports to Anna
('EMP004', 4, 4, 2, 1, TRUE);    -- Karl admin


UPDATE department SET manager_id = 1 WHERE id = 1;  -- CS manager = Anna
UPDATE department SET manager_id = 4 WHERE id = 2;  -- Eng manager = Karl


INSERT INTO salary (salary_amount, date_given, employee_id, is_current)
VALUES
(45000, '2025-01-01', 1, TRUE),
(38000, '2025-01-01', 2, TRUE),
(32000, '2025-01-01', 3, TRUE),
(40000, '2025-01-01', 4, TRUE);


INSERT INTO phone (phone_number)
VALUES
('0701234567'),
('0709876543'),
('0721122334'),
('0735566778');


INSERT INTO person_phone (person_id, phone_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);


INSERT INTO skill_set (skill)
VALUES
('Java'),
('C++'),
('Python'),
('Database Design'),
('Unity');


INSERT INTO employee_skill_set (skill_set_id, employee_id)
VALUES
(1, 1),
(4, 1),
(2, 2),
(5, 3),
(3, 4);



INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
VALUES
-- Anna teaches lectures
(1, 1),
(1, 2),
(1, 3),

-- Erik teaches seminars
(2, 2),
(2, 3),

-- Maria handles labs
(3, 3),
(3, 1);


INSERT INTO course_instance (instance_id, num_students, study_year, course_layout_id)
SELECT 'MD2025-2', 55, 2025, id
FROM course_layout
WHERE course_code='DH2642' AND study_period = '1' AND is_active = TRUE
ORDER BY course_layout.id DESC 
LIMIT 1;




