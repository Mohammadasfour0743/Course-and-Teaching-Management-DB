
-- 1) Teaching activities
INSERT INTO teaching_activity (activity_name, factor)
VALUES 
('Lecture', 3.6),
('Seminar', 1.8),
('Lab', 2.4),
('Tutorial', 2.4),
('Overhead', 1.2),
('Examination',1),
('Administration', 1);


-- 2) Course layouts
INSERT INTO course_layout (course_code, course_name, min_students, max_students, hp, is_active, study_period)
VALUES
('DH2642', 'Mobile Development', 10, 60, 7.5, TRUE, '1'),
('DH2401', 'Algorithms and Data Structures', 20, 120, 7.5, TRUE, '2'),
('DH2620', 'Operating Systems', 15, 80, 7.5, TRUE, '1'),
('DH2005', 'Computer Networks', 15, 80, 7.5, TRUE, '2'),
('DH2010', 'Distributed Systems', 20, 100, 7.5, TRUE, '1'),
('DH2100', 'Human–Computer Interaction', 10, 70, 6.0, TRUE, '1'),
('DH2500', 'Machine Learning Fundamentals', 20, 120, 7.5, TRUE, '2'),
('DH2600', 'Databases', 15, 100, 7.5, TRUE, '2');


-- 3) Course instances
INSERT INTO course_instance ( num_students, study_year, course_layout_id)
VALUES
( 45, '2025', 1),
( 80, '2025', 3),
( 30, '2025', 4),
( 55, '2025', 5),
( 55, '2025', 6),
( 40, '2025', 7),
( 95, '2025', 8);


-- 4) Planned activities
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES
-- Mobile Development (course_instance_id = 1)
(1, 20, 1),  -- Lecture
(1, 10, 2),  -- Seminar
(1, 15, 3),  -- Lab

-- Algorithms and Data Structures (instance 2)
(2, 25, 1),
(2, 20, 2),

-- Operating Systems (instance 3)
(3, 18, 1),
(3, 12, 3),

-- Computer Networks (instance 4)
(4, 22, 1),
(4, 12, 3),

-- Distributed Systems (instance 5)
(5, 30, 1),
(5, 10, 2),
(5, 15, 3),

-- HCI (instance 6)
(6, 18, 1),
(6, 20, 2),

-- ML (instance 7)
(7, 25, 1),
(7, 20, 2),
(7, 18, 3);

-- Course 4, new Tutorial activity
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES (4, 12, (SELECT id FROM teaching_activity WHERE activity_name = 'Tutorial'));

-- Course 4, new Seminar activity
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES (4, 8, (SELECT id FROM teaching_activity WHERE activity_name = 'Seminar'));


-- Course 5, new Tutorial activity
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES (5, 10, (SELECT id FROM teaching_activity WHERE activity_name = 'Tutorial'));

-- Course 5, new Overhead activity
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES (5, 6, (SELECT id FROM teaching_activity WHERE activity_name = 'Overhead'));


-- 5) Job titles
INSERT INTO job_title (job_title)
VALUES
('Lecturer'),
('Professor'),
('Teaching Assistant'),
('Administrator');


-- 6) Persons
INSERT INTO person (personal_number, first_name, last_name, street, ZIP)
VALUES
('199001011234', 'Anna', 'Svensson', 'Sveavägen 12', '11122'),
('198506152233', 'Erik', 'Johansson', 'Lindhagensgatan 45', '11280'),
('199811052178', 'Maria', 'Lindgren', 'Valhallavägen 99', '11428'),
('197512302145', 'Karl', 'Andersson', 'Kungsgatan 3', '11143'),
('199203142233', 'Sofia', 'Bergström', 'Birger Jarlsgatan 55', '11356'),
('198912012245', 'Jonas', 'Ekström', 'Hagagatan 12', '11347'),
('199707052122', 'Emma', 'Nordin', 'Odengatan 88', '11322'),
('198403182199', 'Daniel', 'Holm', 'Sankt Eriksgatan 77', '11234'),
('199601302178', 'Johanna', 'Persson', 'Fleminggatan 22', '11226'),
('197911112311', 'Lars', 'Dahl', 'Sturegatan 14', '11436'),
('198705202188', 'Frida', 'Åkesson', 'Valhallavägen 12', '11427'),
('199104152211', 'Oscar', 'Wikström', 'Sveavägen 44', '11134'),
('198306302299', 'Helena', 'Ström', 'Narvavägen 77', '11522'),
('199811242277', 'Niklas', 'Borg', 'Torsgatan 52', '11337');


-- 7) Departments
INSERT INTO department (department_name, manager_id)
VALUES
('Computer Science', NULL),
('Engineering', NULL);


-- 8) Employees
INSERT INTO employee ( job_title_id, person_id, department_id, manager_id, is_active)
VALUES 
( 2, 1, 1, NULL, TRUE),
( 1, 2, 1, 1, TRUE),    
( 3, 3, 1, 1, TRUE),    
( 4, 4, 2, 1, TRUE),
( 1, 5, 1, 1, TRUE),
( 3, 6, 1, 1, TRUE),
( 2, 7, 1, 1, TRUE),
( 4, 8, 2, 4, TRUE),
( 1, 9, 2, 4, TRUE),
( 3, 10, 2, 4, TRUE),
( 1, 11, 1, 1, TRUE),
( 2, 12, 1, 1, TRUE),
( 3, 13, 1, 1, TRUE),
( 4, 14, 2, 4, TRUE);    -- Karl admin


