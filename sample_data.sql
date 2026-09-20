USE job_tracker;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM activity_logs;
DELETE FROM reminders;
DELETE FROM applications;
DELETE FROM opportunities;

/* ---------------------------------------------------
   USERS
   Existing users are kept:
   ID 1 -> Test User
   ID 2 -> Administrator
---------------------------------------------------- */

INSERT INTO users
(id,
name,
email,
password_hash,
role,
cgpa,
branch,
skills,
experience,
projects,
github_url,
linkedin_url,
profile_picture,
created_at,
resume_filename)
VALUES

(3,
'Zoro',
'zoro@example.com',
SHA2('Password@123',256),
'student',
9.12,
'Computer Applications',
'Java, JDBC, Servlets, MySQL, DSA',
'Backend Intern',
'Campus ERP, Expense Tracker',
'https://github.com/zoro',
'https://linkedin.com/in/zoro',
'zoro.png',
CURRENT_TIMESTAMP,
'zoro_resume.pdf'),

(4,
'Ichigo',
'ichigo@example.com',
SHA2('Password@123',256),
'student',
8.84,
'Computer Applications',
'Java, Python, Machine Learning, SQL',
'AI Research Intern',
'Resume Analyzer, AI Chatbot',
'https://github.com/ichigo',
'https://linkedin.com/in/ichigo',
'ichigo.png',
CURRENT_TIMESTAMP,
'ichigo_resume.pdf'),

(5,
'Guts',
'guts@example.com',
SHA2('Password@123',256),
'student',
8.56,
'Computer Applications',
'Java, Spring Boot, SQL',
'Web Developer',
'Inventory System, Billing System',
'https://github.com/guts',
'https://linkedin.com/in/guts',
'guts.png',
CURRENT_TIMESTAMP,
'guts_resume.pdf'),

(6,
'Johan',
'johan@example.com',
SHA2('Password@123',256),
'student',
9.42,
'Computer Applications',
'Java, Python, Data Analytics',
'ML Intern',
'Placement Predictor, Student Portal',
'https://github.com/johan',
'https://linkedin.com/in/johan',
'johan.png',
CURRENT_TIMESTAMP,
'johan_resume.pdf');

/* ---------------------------------------------------
   OPPORTUNITIES
   posted_by = 2 (Administrator)
---------------------------------------------------- */

INSERT INTO opportunities
(company,
role,
location,
description,
skills_required,
deadline,
eligibility,
salary,
posted_by)
VALUES

('Google',
'Software Engineer',
'Bangalore',
'Full Time Software Engineer',
'Java, DSA, SQL',
'2026-08-10',
'CGPA >= 8.0',
'24 LPA',
2),

('Microsoft',
'Backend Developer',
'Hyderabad',
'Backend Engineering Role',
'Java, Spring, SQL',
'2026-08-12',
'CGPA >= 7.5',
'22 LPA',
2),

('Amazon',
'SDE Intern',
'Bangalore',
'Software Development Internship',
'Java, OOP, DSA',
'2026-08-14',
'CGPA >= 7.0',
'12 LPA Stipend',
2),

('Oracle',
'Java Developer',
'Bangalore',
'Enterprise Java Development',
'Java, JDBC, Servlets',
'2026-08-15',
'CGPA >= 7.5',
'15 LPA',
2),

('Adobe',
'Software Engineer',
'Noida',
'Creative Cloud Development',
'Java, SQL, REST',
'2026-08-18',
'CGPA >= 8.0',
'20 LPA',
2),

('IBM',
'Application Developer',
'Pune',
'Enterprise Application Development',
'Java, SQL',
'2026-08-20',
'CGPA >= 7.0',
'10 LPA',
2),

('Infosys',
'Systems Engineer',
'Mysore',
'Campus Recruitment',
'Java, SQL, Aptitude',
'2026-08-22',
'CGPA >= 6.5',
'6.5 LPA',
2),

('Zoho',
'Software Developer',
'Chennai',
'Product Development',
'Java, SQL, HTML, CSS',
'2026-08-24',
'CGPA >= 7.0',
'9 LPA',
2),

