INSERT INTO teaching_activity (activity_name, factor)
VALUES 
('Lecture', 3.75),
('Seminar', 1.75),
('Lab', 1.25),
('Tutorial', 1.50);


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


INSERT INTO course_instance ( num_students, study_year, course_layout_id)
VALUES
( 45, '2025', 1),
( 80, '2025', 3),
( 30, '2025', 4),
( 55, '2025', 5),
( 55, '2025', 6),
( 40, '2025', 7),
( 95, '2025', 8);




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
(3, 12, 3),

-- Computer Networks
(4, 22, 1),
(4, 12, 3),

-- Distributed Systems
(5, 30, 1),
(5, 10, 2),
(5, 15, 3),

-- HCI
(6, 18, 1),
(6, 20, 2),

-- ML
(7, 25, 1),
(7, 20, 2),
(7, 18, 3);






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


INSERT INTO department (department_name, manager_id)
VALUES
('Computer Science', NULL),
('Engineering', NULL);



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
(3, 13, 1, 1, TRUE),
( 4, 14, 2, 4, TRUE);    -- Karl admin


UPDATE department SET manager_id = 1 WHERE id = 1;  -- CS manager = Anna
UPDATE department SET manager_id = 4 WHERE id = 2;  -- Eng manager = Karl


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
(3, 1),
(5, 4),
(5, 5),
(6, 6),

(7, 7),
(7, 8),

(8, 9),
(9, 10),
(10, 11),

(11, 12);



INSERT INTO course_instance (num_students, study_year, course_layout_id)
SELECT  45, 2025, id
FROM course_layout
WHERE course_code='DH2620' AND study_period = '1' AND is_active = TRUE
ORDER BY course_layout.id DESC 
LIMIT 1;



INSERT INTO salary(salary_amount, date_given, employee_id)
SELECT 87000,CURRENT_DATE, id
FROM person AS p
WHERE first_name = 'Anna' AND last_name = 'Svensson';




