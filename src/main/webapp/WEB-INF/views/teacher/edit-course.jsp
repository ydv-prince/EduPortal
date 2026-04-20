<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Course | Instructor Hub</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #090e1a;
            --surface: #111827;
            --primary: #4e73df;
            --emerald: #10b981;
            --border: rgba(255, 255, 255, 0.08);
            --text-dim: #94a3b8;
        }

        body { background-color: var(--bg-dark); color: white; font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        
        .portal-nav { background: rgba(9, 14, 26, 0.8); backdrop-filter: blur(10px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        .builder-header { background: var(--surface); padding: 25px 40px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
        
        .edit-card { background: var(--surface); border: 1px solid var(--border); border-radius: 24px; padding: 40px; box-shadow: 0 20px 50px rgba(0,0,0,0.3); }

        .f-label { font-size: 0.75rem; font-weight: 700; color: var(--text-dim); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; display: block; }
        .f-input, .f-select { width: 100%; background: rgba(255, 255, 255, 0.03); border: 1px solid var(--border); border-radius: 12px; padding: 14px 15px; color: white; outline: none; margin-bottom: 25px; transition: 0.3s; }
        .f-input:focus, .f-select:focus { border-color: var(--primary); background: rgba(78, 115, 223, 0.05); }
        .f-select option { background-color: var(--surface); color: white; }

        .thumb-wrapper { position: relative; width: 100%; height: 250px; border-radius: 16px; overflow: hidden; border: 2px dashed var(--border); margin-bottom: 25px; background: rgba(255,255,255,0.02); display: flex; align-items: center; justify-content: center; }
        .course-img { width: 100%; height: 100%; object-fit: cover; position: absolute; top: 0; left: 0; z-index: 1; }
        .upload-overlay { position: relative; z-index: 2; background: rgba(9, 14, 26, 0.6); padding: 10px 20px; border-radius: 50px; cursor: pointer; backdrop-filter: blur(5px); border: 1px solid rgba(255,255,255,0.1); transition: 0.3s; }
        .upload-overlay:hover { background: var(--primary); }

        .btn-update { background: linear-gradient(135deg, var(--primary), #3b82f6); color: white; border: none; padding: 15px; border-radius: 15px; width: 100%; font-weight: 700; transition: 0.3s; font-size: 1.05rem; }
        .btn-update:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(78, 115, 223, 0.3); }

        .form-switch .form-check-input { width: 3em; height: 1.5em; background-color: rgba(255,255,255,0.1); border-color: var(--border); }
        .form-switch .form-check-input:checked { background-color: var(--emerald); border-color: var(--emerald); }
    </style>
</head>
<body>

<nav class="portal-nav d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center gap-2" onclick="location.href='${pageContext.request.contextPath}/teacher/dashboard'" style="cursor: pointer;">
        <div class="bg-primary p-2 rounded-3 text-white"><i class="fa-solid fa-graduation-cap"></i></div>
        <h4 class="m-0 fw-bold">E-Learn</h4>
    </div>
    <div class="bg-warning rounded-circle text-dark fw-bold d-flex align-items-center justify-content-center" style="width:35px; height:35px;">
        <c:out value="${teacher.fullName.substring(0,1).toUpperCase()}" default="T" />
    </div>
</nav>

<div class="builder-header">
    <div>
        <h4 class="fw-bold m-0"><i class="fa-solid fa-pen-to-square text-primary me-2"></i>Edit Course Basics</h4>
        <p class="small text-dim m-0">Modify details for: <span class="text-white fw-bold"><c:out value="${course.title}"/></span></p>
    </div>
    <a href="${pageContext.request.contextPath}/teacher/courses" class="btn btn-outline-secondary btn-sm rounded-pill px-4 pt-2">
        <i class="fa-solid fa-arrow-left me-1"></i> Cancel
    </a>
</div>

<div class="container py-5" style="max-width: 900px;">
    
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger border-0 rounded-4 mb-4 shadow-sm"><i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMsg}</div>
    </c:if>

    <div class="edit-card">
        <form action="${pageContext.request.contextPath}/teacher/courses/update/${course.id}" method="post" enctype="multipart/form-data">
            
            <div class="row">
                <div class="col-lg-5">
                    <label class="f-label">Course Thumbnail</label>
                    <div class="thumb-wrapper">
                        <img src="${not empty course.thumbnailUrl ? course.thumbnailUrl : ''}" 
                             id="previewImg" class="course-img" 
                             style="${empty course.thumbnailUrl ? 'display:none;' : ''}">
                        
                        <label for="thumbnailInput" class="upload-overlay">
                            <i class="fa-solid fa-camera me-2"></i> Change Image
                        </label>
                        <input type="file" id="thumbnailInput" name="thumbnailFile" class="d-none" accept="image/*" onchange="previewThumbnail(this)">
                    </div>

                    <div class="form-check form-switch mt-4 p-4 rounded-4" style="background: rgba(255,255,255,0.02); border: 1px solid var(--border);">
                        <input class="form-check-input ms-0 me-3" type="checkbox" role="switch" id="publishSwitch" name="published" value="true" ${course.published ? 'checked' : ''}>
                        <label class="form-check-label text-white fw-bold" style="cursor: pointer;" for="publishSwitch">
                            Publish Course <br>
                            <span class="small text-dim fw-normal">Visible to students</span>
                        </label>
                    </div>
                </div>

                <div class="col-lg-7">
                    <label class="f-label">Course Title</label>
                    <input type="text" name="title" class="f-input" value="${course.title}" required>

                    <div class="row">
                        <div class="col-md-7">
                            <label class="f-label">Category</label>
                            <select name="categoryId" class="f-select" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${cat.id == course.category.id ? 'selected' : ''}>${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label class="f-label">Price (₹)</label>
                            <input type="number" name="price" class="f-input" value="${course.price}" min="0" required>
                        </div>
                    </div>

                    <label class="f-label">Short Description</label>
                    <textarea name="description" class="f-input" rows="3" required>${course.description}</textarea>
                    
                    <label class="f-label">What You'll Learn (Comma separated)</label>
                    <textarea name="whatYoullLearn" class="f-input" rows="3">${course.whatYoullLearn}</textarea>
                </div>
            </div>

            <button type="submit" class="btn-update mt-4">
                <i class="fa-solid fa-floppy-disk me-2"></i> Update Course Details
            </button>
        </form>
    </div>
</div>

<script>
    function previewThumbnail(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var img = document.getElementById('previewImg');
                img.src = e.target.result;
                img.style.display = 'block';
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>