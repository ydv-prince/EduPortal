<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Learning: ${course.title}"/>
<%@ include file="../common/header.jsp" %>

<style>
    :root {
        --bg-dark: #020617;
        --surface: rgba(15, 23, 42, 0.7);
        --primary: #6366f1;
        --accent: #a855f7;
        --emerald: #10b981;
        --warning: #f59e0b;
        --text-dim: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.08);
    }

    body { background-color: var(--bg-dark); color: #f8fafc; overflow-x: hidden; }

    .learn-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 50% 0%, rgba(99, 102, 241, 0.05) 0%, transparent 50%);
        z-index: -1; pointer-events: none;
    }

    @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    .animate-fade { animation: fadeInUp 0.6s ease-out forwards; opacity: 0; }
    .delay-1 { animation-delay: 0.1s; }
    .delay-2 { animation-delay: 0.2s; }

    .top-nav-bar {
        display: flex; align-items: center; justify-content: space-between;
        padding: 15px 0; margin-bottom: 10px; border-bottom: 1px solid var(--glass-border);
    }
    .btn-back {
        background: rgba(255,255,255,0.03); color: white; border: 1px solid var(--glass-border);
        padding: 8px 16px; border-radius: 10px; font-weight: 700; font-size: 0.85rem;
        transition: 0.3s; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-back:hover { background: rgba(255,255,255,0.1); color: white; transform: translateX(-3px); }

    .learn-layout { display: grid; grid-template-columns: 1fr 380px; gap: 24px; align-items: start; padding-bottom: 30px; }
    @media (max-width: 1200px) {
        .learn-layout { grid-template-columns: 1fr; }
        .sidebar-wrapper { order: 2; height: auto; position: static; }
    }

    .video-hero {
        background: #000; border-radius: 20px; overflow: hidden;
        box-shadow: 0 25px 50px rgba(0,0,0,0.5); aspect-ratio: 16/9;
        position: relative; border: 1px solid var(--glass-border);
    }
    .video-hero iframe { width: 100%; height: 100%; border: none; position: absolute; top: 0; left: 0; }

    .glass-card { background: var(--surface); backdrop-filter: blur(12px); border: 1px solid var(--glass-border); border-radius: 20px; }

    .progress-track { background: rgba(255, 255, 255, 0.05); border-radius: 20px; height: 8px; overflow: hidden; }
    .progress-fill-glow { background: linear-gradient(90deg, var(--primary), var(--accent)); box-shadow: 0 0 12px rgba(99, 102, 241, 0.5); border-radius: 20px; height: 100%; transition: width 1s ease-in-out; }

    .sidebar-wrapper { position: sticky; top: 20px; height: calc(100vh - 40px); display: flex; flex-direction: column; }
    
    .lesson-list-scroll { flex-grow: 1; overflow-y: auto; padding-right: 5px; }
    .lesson-list-scroll::-webkit-scrollbar { width: 4px; }
    .lesson-list-scroll::-webkit-scrollbar-thumb { background: rgba(99, 102, 241, 0.5); border-radius: 10px; }

    .module-group-header {
        padding: 16px 20px; background: rgba(255,255,255,0.02);
        border-bottom: 1px solid rgba(255,255,255,0.05); cursor: pointer;
        display: flex; align-items: center; gap: 12px; transition: 0.3s;
    }
    .module-group-header:hover { background: rgba(255,255,255,0.05); }

    .lesson-nav-item {
        padding: 14px 20px 14px 45px; display: flex; align-items: center; gap: 12px;
        color: var(--text-dim); text-decoration: none; font-size: 0.85rem;
        border-bottom: 1px solid rgba(255,255,255,0.02); transition: 0.3s;
    }
    .lesson-nav-item:hover { background: rgba(99, 102, 241, 0.05); color: white; }
    .lesson-nav-item.active { background: rgba(99, 102, 241, 0.1); color: white; font-weight: 700; border-right: 3px solid var(--primary); }
    
    .btn-complete { background: rgba(16, 185, 129, 0.1); color: var(--emerald); border: 1px solid rgba(16, 185, 129, 0.3); padding: 10px 20px; border-radius: 12px; font-weight: 700; transition: 0.3s; }
    .btn-complete:hover { background: var(--emerald); color: white; box-shadow: 0 10px 20px rgba(16, 185, 129, 0.3); transform: scale(1.05); }

    .transition-rotate { transition: transform 0.3s ease; }
    .upload-input { background: rgba(0,0,0,0.3); color: white; border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 10px; }
</style>

<div class="learn-glow"></div>

<div class="container-fluid px-lg-4 pb-5">
    
    <div class="top-nav-bar animate-fade">
        <a href="${pageContext.request.contextPath}/student/my-courses" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i> Back to Library
        </a>
        <div class="text-white fw-800 fs-5 d-none d-md-block">${course.title}</div>
        <div style="width: 100px;"></div>
    </div>

    <div class="learn-layout">

        <%-- LEFT: Main Content Area --%>
        <div class="main-player-area animate-fade delay-1">
            
            <c:choose>
                <%-- ✅ CASE 1: Video Lesson Display --%>
                <c:when test="${not empty currentLesson}">
                    <div class="video-hero mb-4 shadow-lg">
                        <c:choose>
                            <c:when test="${not empty currentLesson.videoUrl}">
                                <%-- MASTER FIX: YouTube Link Transformer --%>
                                <c:set var="rawUrl" value="${currentLesson.videoUrl}" />
                                <c:set var="finalUrl" value="${rawUrl}" />

                                <c:choose>
                                    <%-- Handle Standard watch?v= Links --%>
                                    <c:when test="${fn:contains(rawUrl, 'watch?v=')}">
                                        <c:set var="finalUrl" value="${fn:replace(rawUrl, 'www.youtube.com/watch?v=', 'www.youtube-nocookie.com/embed/')}" />
                                        <%-- Ensure params like &t= work by replacing first & with ? --%>
                                        <c:set var="finalUrl" value="${fn:replace(finalUrl, '&', '?')}" />
                                    </c:when>

                                    <%-- Handle youtu.be/ Short Links --%>
                                    <c:when test="${fn:contains(rawUrl, 'youtu.be/')}">
                                        <c:set var="finalUrl" value="${fn:replace(rawUrl, 'youtu.be/', 'www.youtube-nocookie.com/embed/')}" />
                                    </c:when>
                                    
                                    <%-- Basic security for standard youtube domain links --%>
                                    <c:when test="${fn:contains(rawUrl, 'youtube.com/watch?v=')}">
                                         <c:set var="finalUrl" value="${fn:replace(rawUrl, 'youtube.com/watch?v=', 'youtube-nocookie.com/embed/')}" />
                                    </c:when>
                                </c:choose>
                                
                                <iframe src="${finalUrl}" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex flex-column align-items-center justify-content-center h-100 text-center p-4">
                                    <i class="fa-solid fa-play-circle mb-3 opacity-20" style="font-size: 5rem;"></i>
                                    <h5 class="text-dim">Video not available for this lesson.</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="glass-card p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-4 mb-2">
                            <div>
                                <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 py-2 mb-3 fw-bold" style="font-size: 0.7rem;">NOW WATCHING</span>
                                <h2 class="text-white fw-900 mb-1">${currentLesson.title}</h2>
                                <p class="text-dim small m-0"><i class="fa-solid fa-user-tie me-2"></i> ${course.instructor.fullName}</p>
                            </div>
                            
                            <form action="${pageContext.request.contextPath}/student/lesson/complete" method="post" class="m-0">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="lessonId" value="${currentLesson.id}"/>
                                <input type="hidden" name="courseId" value="${course.id}"/>
                                <button type="submit" class="btn-complete">
                                    <i class="fa-solid fa-check-circle me-2"></i> Complete Lesson
                                </button>
                            </form>
                        </div>
                        <c:if test="${not empty currentLesson.content}">
                            <div class="mt-4 pt-4 border-top border-white-50 border-opacity-10 text-dim">
                                ${currentLesson.content}
                            </div>
                        </c:if>
                    </div>
                </c:when>

                <%-- ✅ CASE 2: Quiz Portal View --%>
                <c:when test="${quizMode}">
                    <div class="glass-card p-5 mb-4 border-accent border-opacity-25 shadow-lg text-center">
                        <div class="bg-accent bg-opacity-10 p-4 rounded-circle text-accent d-inline-flex mb-4">
                            <i class="fa-solid fa-clipboard-question fs-1"></i>
                        </div>
                        <h2 class="text-white fw-900 mb-3">${currentAssignment.title}</h2>
                        <p class="text-dim mb-5 mx-auto" style="max-width: 600px;">
                            ${currentAssignment.description}
                        </p>
                        
                        <div class="bg-dark bg-opacity-40 p-4 rounded-4 border border-white-50 border-opacity-10 d-inline-block">
                            <h6 class="text-white fw-800 mb-3">Quiz Instructions:</h6>
                            <ul class="text-dim small text-start mb-4">
                                <li>Ensure you have a stable internet connection.</li>
                                <li>Once started, do not refresh the page.</li>
                                <li>Score will be calculated automatically.</li>
                            </ul>
                            <a href="${pageContext.request.contextPath}/student/quiz/${currentAssignment.id}" class="btn btn-primary">Start Quiz</a>
                        </div>
                    </div>
                </c:when>

                <%-- ✅ CASE 3: Normal Assignment submission --%>
                <c:when test="${not empty currentAssignment}">
                    <div class="glass-card p-5 mb-4 border-warning border-opacity-25">
                        <h2 class="text-white fw-900 mb-4"><i class="fa-solid fa-file-pen text-warning me-3"></i>${currentAssignment.title}</h2>
                        <div class="text-dim mb-5">
                            <h6 class="text-white fw-800 mb-3">Questions</h6>
                            ${currentAssignment.description}
                        </div>

                        <div class="bg-dark bg-opacity-50 p-4 rounded-4 border border-white-50 border-opacity-10">
                            <c:choose>
                                <c:when test="${not empty existingSubmission}">
                                    <h6 class="text-white fw-800 mb-3">Your Submission</h6>
                                    <c:if test="${not empty existingSubmission.submissionText}">
                                        <div class="p-3 rounded-4 mb-3" style="background: rgba(255,255,255,0.04); color: var(--text-dim);">
                                            ${existingSubmission.submissionText}
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty existingSubmission.fileName}">
                                        <div class="small text-white mb-3">
                                            <i class="fa-solid fa-paperclip me-2 text-warning"></i>${existingSubmission.fileName}
                                        </div>
                                    </c:if>
                                    <div class="small ${existingSubmission.graded ? 'text-success' : 'text-warning'}">
                                        ${existingSubmission.graded ? 'Reviewed by instructor.' : 'Submitted and awaiting review.'}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <h6 class="text-white fw-800 mb-3">Answer the Task</h6>
                                    <form action="${pageContext.request.contextPath}/student/assignment/submit" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="hidden" name="assignmentId" value="${currentAssignment.id}"/>
                                        <input type="hidden" name="courseId" value="${course.id}"/>
                                        <textarea name="answerText" class="form-control upload-input mb-3" rows="6" placeholder="Write your answer and follow the teacher's questions and instructions here..."></textarea>
                                        <input type="file" name="file" class="form-control upload-input mb-3">
                                        <button type="submit" class="btn btn-warning rounded-pill px-4 fw-bold shadow-sm">
                                            <i class="fa-solid fa-upload me-2"></i> Submit Answer
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <%-- Default State --%>
                <c:otherwise>
                    <div class="video-hero mb-4 d-flex flex-column align-items-center justify-content-center h-100 text-center">
                        <i class="fa-solid fa-graduation-cap mb-3 opacity-10" style="font-size: 6rem;"></i>
                        <h4 class="text-white fw-800">Select a lesson to begin your journey</h4>
                    </div>
                </c:otherwise>
            </c:choose>

            <%-- Progress Section --%>
            <div class="glass-card p-4 mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-white fw-800 fs-5">Overall Progress</span>
                    <span class="text-primary fw-900 h4 m-0">${enrollment.progressPercent}%</span>
                </div>
                <div class="progress-track">
                    <div class="progress-fill-glow" style="width:${enrollment.progressPercent}%"></div>
                </div>
            </div>
        </div>

        <%-- RIGHT: Enhanced Sidebar --%>
        <div class="sidebar-wrapper animate-fade delay-2">
            <div class="glass-card d-flex flex-column h-100 overflow-hidden">
                <div class="p-4 border-bottom border-white-50 border-opacity-10">
                    <h6 class="text-white fw-800 m-0"><i class="fa-solid fa-stream text-primary me-2"></i> Curriculum</h6>
                </div>

                <div class="lesson-list-scroll">
                    <c:forEach var="cmod" items="${modules}">
                        <div class="module-group-header" onclick="toggleSidebarModule('sm-${cmod.id}', this)">
                            <i class="fa-solid fa-chevron-down text-dim small transition-rotate"></i>
                            <span class="text-white fw-700 small flex-grow-1">${cmod.title}</span>
                        </div>

                        <div id="sm-${cmod.id}" style="display: none;">
                            <%-- Lessons --%>
                            <c:forEach var="lesson" items="${cmod.lessons}">
                                <a href="${pageContext.request.contextPath}/student/learn/${course.id}?lessonId=${lesson.id}" 
                                   class="lesson-nav-item ${currentLesson.id == lesson.id ? 'active' : ''}">
                                    <i class="fa-solid fa-play-circle opacity-50"></i>
                                    <span class="flex-grow-1 text-truncate">${lesson.title}</span>
                                </a>
                            </c:forEach>

                            <%-- Assignments & Quizzes --%>
                            <c:forEach var="assignment" items="${cmod.assignments}">
                                <a href="${pageContext.request.contextPath}/student/learn/${course.id}?assignmentId=${assignment.id}" 
                                   class="lesson-nav-item ${currentAssignment.id == assignment.id ? 'active' : ''}">
                                    <c:choose>
                                        <c:when test="${assignment.type == 'QUIZ'}">
                                            <i class="fa-solid fa-clipboard-question text-accent"></i>
                                            <span class="flex-grow-1 text-truncate">${assignment.title}</span>
                                            <span class="badge bg-accent bg-opacity-10 text-accent border border-accent border-opacity-25" style="font-size: 0.6rem;">QUIZ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-file-invoice text-warning"></i>
                                            <span class="flex-grow-1 text-truncate">${assignment.title}</span>
                                            <span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25" style="font-size: 0.6rem;">TASK</span>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </c:forEach>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleSidebarModule(id, header) {
        const el = document.getElementById(id);
        const icon = header.querySelector('.transition-rotate');
        if (el.style.display === 'none') {
            el.style.display = 'block';
            icon.style.transform = 'rotate(0deg)';
        } else {
            el.style.display = 'none';
            icon.style.transform = 'rotate(-90deg)';
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const activeItem = document.querySelector('.lesson-nav-item.active');
        if (activeItem) {
            activeItem.parentElement.style.display = 'block';
            activeItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    });
</script>

<%@ include file="../common/footer.jsp" %>