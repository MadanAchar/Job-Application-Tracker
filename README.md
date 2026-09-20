# Job Application Tracker & Placement Readiness System

A Java-based web application designed to help students manage job applications, track placement opportunities, maintain their profiles, and monitor their placement progress through a centralized system.

The system also provides an administration interface for placement personnel to manage opportunities and review student applications.

---

## 📌 Project Overview

The **Job Application Tracker & Placement Readiness System** is a web-based placement management application developed using Java technologies.

It provides two main user roles:

* **Student**
* **Administrator / Placement Head**

Students can maintain their profiles, upload resumes, browse job opportunities, apply for opportunities, track application statuses, and manage reminders.

Administrators can manage placement opportunities and review student applications.

---

## ✨ Features

### 👨‍🎓 Student Features

* Student registration and login
* Profile management
* CGPA, branch, skills, experience and project details
* Resume upload
* Profile picture upload
* Browse available job opportunities
* Apply for job opportunities
* Track application status
* View application details
* Skill matching information
* Placement readiness score
* Application analytics
* Reminders and notifications
* Activity history
* Dark mode support
* Resume download

### 👨‍💼 Administrator Features

* Administrator authentication
* Admin dashboard
* Create job opportunities
* Edit job opportunities
* Delete job opportunities
* View student applications
* Review applications
* Update application status
* Monitor placement activity
* View application analytics
* Track opportunity-related activities

### 📊 Application Status Tracking

Applications can move through different stages such as:

* Pending
* Shortlisted
* Interview
* Selected
* Rejected

---

## 🛠️ Technology Stack

| Technology         | Usage                           |
| ------------------ | ------------------------------- |
| Java               | Application development         |
| JSP                | Web interface                   |
| Jakarta Servlets   | Request processing              |
| JDBC               | Database connectivity           |
| MySQL 8            | Database                        |
| Apache Tomcat 10.1 | Application server              |
| Maven              | Build and dependency management |
| HTML               | Web structure                   |
| CSS                | User interface styling          |
| JavaScript         | Client-side functionality       |

---

## 🏗️ Project Architecture

The application follows a layered structure:

```text
Job Application Tracker
│
├── Model
│   └── Application data models
│
├── DAO
│   └── Database operations
│
├── Servlet
│   └── Request and application logic
│
├── Filter
│   └── Authentication and authorization
│
├── Util
│   └── Database, validation, file upload,
│       password and placement utilities
│
└── Web Layer
    ├── JSP
    ├── CSS
    └── JavaScript
```

---

## 📁 Project Structure

```text
job-application-tracker/
│
├── pom.xml
├── schema.sql
├── sample_data.sql
├── structure.txt
├── .gitignore
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/jobtracker/
│       │       ├── dao/
│       │       ├── filter/
│       │       ├── model/
│       │       ├── servlet/
│       │       └── util/
│       │
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── jsp/
│           │   └── web.xml
│           │
│           ├── css/
│           └── js/
│
└── uploads/
    └── .gitkeep
```

---

## ⚙️ Requirements

Before running the project, install:

* Java JDK 21 or compatible JDK
* Apache Maven
* MySQL Server 8
* Apache Tomcat 10.1.x
* Git
* VS Code or another Java-compatible IDE

---

## 🗄️ Database Setup

### 1. Start MySQL

Make sure MySQL Server is running.

### 2. Create the database

Open MySQL and execute:

```sql
CREATE DATABASE job_tracker;
```

### 3. Create the tables

Run the provided:

```text
schema.sql
```

against the `job_tracker` database.

### 4. Optional sample data

The repository also contains:

```text
sample_data.sql
```

This file contains sample students, opportunities, applications, reminders and activity records for testing the application.

---

## 🔐 Database Configuration

The application reads the MySQL username and password from environment variables.

The database connection uses:

```text
Database: job_tracker
Username: root
```

Set the password in PowerShell before running the application:

```powershell
$env:JOB_TRACKER_DB_PASSWORD="YOUR_MYSQL_PASSWORD"
```

If a different MySQL username is required:

```powershell
$env:JOB_TRACKER_DB_USER="YOUR_MYSQL_USERNAME"
```

Do not commit database passwords or other credentials to the repository.

---

## 🔨 Build the Project

Open a terminal in the project directory:

```powershell
cd E:\javaproject
```

Run:

```powershell
mvn clean package
```

A successful build generates the WAR file inside:

```text
target/
```

The generated WAR file is intentionally excluded from Git.

---

## 🚀 Run with Apache Tomcat

Set the Tomcat installation path:

```powershell
$env:CATALINA_HOME="C:\apache-tomcat-10.1.55"
```

Copy the generated WAR file to Tomcat:

```powershell
Copy-Item .\target\job-application-tracker.war C:\apache-tomcat-10.1.55\webapps\
```

Start Tomcat:

```powershell
C:\apache-tomcat-10.1.55\bin\catalina.bat run
```

Then open:

```text
http://localhost:8080/job-application-tracker/
```

---

## 🧪 Sample Data

The `sample_data.sql` file provides test data for multiple student profiles and an administrator account.

The sample dataset includes:

* Student profiles
* Job opportunities
* Applications
* Application statuses
* Reminders
* Activity logs

This can be used to demonstrate different application states and dashboard/analytics functionality.

---

## 🔒 Security Notes

The repository does not contain:

* MySQL passwords
* Uploaded resumes
* Uploaded profile pictures
* Maven build output
* Generated JAR files
* Local IDE configuration

User-uploaded files are stored locally during development and are excluded from version control.

---

## 📈 Future Enhancements

Possible future improvements include:

* Email notifications
* Advanced placement analytics
* Automated resume analysis
* Job recommendation system
* Integration with external job portals
* Cloud deployment
* Role-based administrative permissions
* Enhanced placement prediction
* Automated interview preparation

---

## 🎓 Academic Project

This project was developed as an academic MCA project to demonstrate the use of Java web technologies, database connectivity, authentication, CRUD operations, application tracking and placement management.

---

## 👨‍💻 Author

**Madan M**

MCA Student
SJCE, Mysuru

---

## 📄 License

This project is intended primarily for academic and educational purposes.
