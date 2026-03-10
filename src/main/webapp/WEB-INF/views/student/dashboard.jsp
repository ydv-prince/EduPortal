<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Learning Dashboard"/>
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

    /* ── Ambient Background Glow ── */
    .dashboard-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 10% 20%, rgba(99, 102, 241, 0.03) 0%, transparent 50%),
                    radial-gradient(circle at 90% 80%, rgba(168, 85, 247, 0.03) 0%, transparent 50%);
        z-index: -1;
    }

    /* ── Animations ── */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-in { animation: fadeInUp 0.6s ease-out forwards; opacity: 0; }
    .delay-1 { animation-delay: 0.1s; }
    .delay-2 { animation-delay: 0.2s; }
    .delay-3 { animation-delay: 0.3s; }

    /* ── Futuristic Welcome Banner ── */
    .welcome-banner { 
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.9) 0%, rgba(168, 85, 247, 0.9) 100%); 
        backdrop-filter: blur(15px); border-radius: 32px; padding: 40px; 
        border: 1px solid rgba(255,255,255,0.2); position: relative; overflow: hidden;
        box-shadow: 0 20px 40px rgba(0,0,0,0.3);
    }
    .banner-circle {
        position: absolute; top: -50px; right: -50px; width: 250px; height: 250px;
        background: white; opacity: 0.1; border-radius: 50%;
    }

    /* ── Stat Cards ── */
    .stat-card-v3 { 
        background: var(--surface); backdrop-filter: blur(12px);
        padding: 20px; border-radius: 24px; border: 1px solid var(--glass-border); 
        transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        display: flex; align-items: center; gap: 15px; height: 100%;
    }
    .stat-card-v3:hover { transform: translateY(-8px); border-color: var(--primary); background: rgba(15, 23, 42, 0.8); }
    
    .stat-icon-wrap {
        width: 48px; height: 48px; border-radius: 14px; flex-shrink: 0;
        display: flex; align-items: center; justify-content: center; font-size: 1.2rem;
    }
    .icon-blue { background: rgba(99, 102, 241, 0.15); color: #818cf8; }
    .icon-green { background: rgba(16, 185, 129, 0.15); color: #34d399; }
    .icon-gold { background: rgba(245, 158, 11, 0.15); color: #fbbf24; }
    .icon-purple { background: rgba(168, 85, 247, 0.15); color: #c084fc; }

    /* ── Learning Row ── */
    .learning-row-modern {
        background: rgba(255, 255, 255, 0.02); border-radius: 20px;
        padding: 20px; border: 1px solid var(--glass-border);
        transition: 0.3s ease; margin-bottom: 12px;
    }
    .learning-row-modern:hover { background: rgba(255, 255, 255, 0.04); border-color: rgba(99, 102, 241, 0.3); }

    .progress-track { background: rgba(255, 255, 255, 0.05); border-radius: 20px; height: 8px; overflow: hidden; }
    .progress-fill-glow { 
        background: linear-gradient(90deg, var(--primary), var(--accent)); 
        box-shadow: 0 0 10px rgba(99, 102, 241, 0.4); border-radius: 20px;
        height: 100%; transition: width 1s ease-in-out;
    }

    .btn-action-glow {
        background: var(--primary); color: white; border: none; padding: 10px 20px;
        border-radius: 12px; font-weight: 700; transition: 0.3s; text-decoration: none;
        display: inline-flex; align-items: center; justify-content: center; font-size: 0.9rem;
    }
    .btn-action-glow:hover { transform: scale(1.05); background: #4f46e5; box-shadow: 0 8px 20px rgba(99, 102, 241, 0.3); color: white; }

    .card-title-modern { font-weight: 800; color: white; display: flex; align-items: center; gap: 10px; font-size: 1.15rem; }
    
    @media (max-width: 768px) {
        .stat-card-v3 { flex-direction: column; text-align: center; padding: 15px; }
        .welcome-banner { padding: 30px 20px; text-align: center; }
    }
</style>

<div class="dashboard-glow"></div>

<div class="container-fluid px-lg-5 py-4">
    <div class="row g-4">
        <div class="col-lg-3 d-none d-lg-block">
            <%@ include file="../common/sidebar.jsp" %>
        </div>

        <%-- ✅ FIX: Changed from "col-lg-9 col-xl-10" to just "col-lg-9" to match the 12-column grid --%>
        <div class="col-lg-9">
            
            <%-- Welcome Banner --%>
            <div class="welcome-banner mb-4 animate-fade-in">
                <div class="banner-circle"></div>
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="display-6 fw-900 text-white mb-2">Welcome Back, ${student.fullName.split(' ')[0]}! 🚀</h1>
                        <p class="fs-6 text-white-50 mb-4 opacity-75">You've completed <b>${completedCourses}</b> courses. Let's keep the momentum going!</p>
                        <a href="${pageContext.request.contextPath}/student/my-courses" class="btn btn-white rounded-pill px-4 py-2 fw-800 bg-white text-dark border-0 shadow-lg">Resume Learning</a>
                    </div>
                    <div class="col-md-4 d-none d-md-block text-end">
                        <i class="fa-solid fa-user-astronaut display-1 text-white opacity-20"></i>
                    </div>
                </div>
            </div>

            <%-- Stats Grid --%>
            <div class="row g-3 mb-4 animate-fade-in delay-1">
                <div class="col-md-3 col-6">
                    <div class="stat-card-v3">
                        <div class="stat-icon-wrap icon-blue"><i class="fa-solid fa-book-open"></i></div>
                        <div>
                            <div class="text-dim x-small fw-700 text-uppercase" style="letter-spacing: 1px;">Enrolled</div>
                            <div class="h4 fw-800 m-0">${totalEnrolled}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card-v3">
                        <div class="stat-icon-wrap icon-green"><i class="fa-solid fa-circle-check"></i></div>
                        <div>
                            <div class="text-dim x-small fw-700 text-uppercase" style="letter-spacing: 1px;">Finished</div>
                            <div class="h4 fw-800 m-0">${completedCourses}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card-v3">
                        <div class="stat-icon-wrap icon-gold"><i class="fa-solid fa-medal"></i></div>
                        <div>
                            <div class="text-dim x-small fw-700 text-uppercase" style="letter-spacing: 1px;">Badges</div>
                            <div class="h4 fw-800 m-0">${certificates.size()}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card-v3">
                        <div class="stat-icon-wrap icon-purple"><i class="fa-solid fa-bolt-lightning"></i></div>
                        <div>
                            <div class="text-dim x-small fw-700 text-uppercase" style="letter-spacing: 1px;">Avg Score</div>
                            <div class="h4 fw-800 m-0">
                                <c:choose>
                                    <c:when test="${not empty quizResults}">
                                        <fmt:formatNumber value="${quizResults[0].percentage}" maxFractionDigits="0"/>%
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Active Track Section --%>
            <div class="glass-card p-4 mb-4 animate-fade-in delay-2">
                <div class="d-flex justify-content-between align-items-center mb-4 px-2">
                    <h4 class="card-title-modern m-0"><i class="fa-solid fa-fire-flame-curved text-warning"></i> Continue Learning</h4>
                    <a href="${pageContext.request.contextPath}/student/my-courses" class="text-dim small text-decoration-none hover-white">View All →</a>
                </div>

                <c:choose>
                    <c:when test="${not empty enrollments}">
                        <c:forEach var="e" items="${enrollments}" varStatus="s">
                            <c:if test="${s.index < 3}">
                                <div class="learning-row-modern">
                                    <div class="row align-items-center">
                                        <div class="col-md-5 mb-3 mb-md-0">
                                            <h6 class="text-white fw-800 mb-1 fs-6">${e.course.title}</h6>
                                            <span class="text-dim small"><i class="fa-solid fa-chalkboard-user me-2"></i>${e.course.instructor.fullName}</span>
                                        </div>
                                        <div class="col-md-4 mb-3 mb-md-0">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="text-dim small fw-600">Progress</span>
                                                <span class="text-primary fw-800 small">${e.progressPercent}%</span>
                                            </div>
                                            <div class="progress-track">
                                                <div class="progress-fill-glow" style="width:${e.progressPercent}%"></div>
                                            </div>
                                        </div>
                                        <div class="col-md-3 text-md-end text-center">
                                            <a href="${pageContext.request.contextPath}/student/learn/${e.course.id}" class="btn-action-glow w-100">Resume</a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <div class="opacity-20 mb-3"><i class="fa-solid fa-book-open fa-3x"></i></div>
                            <h6 class="text-dim">Your library is empty. Let's find a course!</h6>
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary rounded-pill mt-3 px-4">Browse Catalog</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="row g-4 animate-fade-in delay-3">
                <div class="col-lg-6">
                    <div class="glass-card p-4 h-100 shadow-sm">
                        <h5 class="card-title-modern mb-4"><i class="fa-solid fa-award text-warning"></i> Certificates</h5>
                        <c:choose>
                            <c:when test="${not empty certificates}">
                                <c:forEach var="cert" items="${certificates}" varStatus="s">
                                    <div class="d-flex align-items-center gap-3 p-3 rounded-4 mb-3" style="background: rgba(255,255,255,0.03); border: 1px solid var(--glass-border);">
                                        <div class="icon-gold p-3 rounded-3"><i class="fa-solid fa-shield-halved"></i></div>
                                        <div class="flex-grow-1 overflow-hidden">
                                            <div class="text-white fw-700 text-truncate small">${cert.course.title}</div>
                                            <div class="text-dim x-small">No: ${cert.certificateNumber}</div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/student/certificates" class="btn btn-outline-light btn-sm rounded-circle"><i class="fa-solid fa-download"></i></a>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 opacity-25">
                                    <i class="fa-solid fa-medal fa-3x mb-2"></i>
                                    <p class="small">No credentials yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="glass-card p-4 h-100 shadow-sm">
                        <h5 class="card-title-modern mb-4"><i class="fa-solid fa-clipboard-check text-emerald"></i> Recent Assessments</h5>
                        <c:choose>
                            <c:when test="${not empty quizResults}">
                                <div class="table-responsive">
                                    <table class="table table-dark table-borderless align-middle mb-0">
                                        <c:forEach var="qr" items="${quizResults}" varStatus="s">
                                            <tr class="border-bottom border-white-50 border-opacity-10">
                                                <td class="py-3 text-dim fw-600 small">${qr.quiz.title}</td>
                                                <td class="py-3 text-end"><span class="fw-800 text-primary">${qr.percentage}%</span></td>
                                                <td class="py-3 text-end">
                                                    <span class="badge rounded-pill ${qr.passed ? 'bg-success' : 'bg-danger'} bg-opacity-20 text-${qr.passed ? 'success' : 'danger'}" style="font-size: 0.65rem;">
                                                        ${qr.passed ? 'PASSED' : 'FAILED'}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                 <div class="text-center py-5 opacity-25">
                                    <i class="fa-solid fa-clipboard-question fa-3x mb-2"></i>
                                    <p class="small">Take a quiz to see results.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>