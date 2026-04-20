<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Certificates"/>
<%@ include file="../common/header.jsp" %>

<style>
    :root {
        --bg-dark: #020617;
        --surface: rgba(15, 23, 42, 0.6);
        --primary: #6366f1;
        --gold: #f6c23e;
        --emerald: #10b981;
        --text-dim: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.08);
    }

    body { background-color: var(--bg-dark); color: #f8fafc; overflow-x: hidden; }

    .cert-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 50% 20%, rgba(246, 194, 62, 0.05) 0%, transparent 60%);
        z-index: -1; pointer-events: none;
    }

    .cert-card {
        background: rgba(255, 255, 255, 0.02);
        border: 1px solid var(--glass-border);
        border-radius: 24px;
        padding: 28px;
        transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        position: relative;
        overflow: hidden;
        min-height: 420px;
        display: flex;
        flex-direction: column;
    }
    .cert-card:hover {
        transform: translateY(-10px);
        border-color: var(--gold);
        background: rgba(246, 194, 62, 0.03);
        box-shadow: 0 20px 40px rgba(0,0,0,0.4);
    }

    .cert-icon {
        width: 64px; height: 64px; border-radius: 18px;
        background: rgba(246, 194, 62, 0.1);
        color: var(--gold); display: flex; align-items: center; justify-content: center;
        font-size: 2rem; margin-bottom: 24px;
        border: 1px solid rgba(246, 194, 62, 0.2);
    }

    .btn-download-premium {
        background: var(--gold); color: #1e293b; border: none; padding: 12px 20px;
        border-radius: 14px; font-weight: 800; font-size: 0.9rem; transition: 0.3s;
        text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 8px;
    }
    .btn-download-premium:hover { transform: scale(1.03); background: #eab308; color: #000; }

    .btn-view-only {
        background: rgba(255,255,255,0.05); color: white; border: 1px solid var(--glass-border); 
        padding: 12px 20px; border-radius: 14px; font-weight: 700; transition: 0.3s;
        text-decoration: none; display: flex; align-items: center; justify-content: center;
    }
    .btn-view-only:hover { background: rgba(255,255,255,0.15); color: white; }

    @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    .animate-fade { animation: fadeInUp 0.5s ease-out forwards; }
</style>

<div class="cert-glow"></div>

<div class="container-fluid px-lg-5 py-4">
    <div class="row g-4">
        
        <div class="col-lg-3 d-none d-lg-block">
            <%@ include file="../common/sidebar.jsp" %>
        </div>

        <div class="col-lg-9 animate-fade">
            
            <div class="mb-5">
                <h1 class="display-6 fw-900 text-white mb-1">
                    <i class="fa-solid fa-trophy text-gold me-2"></i> Achievement Gallery
                </h1>
                <p class="text-dim fs-6">Manage and showcase your professional credentials.</p>
            </div>

            <c:choose>
                <c:when test="${not empty certificates}">
                    <div class="row g-4">
                        <c:forEach var="cert" items="${certificates}">
                            <div class="col-md-6 col-xl-4">
                                <div class="cert-card">
                                    <div class="d-flex justify-content-between align-items-start mb-4">
                                        <div class="cert-icon">
                                            <i class="fa-solid fa-certificate"></i>
                                        </div>
                                        <span class="badge bg-success bg-opacity-10 text-emerald border border-success border-opacity-20 px-3 py-2 rounded-pill small">
                                            <i class="fa-solid fa-check-double me-1"></i> VERIFIED
                                        </span>
                                    </div>
                                    
                                    <div class="flex-grow-1">
                                        <div class="text-dim small fw-800 text-uppercase mb-2" style="letter-spacing: 1.5px;">Official Document</div>
                                        <h5 class="text-white fw-900 mb-4" style="line-height: 1.4;">${cert.course.title}</h5>
                                        
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <i class="fa-regular fa-calendar-check text-gold"></i>
                                            <span class="text-dim small">Completion: <b class="text-white">${cert.issueDate != null ? cert.issueDate : 'Recently'}</b></span>
                                        </div>
                                        <div class="d-flex align-items-center gap-2 mb-4">
                                            <i class="fa-solid fa-fingerprint text-gold"></i>
                                            <span class="text-dim small">Credential ID: <b class="text-white text-uppercase">${cert.certificateNumber}</b></span>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2 mt-4 pt-4 border-top border-white-50 border-opacity-10">
                                        <%-- ✅ SMART REDIRECT: Seedhe Verification Page par bhejo download ke liye --%>
                                        <a href="${pageContext.request.contextPath}/certificate/verify/${cert.certificateNumber}" class="btn-download-premium">
                                            <i class="fa-solid fa-file-arrow-down"></i> Get PDF Certificate
                                        </a>
                                        <a href="${pageContext.request.contextPath}/student/course-detail/${cert.course.id}" class="btn-view-only">
                                            <i class="fa-solid fa-circle-info me-2"></i> Course Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 glass-card shadow-lg">
                        <i class="fa-solid fa-award text-dim opacity-20 display-1 mb-4"></i>
                        <h3 class="text-white fw-900">No Certificates Earned Yet</h3>
                        <p class="text-dim mx-auto mb-4" style="max-width: 400px;">Complete your enrolled courses to 100% and pass the final assessments to unlock your verified credentials.</p>
                        <a href="${pageContext.request.contextPath}/student/my-courses" class="btn btn-primary rounded-pill px-5 fw-800">Explore My Library</a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>