('Atlassian',
'Backend Engineer',
'Bangalore',
'Cloud Platform Development',
'Java, Spring Boot',
'2026-08-26',
'CGPA >= 8.0',
'26 LPA',
2),

('Cisco',
'Software Engineer',
'Bangalore',
'Networking Software',
'Java, SQL',
'2026-08-28',
'CGPA >= 7.5',
'17 LPA',
2),

('Tata Elxsi',
'Graduate Engineer',
'Bangalore',
'Embedded & Software',
'Java, OOP',
'2026-08-30',
'CGPA >= 7.0',
'8 LPA',
2),

('Accenture',
'Associate Software Engineer',
'Bangalore',
'Campus Hiring',
'Java, SQL, Aptitude',
'2026-09-02',
'CGPA >= 6.5',
'6 LPA',
2);
/* ---------------------------------------------------
   APPLICATIONS
---------------------------------------------------- */

INSERT INTO applications
(user_id,
company_name,
job_role,
location,
application_date,
deadline,
status,
notes,
resume_filename,
job_skills,
skill_match_percent)
VALUES

-- Zoro

(3,'Google','Software Engineer','Bangalore',
'2026-07-01','2026-08-10',
'Interview',
'Excellent coding round.',
'zoro_resume.pdf',
'Java, DSA, SQL',
92),

(3,'Microsoft','Backend Developer','Hyderabad',
'2026-07-03','2026-08-12',
'Shortlisted',
'Waiting for technical interview.',
'zoro_resume.pdf',
'Java, Spring, SQL',
88),

(3,'Oracle','Java Developer','Bangalore',
'2026-07-05','2026-08-15',
'Pending',
'Application submitted.',
'zoro_resume.pdf',
'Java, JDBC, Servlets',
83),

(3,'Cisco','Software Engineer','Bangalore',
'2026-07-06','2026-08-28',
'Rejected',
'Did not clear aptitude.',
'zoro_resume.pdf',
'Java, SQL',
74),


-- Ichigo

(4,'Amazon','SDE Intern','Bangalore',
'2026-07-02','2026-08-14',
'Selected',
'Offer received.',
'ichigo_resume.pdf',
'Java, OOP, DSA',
96),

(4,'Adobe','Software Engineer','Noida',
'2026-07-04','2026-08-18',
'Interview',
'HR round pending.',
'ichigo_resume.pdf',
'Java, SQL, REST',
91),

(4,'IBM','Application Developer','Pune',
'2026-07-06','2026-08-20',
'Pending',
'Application submitted.',
'ichigo_resume.pdf',
'Java, SQL',
79),

(4,'Infosys','Systems Engineer','Mysore',
'2026-07-08','2026-08-22',
'Shortlisted',
'Cleared online assessment.',
'ichigo_resume.pdf',
'Java, SQL, Aptitude',
81),


-- Guts

(5,'Zoho','Software Developer','Chennai',
'2026-07-01','2026-08-24',
'Interview',
'Technical interview scheduled.',
'guts_resume.pdf',
'Java, SQL, HTML, CSS',
85),

(5,'Google','Software Engineer','Bangalore',
'2026-07-03','2026-08-10',
'Rejected',
'Coding round not cleared.',
'guts_resume.pdf',
'Java, DSA',
71),

(5,'Accenture','Associate Software Engineer','Bangalore',
'2026-07-05','2026-09-02',
'Pending',
'Awaiting response.',
'guts_resume.pdf',
'Java, SQL',
76),

(5,'Oracle','Java Developer','Bangalore',
'2026-07-07','2026-08-15',
'Shortlisted',
'Waiting for interview.',
'guts_resume.pdf',
'Java, JDBC',
82),


-- Johan

(6,'Atlassian','Backend Engineer','Bangalore',
'2026-07-02','2026-08-26',
'Selected',
'Offer accepted.',
'johan_resume.pdf',
'Java, Spring Boot',
98),

