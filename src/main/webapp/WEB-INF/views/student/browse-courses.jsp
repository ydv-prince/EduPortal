<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="pageTitle" value="Explore Courses"/>
<%@ include file="../common/header.jsp" %>

<style>
    :root {
        --bg-dark: #020617;
        --surface: rgba(15, 23, 42, 0.6);
        --primary: #6366f1;
        --accent: #a855f7;
        --emerald: #10b981;
        --warning: #f59e0b;
        --text-dim: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.08);
    }

    body { background-color: var(--bg-dark); color: #f8fafc; overflow-x: hidden; }

    .catalog-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 50% 10%, rgba(99, 102, 241, 0.04) 0%, transparent 60%),
                    radial-gradient(circle at 10% 90%, rgba(168, 85, 247, 0.03) 0%, transparent 50%);
        z-index: -1; pointer-events: none;
    }

    .glass-filter-bar { 
        background: var(--surface); backdrop-filter: blur(16px); 
        border: 1px solid var(--glass-border); border-radius: 24px; 
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    }

    .form-label-dark { color: var(--text-dim); font-size: 0.75rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; display: block; }
    
    .input-wrapper { position: relative; }
    .input-wrapper i { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #64748b; font-size: 0.9rem; transition: 0.3s; }
    
    .form-control-dark { 
        background: rgba(0,0,0,0.2); border: 1.5px solid var(--glass-border); 
        color: white; border-radius: 14px; padding: 12px 16px 12px 42px; width: 100%;
        font-size: 0.95rem; transition: 0.3s; appearance: none;
    }
    .form-control-dark:focus { border-color: var(--primary); outline: none; background: rgba(0,0,0,0.4); box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1); }
    
    .course-card-dark { 
        background: rgba(255, 255, 255, 0.02); backdrop-filter: blur(10px);
        border-radius: 24px; overflow: hidden; border: 1px solid var(--glass-border);
        transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); cursor: pointer; 
        height: 100%; display: flex; flex-direction: column; text-decoration: none;
    }
    .course-card-dark:hover { transform: translateY(-8px); border-color: var(--primary); box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
    
    .instructor-img { width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1.5px solid var(--primary); }
    .letter-avatar { width: 28px; height: 28px; border-radius: 50%; background: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 800; }

    @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    .animate-fade { animation: fadeInUp 0.5s ease-out forwards; opacity: 0; }
</style>

<div class="catalog-glow"></div>

<div class="container-fluid px-lg-5 py-4">
    
    <sec:authorize access="isAuthenticated()" var="isLoggedIn" />

    <div class="row g-4">
        
        <c:if test="${isLoggedIn}">
            <div class="col-lg-3 d-none d-lg-block">
                <%@ include file="../common/sidebar.jsp" %>
            </div>
        </c:if>

        <div class="${isLoggedIn ? 'col-lg-9' : 'col-12'}">
            
            <%-- Header & Filters --%>
            <div class="glass-filter-bar mb-5 animate-fade">
                <div class="p-4 p-md-5">
                    <div class="mb-4 text-center text-md-start">
                        <h1 class="display-6 fw-900 text-white mb-2"><i class="fa-solid fa-compass text-primary me-2"></i> Explore Catalog</h1>
                        <p class="text-dim fs-6 m-0">Master new skills with our premium expert-led courses.</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/courses" method="get">
                        <div class="row g-3 align-items-end">
                            <div class="col-lg-4">
                                <label class="form-label-dark">Search Keywords</label>
                                <div class="input-wrapper">
                                    <input type="text" name="keyword" class="form-control-dark" placeholder="Search skills, topics..." value="${keyword}"/>
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </div>
                            </div>

                            <div class="col-lg-3">
                                <label class="form-label-dark">Category</label>
                                <select name="categoryId" class="form-control-dark">
                                    <option value="">All Categories</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-lg-3">
                                <label class="form-label-dark">Difficulty</label>
                                <select name="level" class="form-control-dark">
                                    <option value="">Any Level</option>
                                    <option value="BEGINNER" ${param.level == 'BEGINNER' ? 'selected' : ''}>Beginner Friendly</option>
                                    <option value="INTERMEDIATE" ${param.level == 'INTERMEDIATE' ? 'selected' : ''}>Intermediate</option>
                                    <option value="ADVANCED" ${param.level == 'ADVANCED' ? 'selected' : ''}>Advanced</option>
                                </select>
                            </div>

                            <div class="col-lg-2">
                                <button type="submit" class="btn-filter">
                                    <i class="fa-solid fa-filter me-2"></i> Filter
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="row g-4">
                <c:forEach var="course" items="${courses}" varStatus="status">
                    <div class="${isLoggedIn ? 'col-md-6 col-xl-4' : 'col-md-6 col-lg-4 col-xl-3'} animate-fade" style="animation-delay: ${status.index * 0.05}s;">
                        
                        <a href="${pageContext.request.contextPath}/student/course-detail/${course.id}" class="course-card-dark h-100">
                            <div class="course-thumb-dark">
                                <c:choose>
                                    <c:when test="${not empty course.thumbnailUrl}">
                                        <img src="${pageContext.request.contextPath}${course.thumbnailUrl}" class="course-thumb-img" alt="${course.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="h-100 d-flex align-items-center justify-content-center bg-dark">
                                            <i class="fa-solid fa-laptop-code fa-4x text-primary opacity-20"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="p-4 flex-grow-1 d-flex flex-column">
                                <div class="d-flex flex-wrap gap-2 mb-3">
                                    <span class="badge-modern bg-category small">${course.category.name}</span>
                                    <span class="badge-modern ${course.level == 'BEGINNER' ? 'bg-beginner' : (course.level == 'INTERMEDIATE' ? 'bg-intermediate' : 'bg-advanced')}">
                                        ${course.level}
                                    </span>
                                </div>

                                <h5 class="text-white fw-900 mb-3">${course.title}</h5>

                                <%-- ✅ FIXED PROFILE IMAGE LOGIC --%>
                                <div class="text-dim small mb-4 d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${not empty course.instructor.profilePicture}">
                                            <img src="${pageContext.request.contextPath}${course.instructor.profilePicture}" class="instructor-img" alt="Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="letter-avatar">
                                                ${course.instructor.fullName.substring(0,1).toUpperCase()}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="text-truncate">${course.instructor.fullName}</span>
                                </div>

                                <div class="mt-auto d-flex justify-content-between align-items-center pt-3 border-top border-white-50 border-opacity-10">
                                    <div class="fw-900 fs-5 text-white">
                                        <c:choose>
                                            <c:when test="${course.price == 0}">FREE</c:when>
                                            <c:otherwise>₹${course.price}</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span class="text-primary small fw-800">DETAILS <i class="fa-solid fa-arrow-right ms-1"></i></span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty courses}">
                <div class="text-center py-5 glass-card">
                    <i class="fa-solid fa-ghost fa-4x text-dim opacity-20 mb-4"></i>
                    <h4 class="text-white">No courses match your search</h4>
                    <p class="text-dim">Try clearing your filters or searching for something else.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>