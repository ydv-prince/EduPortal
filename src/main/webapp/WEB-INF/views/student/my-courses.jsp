<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="../common/header.jsp" %>

<style>
    :root {
        --bg-dark: #020617;
        --surface: rgba(15, 23, 42, 0.6);
        --primary: #6366f1;
        --accent: #a855f7;
        --emerald: #10b981;
        --text-dim: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.08);
    }

    body { background-color: var(--bg-dark); color: #f8fafc; overflow-x: hidden; }

    /* ── Ambient Glow ── */
    .library-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 80% 20%, rgba(99, 102, 241, 0.04) 0%, transparent 40%),
                    radial-gradient(circle at 20% 80%, rgba(16, 185, 129, 0.03) 0%, transparent 40%);
        z-index: -1; pointer-events: none;
    }

    /* ── Animations ── */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-in { animation: fadeInUp 0.5s ease-out forwards; opacity: 0; }
    .delay-1 { animation-delay: 0.1s; }
    .delay-2 { animation-delay: 0.2s; }

    /* ── Filter Tabs ── */
    .filter-tab {
        background: rgba(255,255,255,0.03); border: 1px solid var(--glass-border);
        border-radius: 12px; padding: 10px 24px; color: var(--text-dim);
        font-size: 0.85rem; font-weight: 700; cursor: pointer; transition: 0.3s;
    }
    .filter-tab:hover { background: rgba(255,255,255,0.08); color: white; }
    .active-tab { 
        background: rgba(99, 102, 241, 0.15) !important; 
        border-color: var(--primary) !important; 
        color: white !important;
        box-shadow: 0 0 15px rgba(99, 102, 241, 0.2);
    }

    /* ── Course Card ── */
    .course-card-library {
        background: var(--surface); backdrop-filter: blur(12px);
        border-radius: 24px; border: 1px solid var(--glass-border);
        overflow: hidden; transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        height: 100%; display: flex; flex-direction: column;
    }
    .course-card-library:hover { transform: translateY(-8px); border-color: var(--primary); box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
    
    .thumb-area { height: 170px; position: relative; overflow: hidden; background: #000; }
    .thumb-img { width: 100%; height: 100%; object-fit: cover; opacity: 0.6; transition: 0.7s ease; }
    .course-card-library:hover .thumb-img { opacity: 0.8; transform: scale(1.08); }

    .progress-bar-wrap { background: rgba(255,255,255,0.05); border-radius: 10px; height: 6px; overflow: hidden; }
    .progress-fill { background: linear-gradient(90deg, var(--primary), var(--accent)); box-shadow: 0 0 10px rgba(99, 102, 241, 0.5); border-radius: 10px; height: 100%; }
    .progress-fill.completed { background: linear-gradient(90deg, var(--emerald), #059669); box-shadow: 0 0 10px rgba(16, 185, 129, 0.4); }

    .btn-resume {
        background: var(--primary); color: white; border: none; padding: 12px;
        border-radius: 12px; font-weight: 800; font-size: 0.85rem; transition: 0.3s;
        text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 8px;
    }
    .btn-resume:hover { transform: scale(1.03); background: #4f46e5; box-shadow: 0 8px 20px rgba(99, 102, 241, 0.3); color: white; }
</style>

<div class="library-glow"></div>

<div class="container-fluid px-lg-5 py-4">
    <div class="row g-4">
        <%-- SIDEBAR (Fixed Grid Layout to match Dashboard) --%>
        <div class="col-lg-3 d-none d-lg-block">
            <%@ include file="../common/sidebar.jsp" %>
        </div>

        <%-- MAIN CONTENT (Fixed to col-lg-9) --%>
        <div class="col-lg-9">
            
            <%-- Header Area --%>
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3 animate-fade-in">
                <div>
                    <h1 class="display-6 fw-900 text-white mb-1">My Learning 📚</h1>
                    <p class="text-dim fs-6 m-0">You have <b><c:out value="${enrollments.size()}" default="0"/></b> active programs in your library</p>
                </div>
                <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary rounded-pill px-4 py-2 fw-800 shadow-lg">
                    <i class="fa-solid fa-compass me-2"></i> Explore New
                </a>
            </div>

            <%-- Filters --%>
            <div class="d-flex gap-2 mb-4 animate-fade-in delay-1 overflow-auto pb-2">
                <button onclick="filterCourses('all')" id="tab-all" class="filter-tab active-tab flex-shrink-0">All Courses</button>
                <button onclick="filterCourses('progress')" id="tab-progress" class="filter-tab flex-shrink-0">In Progress</button>
                <button onclick="filterCourses('completed')" id="tab-completed" class="filter-tab flex-shrink-0">Completed</button>
            </div>

            <%-- Course Grid --%>
            <c:choose>
                <c:when test="${not empty enrollments}">
                    <div class="row g-4 animate-fade-in delay-2" id="courseGrid">
                        <c:forEach var="e" items="${enrollments}">
                            <div class="col-md-6 col-xl-4 course-item ${e.progressPercent == 100 ? 'completed-item' : 'progress-item'}">
                                <div class="course-card-library shadow-lg">
                                    
                                    <div class="thumb-area">
                                        <c:choose>
                                            <c:when test="${not empty e.course.thumbnailUrl}">
                                                <img src="${pageContext.request.contextPath}${e.course.thumbnailUrl}" alt="Course" class="thumb-img">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="d-flex align-items-center justify-content-center h-100 text-muted opacity-25">
                                                    <i class="fa-solid fa-layer-group fa-4x"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <c:if test="${e.progressPercent == 100}">
                                            <div class="position-absolute top-0 end-0 m-3 badge bg-success rounded-pill px-3 py-2 fw-bold" style="font-size: 0.65rem;">
                                                <i class="fa-solid fa-check-circle me-1"></i> COMPLETED
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="p-4 flex-grow-1 d-flex flex-column">
                                        <div class="text-primary small fw-800 mb-2 text-uppercase" style="letter-spacing: 1px;"><c:out value="${e.course.category != null ? e.course.category.name : 'General'}"/></div>
                                        <h5 class="text-white fw-800 mb-3" style="line-height: 1.4; min-height: 42px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            <c:out value="${e.course.title}"/>
                                        </h5>
                                        
                                        <div class="text-dim small mb-4">
                                            <i class="fa-solid fa-chalkboard-user me-2"></i> <c:out value="${e.course.instructor != null ? e.course.instructor.fullName : 'Instructor'}"/>
                                        </div>

                                        <div class="mt-auto">
                                            <div class="d-flex justify-content-between mb-2 small">
                                                <span class="text-dim fw-600">Progress</span>
                                                <span class="text-white fw-800"><c:out value="${e.progressPercent}" default="0"/>%</span>
                                            </div>
                                            <div class="progress-bar-wrap mb-4">
                                                <div class="progress-fill ${e.progressPercent == 100 ? 'completed' : ''}" style="width: <c:out value="${e.progressPercent}" default="0"/>%"></div>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/student/learn/${e.course.id}" class="btn-resume flex-grow-1">
                                                    <i class="fa-solid ${e.progressPercent == 100 ? 'fa-rotate-right' : 'fa-play'}"></i>
                                                    ${e.progressPercent == 100 ? 'Watch Again' : 'Resume'}
                                                </a>
                                                <a href="${pageContext.request.contextPath}/student/course-detail/${e.course.id}" class="btn btn-dark rounded-3 px-3 border-0 d-flex align-items-center" style="background: rgba(255,255,255,0.05);" title="View Course Details">
                                                    <i class="fa-solid fa-circle-info text-dim"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 glass-card animate-fade-in delay-2">
                        <div class="opacity-20 mb-4 mt-3"><i class="fa-solid fa-box-open fa-4x text-primary"></i></div>
                        <h4 class="text-white fw-800">Your library is empty</h4>
                        <p class="text-dim mb-4">Start your journey by exploring our premium catalog to begin learning.</p>
                        <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary rounded-pill px-5 py-3 fw-800 shadow-lg mb-3">
                            <i class="fa-solid fa-compass me-2"></i> Browse All Courses
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<script>
function filterCourses(type) {
    // Update Tab UI
    document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active-tab'));
    document.getElementById('tab-' + type).classList.add('active-tab');

    // Filter Logic
    const items = document.querySelectorAll('.course-item');
    items.forEach(item => {
        // Reset animation for smooth filter effect
        item.style.animation = 'none';
        item.offsetHeight; /* trigger reflow */
        item.style.animation = null; 
        
        if (type === 'all') {
            item.style.display = 'block';
        } else if (type === 'completed') {
            item.style.display = item.classList.contains('completed-item') ? 'block' : 'none';
        } else if (type === 'progress') {
            item.style.display = item.classList.contains('progress-item') ? 'block' : 'none';
        }
    });
}
</script>

<%@ include file="../common/footer.jsp" %>