(6,'Microsoft','Backend Developer','Hyderabad',
'2026-07-04','2026-08-12',
'Interview',
'Managerial round pending.',
'johan_resume.pdf',
'Java, Spring',
94),

(6,'Adobe','Software Engineer','Noida',
'2026-07-06','2026-08-18',
'Shortlisted',
'Shortlisted after OA.',
'johan_resume.pdf',
'Java, REST',
90),

(6,'IBM','Application Developer','Pune',
'2026-07-09','2026-08-20',
'Pending',
'Recently applied.',
'johan_resume.pdf',
'Java, SQL',
84);

/* ---------------------------------------------------
   REMINDERS
---------------------------------------------------- */

INSERT INTO reminders
(user_id,
title,
message,
remind_at,
urgency,
is_read)
VALUES

(3,
'Google Interview',
'Prepare DSA and Java interview questions.',
'2026-07-20 10:00:00',
'high',
0),

(3,
'Update Resume',
'Upload the latest version before Oracle deadline.',
'2026-07-18 18:00:00',
'medium',
0),

(4,
'Amazon Offer',
'Complete the offer acceptance process.',
'2026-07-16 09:30:00',
'high',
0),

(4,
'IBM Assessment',
'Finish the coding assessment.',
'2026-07-19 15:00:00',
'medium',
0),

(5,
'Zoho Interview',
'Revise JDBC and SQL concepts.',
'2026-07-21 11:00:00',
'high',
0),

(5,
'Accenture Registration',
'Complete profile verification.',
'2026-07-22 17:30:00',
'low',
0),

(6,
'Microsoft Interview',
'Practice Spring Boot and REST APIs.',
'2026-07-23 14:00:00',
'high',
0),

(6,
'Adobe HR Round',
'Prepare HR questions.',
'2026-07-24 16:00:00',
'medium',
0);


/* ---------------------------------------------------
   ACTIVITY LOGS
---------------------------------------------------- */

INSERT INTO activity_logs
(user_id,
action,
entity_type,
entity_id)
VALUES

(3,'Applied for Google - Software Engineer','application',1),
(3,'Applied for Microsoft - Backend Developer','application',2),
(3,'Applied for Oracle - Java Developer','application',3),
(3,'Rejected by Cisco','application',4),

(4,'Applied for Amazon - SDE Intern','application',5),
(4,'Selected by Amazon','application',5),
(4,'Applied for Adobe - Software Engineer','application',6),
(4,'Applied for IBM - Application Developer','application',7),

(5,'Applied for Zoho - Software Developer','application',9),
(5,'Applied for Google - Software Engineer','application',10),
(5,'Applied for Oracle - Java Developer','application',12),

(6,'Applied for Atlassian - Backend Engineer','application',13),
(6,'Selected by Atlassian','application',13),
(6,'Applied for Microsoft - Backend Developer','application',14),
(6,'Applied for Adobe - Software Engineer','application',15),

(2,'Created Google Opportunity','opportunity',1),
(2,'Created Microsoft Opportunity','opportunity',2),
(2,'Created Amazon Opportunity','opportunity',3),
(2,'Created Oracle Opportunity','opportunity',4),
(2,'Created Adobe Opportunity','opportunity',5),
(2,'Created IBM Opportunity','opportunity',6),
(2,'Created Infosys Opportunity','opportunity',7),
(2,'Created Zoho Opportunity','opportunity',8),
(2,'Created Atlassian Opportunity','opportunity',9),
(2,'Created Cisco Opportunity','opportunity',10),
(2,'Created Tata Elxsi Opportunity','opportunity',11),
(2,'Created Accenture Opportunity','opportunity',12);


/* ---------------------------------------------------
   RESET AUTO_INCREMENT
---------------------------------------------------- */

ALTER TABLE users AUTO_INCREMENT = 7;
ALTER TABLE opportunities AUTO_INCREMENT = 13;
ALTER TABLE applications AUTO_INCREMENT = 17;
ALTER TABLE reminders AUTO_INCREMENT = 9;
ALTER TABLE activity_logs AUTO_INCREMENT = 25;

SET FOREIGN_KEY_CHECKS = 1;