UPDATE department SET manager_id = 1 WHERE id = 1;  -- CS manager = Anna
UPDATE department SET manager_id = 4 WHERE id = 2;  -- Eng manager = Karl


-- 9) Salary (simple VALUES insert - no ambiguity)
INSERT INTO salary (salary_amount, date_given, employee_id)
VALUES
(45000, CURRENT_DATE, 1),
(38000, CURRENT_DATE, 2),
(32000, CURRENT_DATE, 3),
(40000, CURRENT_DATE, 4),
(41000, CURRENT_DATE, 5),
(34000, CURRENT_DATE, 6),
(46000, CURRENT_DATE, 7),
(36000, CURRENT_DATE, 8),
(38000, CURRENT_DATE, 9),
(33000, CURRENT_DATE, 10),
(42000, CURRENT_DATE, 11),
(45000, CURRENT_DATE, 12),
(35000, CURRENT_DATE, 13),
(36500, CURRENT_DATE, 14);


-- 10) Phones
INSERT INTO phone (phone_number)
VALUES
('0701234567'),
('0709876543'),
('0721122334'),
('0735566778'),
('0701112233'),
('0702223344'),
('0733334455'),
('0734445566'),
('0725556677'),
('0726667788'),
('0707778899'),
('0708889900'),
('0739990011'),
('0720001122');


-- 11) person_phone
INSERT INTO person_phone (person_id, phone_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14);


-- 12) Skill set
INSERT INTO skill_set (skill)
VALUES
('Java'),
('C++'),
('Python'),
('Database Design'),
('Unity'),
('Cybersecurity'),
('Web Development'),
('Cloud Computing'),
('AI/ML'),
('Network Design');


-- 13) employee_skill_set
INSERT INTO employee_skill_set (skill_set_id, employee_id)
VALUES
(1, 1),
(4, 1),
(2, 2),
(5, 3),
(3, 4),
(6, 5),
(7, 5),
(8, 6),
(9, 7),
(10, 8),
(6, 9),
(7, 10),
(8, 11),
(9, 12),
(10, 13);


-- 14) employee_planned_activity
-- FIXED: assign only the correct planned_activity IDs for DH2642
-- (assuming the planned_activity rows inserted earlier produced ids 1,2,3 for DH2642)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
VALUES
-- Anna teaches Lecture (pa.id = 1)
(1, 1),

-- Erik teaches Seminar (pa.id = 2)
(2, 2),

-- Maria handles Lab (pa.id = 3)
(3, 3),

-- Keep other mappings from your original script (these are example rows,
-- adjust or remove according to what planned_activity rows exist in your DB)
(5, 4),
(5, 5),
(6, 6),
(7, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 11),
(11, 12);


-- DH2642 – Mobile Development (instance_id = the one linked to course_layout 1)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 1, pa.id  -- Anna → Lecture
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 2, pa.id  -- Erik → Seminar
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Seminar';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 3, pa.id  -- Maria → Lab
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Lab';


-- DH2401 – Algorithms (instance 2)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 5, pa.id  -- Sofia → Lecture
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 2 AND ta.activity_name='Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 6, pa.id  -- Jonas → Seminar
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 2 AND ta.activity_name='Seminar';


-- DH2620 – Operating Systems (instance 3)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 7, pa.id  -- Emma → Lecture
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name='Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 8, pa.id  -- Daniel → Lab
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name='Lab';


INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 3, pa.id  -- Maria
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name='Overhead';

-- DH2005 – Networks (instance 4)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 9, pa.id  -- Johanna → Lecture
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name='Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 10, pa.id  -- Lars → Lab
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name='Lab';


-- DH2010 – Distributed Systems (instance 5)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 11, pa.id  -- Frida → Lecture
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name='Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 12, pa.id  -- Oscar → Seminar
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name='Seminar';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 13, pa.id  -- Helena → Lab
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name='Lab';


-- DH2100 – HCI (instance 6)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 1, pa.id  -- Anna → Lecture
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name='Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 5, pa.id  -- Sofia → Seminar
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name='Seminar';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 3, pa.id  -- Maria
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name='Lab';


-- DH2500 – ML (instance 7)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 14, pa.id  -- Niklas → Lecture
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 7 AND ta.activity_name='Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 6, pa.id  -- Jonas → Seminar
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 7 AND ta.activity_name='Seminar';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 7, pa.id  -- Emma → Lab
FROM planned_activity pa JOIN teaching_activity ta ON ta.id=pa.teaching_activity_id
WHERE pa.course_instance_id = 7 AND ta.activity_name='Lab';

-- DH2600 – ML (instance 7) Administration
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 14, pa.id  -- Example: Anna
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 7 AND ta.activity_name = 'Administration';

-- DH2600 – ML (instance 7) Exam
INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 7, pa.id  -- Example: Erik
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 7 AND ta.activity_name = 'Examination';


INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 3, pa.id
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Tutorial';


INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 3, pa.id
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Seminar';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 3, pa.id --6
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name = 'Tutorial';


INSERT INTO employee_planned_activity (employee_id, planned_activity_id)
SELECT 13, pa.id --13
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name = 'Overhead';


