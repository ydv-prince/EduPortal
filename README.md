# Edu-Portal (Online Course Management System)

A full-featured web-based e-learning platform developed using Java Spring Boot.  
The system supports **Students**, **Teachers**, and **Administrators** with dedicated dashboards, secure authentication, course management, enrollments, payments, quizzes, assignments, and analytics.

## Project Overview

The Online Course Management System provides a centralized platform where:

- Students can browse, enroll, learn, track progress, and earn certificates.
- Teachers can create and manage courses, lessons, assignments, quizzes, and revenue.
- Admins can manage users, courses, payments, reports, and platform analytics.

Built as a multi-role Learning Management System (LMS) with scalable architecture. :contentReference[oaicite:0]{index=0}

---

## Features

## Student Module

- Registration & Login
- Browse Courses
- Search & Filters
- Enroll in Paid / Free Courses
- Access Lessons & Learning Content
- Submit Assignments
- Attempt Quizzes
- Track Progress
- Certificates
- Profile Management

## Teacher Module

- Teacher Dashboard
- Create / Edit Courses
- Add Modules & Lessons
- Upload Content
- Create Quizzes & Assignments
- Review Student Submissions
- Revenue Tracking
- Manage Enrolled Students

## Admin Module

- Admin Dashboard
- User Management
- Course Moderation
- Category Management
- Payment Monitoring
- Reports & Analytics
- Support Tickets
- Platform Settings

## Security

- Spring Security Authentication
- Role-Based Access Control (RBAC)
- BCrypt Password Encryption
- Session Management
- CSRF Protection
- Secure Login Flow :contentReference[oaicite:1]{index=1}

---

## Tech Stack

### Backend
- Java
- Spring Boot
- Spring MVC
- Spring Security
- Spring Data JPA
- Hibernate

### Frontend
- JSP
- HTML5
- CSS3
- JavaScript

### Database
- MySQL

### Tools
- Maven
- Eclipse / IntelliJ IDEA
- Git / GitHub

---

## Project Structure

```bash
src/main/java/com/elearn/
 ├── controller
 ├── service
 ├── repository
 ├── model
 ├── dto
 └── config