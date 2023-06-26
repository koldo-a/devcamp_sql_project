USE devcamp_sql_course_project;



			/* ÍNDICE:
			1- Creación de tablas.
			2- Consultas de selección */



	# 1- CREACIÓN DE TABLAS.

/* Crear tabla 'students'. He generado un sistema para crear estudiantes ficticios aleatorios. Sé que no se pedía pero me vino bien para completar la tabla. */
INSERT INTO students (student_name, student_email, stu_course_id, stu_grade_id) 
VALUES (
	(SELECT CONCAT(
  UPPER(SUBSTRING(
	'bcdfghjklmnpqrstvwxyz',
	FLOOR(RAND() * 20) + 1,
	1
  )),
  SUBSTRING(
	'aeiou',
	FLOOR(RAND() * 5) + 1,
	1
  ),
  SUBSTRING(
	'bcdfghjklmnpqrstvwxyz',
	FLOOR(RAND() * 20) + 1,
	1
  ),
  SUBSTRING(
	'aeiou',
	FLOOR(RAND() * 5) + 1,
	1
  ),
  SUBSTRING(
	'bcdfghjklmnpqrstvwxyz',
	FLOOR(RAND() * 20) + 1,
	1
  )
)
), CONCAT (
  FLOOR(RAND() * 100000), '@', FLOOR(RAND() * 100), 'mail', '.com'
), FLOOR(RAND() * 18), FLOOR(RAND() * 4) + 1);
SELECT * FROM students;

/* Posibilitar alumnos con varias materias. Porque aleatoriamente es imposible.*/
INSERT INTO students (student_name, student_email, stu_course_id, stu_grade_id) 
VALUES
  ('Runom', '89772@11mail.com', 8, 1),
  ('Runom', '89772@11mail.com', 6, 2),
  ('Todin', '83674@63mail.com', 7, 4),
  ('Divup', '37240@17mail.com', 10, 3),
  ('Divup', '37240@17mail.com', 5, 3),
  ('Todin', '83674@63mail.com', 9, 3),
  ('Bukas', '4308@10mail.com', 2, 4),
  ('Bukas', '4308@10mail.com', 13, 2),
  ('pEPE', 'PEPE@11mail.com', 2, 4),
  ('Todin', '83674@63mail.com', 3, 1),
  ('Divup', '37240@17mail.com', 18, 1),
  ('Divup', '37240@17mail.com', 6, 2),
  ('Todin', '83674@63mail.com', 4, 2),
  ('Bukas', '4308@10mail.com', 4, 3),
  ('Bukas', '4308@10mail.com', 14, 1);
SELECT * FROM students;


/* Crear tabla courses */
INSERT INTO courses (course_title, course_professor_id)
VALUES
  ('Anatomy', 4),
  ('Physiology', 9),
  ('Pathology', 2),
  ('Pharmacology', 7),
  ('Microbiology', 5),
  ('Biochemistry', 1),
  ('Immunology', 8),
  ('Neuroscience', 3),
  ('Medical Ethics', 10),
  ('Clinical Skills', 6),
  ('Pathophysiology', 5),
  ('Pharmacotherapy', 1),
  ('Medical Genetics', 9),
  ('Epidemiology', 2),
  ('Histology', 7),
  ('Public Health', 3),
  ('Medical Imaging', 10),
  ('Surgical Techniques', 4);
SELECT * FROM courses ORDER BY course_id ASC;

/* Crear tabla professors */
INSERT INTO professors (professors_name, professors_email)
VALUES
  ('John Smith', 'john.smith@example.com'),
  ('Emily Johnson', 'emily.johnson@example.com'),
  ('Daniel Brown', 'daniel.brown@example.com'),
  ('Olivia Davis', 'olivia.davis@example.com'),
  ('Michael Miller', 'michael.miller@example.com'),
  ('Sophia Wilson', 'sophia.wilson@example.com'),
  ('David Taylor', 'david.taylor@example.com'),
  ('Ava Anderson', 'ava.anderson@example.com'),
  ('Matthew Martinez', 'matthew.martinez@example.com'),
  ('Emma Thompson', 'emma.thompson@example.com');
SELECT * FROM professors ORDER BY professors_id ASC;

/* Crear tabla grades */
INSERT INTO grades (grades_name)
VALUES
	('Distinction'),
	('Merit'),
	('Pass'),
	('Not pass');
SELECT * FROM grades;


	# 2- CONSULTAS DE SELECCIÓN:

/*  1- The average grade that is given by each professor */ 
SELECT AVG(g.grades_id) AS media_de_notas, p.professors_name
FROM students s
JOIN grades g ON s.stu_grade_id = g.grades_id
JOIN courses c ON c.course_id = s.stu_course_id
JOIN professors p ON p.professors_id = c.course_professor_id
GROUP BY p.professors_name
ORDER BY media_de_notas DESC, p.professors_name ASC; 

/* 2- The top grades for each student */
SELECT student_name, course_title, grades_name, professors_name
FROM students s
JOIN grades g ON s.stu_grade_id = g.grades_id
JOIN courses c ON s.stu_course_id = c.course_id
JOIN professors p ON c.course_professor_id = p.professors_id
WHERE g.grades_id = (SELECT MIN(grades_id) FROM grades)
ORDER BY student_name ASC, g.grades_id ASC;

/* 3- Sort students by the courses that they are enrolled in*/
SELECT course_title, student_name
FROM courses
JOIN students ON courses.course_id = students.stu_course_id
ORDER BY course_title ASC, student_name ASC;

/* 4- Create a summary report of courses and their average grades, sorted by the most challenging course (course with the lowest average grade) to the easiest course */
SELECT c.course_title, AVG(g.grades_id) AS average_grade
FROM courses c
JOIN students s ON s.stu_course_id = c.course_id
JOIN grades g ON s.stu_grade_id = g.grades_id
GROUP BY c.course_title
ORDER BY average_grade ASC;

/* 5- Finding which student and professor have the most courses in common */
SELECT s.student_name, p.professors_name, COUNT(*) AS common_courses
FROM students s
JOIN grades g ON s.stu_grade_id = g.grades_id
JOIN courses c ON c.course_id = s.stu_course_id
JOIN professors p ON c.course_professor_id = p.professors_id
GROUP BY s.student_name, p.professors_name
ORDER BY common_courses DESC
LIMIT 1;