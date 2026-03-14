<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="${course.title} - Details"/>
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

    .detail-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 70% 10%, rgba(99, 102, 241, 0.05) 0%, transparent 60%);
        z-index: -1; pointer-events: none;
    }

    .glass-card { 
        background: var(--surface); backdrop-filter: blur(12px); 
        border: 1px solid var(--glass-border); border-radius: 24px; 
    }

    .hero-container { position: relative; border-radius: 24px; overflow: hidden; margin-bottom: 2rem; border: 1px solid var(--glass-border); }
    .course-hero-img { width: 100%; height: 400px; object-fit: cover; filter: brightness(0.8); transition: 0.5s; }
    
    .hero-overlay {
        position: absolute; inset: 0;
        background: linear-gradient(to top, rgba(2, 6, 23, 1) 0%, rgba(2, 6, 23, 0.2) 60%, transparent 100%);
        display: flex; flex-direction: column; justify-content: flex-end; padding: 40px;
    }

    .instructor-avatar-img { 
        width: 48px; height: 48px; border-radius: 14px; 
        object-fit: cover; border: 2px solid var(--primary);
    }

    .instructor-avatar-initial { 
        width: 48px; height: 48px; border-radius: 14px; 
        background: linear-gradient(135deg, var(--primary), var(--accent));
        display: flex; align-items: center; justify-content: center;
        font-weight: 900; color: white; font-size: 1.2rem;
    }

    .module-header { 
        background: rgba(255, 255, 255, 0.02); border: 1px solid var(--glass-border);
        border-radius: 16px; padding: 18px 24px; transition: 0.3s; cursor: pointer; 
        display: flex; justify-content: space-between; align-items: center;
    }
    .module-header.open { border-color: var(--primary); background: rgba(99, 102, 241, 0.1); }
    
    .lesson-list { background: rgba(0,0,0,0.2); border-radius: 0 0 16px 16px; display: none; padding: 10px; border: 1px solid var(--glass-border); border-top: none; }

    .btn-action-glow {
        background: var(--primary); color: white; border: none; padding: 16px;
        border-radius: 16px; font-weight: 800; font-size: 1.1rem; transition: 0.3s;
        box-shadow: 0 10px 30px rgba(99, 102, 241, 0.3); width: 100%; display: block; text-align: center; text-decoration: none;
    }
    .btn-success-glow { background: var(--emerald); }

    /* Star Rating Fix */
    .star-rating label { color: #475569; font-size: 2rem; cursor: pointer; transition: 0.2s; }
    .star-rating input:checked ~ label, .star-rating label:hover, .star-rating label:hover ~ label { color: var(--warning) !important; }

    @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    .animate-fade-in { animation: fadeInUp 0.6s ease-out forwards; }
</style>

<div class="detail-glow"></div>

<div class="container-fluid px-lg-5 py-4">
    
    <div class="mb-4 small fw-700 animate-fade-in">
        <a href="${pageContext.request.contextPath}/courses" class="text-dim text-decoration-none">Explore Catalog</a> 
        <i class="fa-solid fa-chevron-right mx-2 text-white-50"></i> 
        <span class="text-primary">${course.category.name}</span>
    </div>

    <div class="row g-5">
        <div class="col-lg-8 animate-fade-in">
            
            <div class="hero-container shadow-lg">
                <img src="${pageContext.request.contextPath}${course.thumbnailUrl}" class="course-hero-img" alt="Banner">
                <div class="hero-overlay">
                    <h1 class="display-5 fw-900 text-white mb-0">${course.title}</h1>
                </div>
            </div>

            <%-- Meta Row with Date Fix --%>
            <div class="d-flex align-items-center flex-wrap gap-4 mb-5 pb-4 border-bottom border-white-50 border-opacity-10">
                <div class="d-flex align-items-center gap-2">
                    <i class="fa-solid fa-star text-warning"></i>
                    <span class="fw-900 fs-5 text-white">${avgRating}</span>
                </div>
                <div class="text-dim small fw-600">
                    <i class="fa-solid fa-calendar-day text-primary me-2"></i>
                    Last Updated: ${course.updatedAt != null ? course.updatedAt : 'March 2026'}
                </div>
                
                <div class="d-flex align-items-center gap-3 ms-md-auto">
                    <c:choose>
                        <c:when test="${not empty course.instructor.profilePicture}">
                            <img src="${pageContext.request.contextPath}${course.instructor.profilePicture}" class="instructor-avatar-img">
                        </c:when>
                        <c:otherwise>
                            <div class="instructor-avatar-initial">${course.instructor.fullName.substring(0,1)}</div>
                        </c:otherwise>
                    </c:choose>
                    <div class="fw-800 text-white">${course.instructor.fullName}</div>
                </div>
            </div>

            <div class="glass-card p-4 p-md-5 mb-5 shadow-sm">
                <h4 class="fw-900 text-white mb-4">About This Course</h4>
                <p class="text-dim" style="line-height: 1.8;">${course.description}</p>
            </div>

            <%-- Syllabus Section --%>
            <div class="mb-5">
                <h4 class="fw-900 text-white mb-4">Course Curriculum</h4>
                <c:forEach var="module" items="${course.modules}">
                    <div class="module-item">
                        <div class="module-header" onclick="toggleModule('mod-${module.id}', this)">
                            <span class="fw-800 text-white">${module.title}</span>
                            <i class="fa-solid fa-chevron-down transition-rotate text-dim"></i>
                        </div>
                        <div id="mod-${module.id}" class="lesson-list">
                            <c:forEach var="lesson" items="${module.lessons}">
                                <div class="p-2 text-dim border-bottom border-white-50 border-opacity-5">
                                    <i class="fa-solid fa-circle-play me-2 text-primary"></i> ${lesson.title}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <%-- Reviews Section with Date Fix --%>
            <div class="mb-5 border-top border-white-50 border-opacity-10 pt-5">
                <h4 class="fw-900 text-white mb-4">Student Reviews</h4>
                <div class="row g-4">
                    <c:forEach var="rev" items="${reviews}">
                        <div class="col-md-6">
                            <div class="glass-card p-4">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-white fw-bold">${rev.user.fullName}</span>
                                    <span class="text-muted small">${rev.reviewDate != null ? rev.reviewDate : 'Recently'}</span>
                                </div>
                                <div class="text-warning mb-2">
                                    <c:forEach begin="1" end="${rev.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                </div>
                                <p class="text-dim small m-0">"${rev.comment}"</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <%-- Sticky Sidebar --%>
        <div class="col-lg-4">
            <div class="glass-card p-4 p-md-5 sticky-top" style="top: 100px;">
                <h2 class="display-6 fw-900 text-white mb-4">₹${course.price}</h2>
                <c:choose>
                    <c:when test="${isEnrolled}">
                        <a href="${pageContext.request.contextPath}/student/learn/${course.id}" class="btn-action-glow btn-success-glow">Enter Classroom</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/student/payment/${course.id}" class="btn-action-glow">Buy Now</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleModule(id, header) {
        const content = document.getElementById(id);
        const icon = header.querySelector('.fa-chevron-down');
        const isHidden = window.getComputedStyle(content).display === "none";
        
        if (isHidden) {
            content.style.display = "block";
            header.classList.add('open');
            icon.style.transform = "rotate(180deg)";
        } else {
            content.style.display = "none";
            header.classList.remove('open');
            icon.style.transform = "rotate(0deg)";
        }
    }
</script>

<%@ include file="../common/footer.jsp" %>