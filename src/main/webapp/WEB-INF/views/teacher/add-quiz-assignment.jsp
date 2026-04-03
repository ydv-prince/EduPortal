<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage My Courses | Instructor Hub</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --bg-dark: #090e1a; --surface: #111827; --primary: #4e73df; --border: rgba(255,255,255,0.08); }
        body { background: var(--bg-dark); color: white; font-family: 'Plus Jakarta Sans', sans-serif; }
        .course-row { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; margin-bottom: 15px; transition: 0.3s; padding: 15px; }
        .course-row:hover { border-color: var(--primary); transform: translateX(5px); }
        .course-img { width: 100px; height: 60px; border-radius: 8px; object-fit: cover; }
        .btn-action { width: 35px; height: 35px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; transition: 0.3s; }
        .btn-edit { background: rgba(78, 115, 223, 0.1); color: var(--primary); }
        .btn-delete { background: rgba(239, 68, 68, 0.1); color: #ef4444; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h2 class="fw-bold m-0">My Library</h2>
        <a href="/teacher/add-course" class="btn btn-primary rounded-pill px-4">+ Create New</a>
    </div>

    <c:forEach var="course" items="${courses}">
        <div class="course-row d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-3">
                <img src="${course.thumbnailUrl}" class="course-img" alt="thumb">
                <div>
                    <h6 class="fw-bold m-0">${course.title}</h6>
                    <small class="text-secondary">${course.category.name} • ${course.level}</small>
                </div>
            </div>
            <div class="text-center">
                <div class="fw-bold">₹${course.price}</div>
                <span class="badge ${course.published ? 'bg-success' : 'bg-warning'} bg-opacity-10 text-success">
                    ${course.published ? 'Live' : 'Draft'}
                </span>
            </div>
            <div class="d-flex gap-2">
                <a href="/teacher/courses/edit/${course.id}" class="btn-action btn-edit"><i class="fa-solid fa-pen"></i></a>
                <a href="/teacher/modules/builder/${course.id}" class="btn-action btn-edit" title="Build Content"><i class="fa-solid fa-layer-group"></i></a>
                <a href="#" class="btn-action btn-delete" onclick="return confirm('Pakka delete karna hai?')"><i class="fa-solid fa-trash"></i></a>
            </div>
        </div>
    </c:forEach>
</div>

</body>
</html>