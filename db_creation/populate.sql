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
-- These will be assigned instance IDs in order: 1, 2, 3, 4, 5, 6, 7
INSERT INTO course_instance ( num_students, study_year, course_layout_id)
VALUES
( 45, '2025', 1),  -- instance 1: DH2642 - Mobile Development
( 80, '2025', 3),  -- instance 2: DH2620 - Operating Systems  
( 30, '2025', 4),  -- instance 3: DH2005 - Computer Networks
( 55, '2025', 5),  -- instance 4: DH2010 - Distributed Systems
( 55, '2025', 6),  -- instance 5: DH2100 - HCI
( 40, '2025', 7),  -- instance 6: DH2500 - ML Fundamentals
( 95, '2025', 8);  -- instance 7: DH2600 - Databases


-- 4) Planned activities
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES
-- DH2642 - Mobile Development (course_instance_id = 1)
(1, 20, 1),  -- Lecture
(1, 10, 2),  -- Seminar
(1, 15, 3),  -- Lab

-- DH2620 - Operating Systems (instance 2)
(2, 18, 1),  -- Lecture
(2, 12, 3),  -- Lab

-- DH2005 - Computer Networks (instance 3)
(3, 22, 1),  -- Lecture
(3, 12, 3),  -- Lab

-- DH2010 - Distributed Systems (instance 4)
(4, 30, 1),  -- Lecture
(4, 10, 2),  -- Seminar
(4, 15, 3),  -- Lab

-- DH2100 - HCI (instance 5)
(5, 18, 1),  -- Lecture
(5, 20, 2),  -- Seminar

-- DH2500 - ML (instance 6)
(6, 25, 1),  -- Lecture
(6, 20, 2),  -- Seminar
(6, 18, 3);  -- Lab

-- DH2600 - Databases (instance 7) - No manual activities yet

-- Course 3 (DH2005), new Tutorial activity
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES (3, 12, (SELECT id FROM teaching_activity WHERE activity_name = 'Tutorial'));

-- Course 3 (DH2005), new Seminar activity
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES (3, 8, (SELECT id FROM teaching_activity WHERE activity_name = 'Seminar'));

-- Course 4 (DH2010), new Tutorial activity
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES (4, 10, (SELECT id FROM teaching_activity WHERE activity_name = 'Tutorial'));

-- Course 4 (DH2010), new Overhead activity
INSERT INTO planned_activity (course_instance_id, planned_hours, teaching_activity_id)
VALUES (4, 6, (SELECT id FROM teaching_activity WHERE activity_name = 'Overhead'));


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
( 4, 14, 2, 4, TRUE);

UPDATE department SET manager_id = 1 WHERE id = 1;  -- CS manager = Anna
UPDATE department SET manager_id = 4 WHERE id = 2;  -- Eng manager = Karl


-- 9) Salary
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
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7),
(8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14);


-- 12) Skill set
INSERT INTO skill_set (skill)
VALUES
('Java'), ('C++'), ('Python'), ('Database Design'), ('Unity'),
('Cybersecurity'), ('Web Development'), ('Cloud Computing'),
('AI/ML'), ('Network Design');


-- 13) employee_skill_set
INSERT INTO employee_skill_set (skill_set_id, employee_id)
VALUES
(1, 1), (4, 1), (2, 2), (5, 3), (3, 4), (6, 5), (7, 5),
(8, 6), (9, 7), (10, 8), (6, 9), (7, 10), (8, 11), (9, 12), (10, 13);


-- 14) employee_planned_activity with ALLOCATED HOURS
-- DH2642 – Mobile Development (instance 1)
-- Lecture: 20 hours total
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 1, pa.id, 15  -- Anna teaches 15 out of 20 lecture hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 5, pa.id, 5  -- Sofia teaches remaining 5 lecture hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Lecture';

-- Seminar: 10 hours total
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 2, pa.id, 10  -- Erik handles all seminar hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Seminar';

-- Lab: 15 hours total
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 3, pa.id, 10  -- Maria handles 10 lab hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Lab';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 6, pa.id, 5  -- Jonas handles remaining 5 lab hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Lab';


-- DH2620 – Operating Systems (instance 2)
-- Lecture: 18 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 7, pa.id, 18  -- Emma handles all lectures
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 2 AND ta.activity_name = 'Lecture';

-- Lab: 12 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 8, pa.id, 7  -- Daniel handles 7 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 2 AND ta.activity_name = 'Lab';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 3, pa.id, 5  -- Maria handles 5 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 2 AND ta.activity_name = 'Lab';


-- DH2005 – Networks (instance 3)
-- Lecture: 22 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 9, pa.id, 22  -- Johanna handles all lectures
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name = 'Lecture';

-- Lab: 12 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 10, pa.id, 12  -- Lars handles all lab hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name = 'Lab';

-- Tutorial: 12 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 3, pa.id, 7  -- Maria handles 7 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name = 'Tutorial';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 6, pa.id, 5  -- Jonas handles 5 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name = 'Tutorial';

-- Seminar: 8 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 3, pa.id, 8  -- Maria handles all seminar hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name = 'Seminar';


-- DH2010 – Distributed Systems (instance 4)
-- Lecture: 30 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 11, pa.id, 20  -- Frida handles 20 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Lecture';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 12, pa.id, 10  -- Oscar handles 10 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Lecture';

-- Seminar: 10 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 12, pa.id, 10  -- Oscar handles all seminars
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Seminar';

-- Lab: 15 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 13, pa.id, 15  -- Helena handles all lab hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Lab';

-- Tutorial: 10 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 3, pa.id, 6  -- Maria handles 6 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Tutorial';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 10, pa.id, 4  -- Lars handles 4 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Tutorial';

-- Overhead: 6 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 13, pa.id, 6  -- Helena handles all overhead
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Overhead';


-- DH2100 – HCI (instance 5)
-- Lecture: 18 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 1, pa.id, 18  -- Anna handles all lectures
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name = 'Lecture';

-- Seminar: 20 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 5, pa.id, 12  -- Sofia handles 12 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name = 'Seminar';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 2, pa.id, 8  -- Erik handles 8 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name = 'Seminar';


-- DH2500 – ML (instance 6)
-- Lecture: 25 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 14, pa.id, 25  -- Niklas handles all lectures
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name = 'Lecture';

-- Seminar: 20 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 6, pa.id, 15  -- Jonas handles 15 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name = 'Seminar';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 13, pa.id, 5  -- Helena handles 5 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name = 'Seminar';

-- Lab: 18 hours
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 7, pa.id, 10  -- Emma handles 10 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name = 'Lab';

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 10, pa.id, 8  -- Lars handles 8 hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name = 'Lab';


-- ========== ALLOCATE EXAMINATION AND ADMINISTRATION FOR ALL COURSES ==========
-- Note: These allocations are for auto-generated Admin and Exam activities created by triggers

-- DH2642 – Mobile Development (instance 1)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 1, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Administration'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 1
  );

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 2, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 1 AND ta.activity_name = 'Examination'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 2
  );


-- DH2620 – Operating Systems (instance 2)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 7, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 2 AND ta.activity_name = 'Administration'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 7
  );

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 8, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 2 AND ta.activity_name = 'Examination'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 8
  );


-- DH2005 – Networks (instance 3)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 9, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name = 'Administration'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 9
  );

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 10, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 3 AND ta.activity_name = 'Examination'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 10
  );


-- DH2010 – Distributed Systems (instance 4)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 11, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Administration'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 11
  );

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 12, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 4 AND ta.activity_name = 'Examination'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 12
  );


-- DH2100 – HCI (instance 5)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 1, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name = 'Administration'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 1
  );

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 5, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 5 AND ta.activity_name = 'Examination'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 5
  );


-- DH2500 – ML (instance 6)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 14, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name = 'Administration'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 14
  );

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 7, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 6 AND ta.activity_name = 'Examination'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 7
  );


-- DH2600 – Databases (instance 7)
INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 11, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 7 AND ta.activity_name = 'Administration'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 11
  );

INSERT INTO employee_planned_activity (employee_id, planned_activity_id, allocated_hours)
SELECT 12, pa.id, pa.planned_hours
FROM planned_activity pa
JOIN teaching_activity ta ON ta.id = pa.teaching_activity_id
WHERE pa.course_instance_id = 7 AND ta.activity_name = 'Examination'
  AND NOT EXISTS (
    SELECT 1 FROM employee_planned_activity epa2 
    WHERE epa2.planned_activity_id = pa.id AND epa2.employee_id = 12
  );