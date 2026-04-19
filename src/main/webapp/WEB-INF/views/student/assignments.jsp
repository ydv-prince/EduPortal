<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Assignments"/>
<%@ include file="../common/header.jsp" %>

<style>
    :root {
        --bg-dark: #020617;
        --surface: rgba(15, 23, 42, 0.6);
        --primary: #6366f1;
        --accent: #a855f7;
        --emerald: #10b981;
        --warning: #f59e0b;
        --danger: #ef4444;
        --text-dim: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.08);
    }

    body { background-color: var(--bg-dark); color: #f8fafc; overflow-x: hidden; }

    /* ── Ambient Background Glow ── */
    .task-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 80% 20%, rgba(168, 85, 247, 0.04) 0%, transparent 50%),
                    radial-gradient(circle at 20% 80%, rgba(99, 102, 241, 0.04) 0%, transparent 50%);
        z-index: -1; pointer-events: none;
    }

    /* ── Glass Components ── */
    .glass-card { 
        background: var(--surface); backdrop-filter: blur(12px); 
        border: 1px solid var(--glass-border); border-radius: 20px; 
    }

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

    /* ── Assignment Card ── */
    .task-card {
        background: rgba(255, 255, 255, 0.02);
        border: 1px solid var(--glass-border);
        border-radius: 16px; padding: 20px;
        transition: 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        position: relative; overflow: hidden;
    }
    .task-card:hover {
        transform: translateX(8px);
        border-color: rgba(99, 102, 241, 0.4);
        background: rgba(255, 255, 255, 0.04);
        box-shadow: -10px 10px 30px rgba(0,0,0,0.3);
    }
    
    .task-icon {
        width: 50px; height: 50px; border-radius: 12px;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.4rem; flex-shrink: 0;
    }
    .icon-pending { background: rgba(99, 102, 241, 0.15); color: #818cf8; border: 1px solid rgba(99, 102, 241, 0.3); }
    .icon-submitted { background: rgba(16, 185, 129, 0.15); color: #34d399; border: 1px solid rgba(16, 185, 129, 0.3); }

    .btn-submit-task {
        background: var(--primary); color: white; border: none;
        padding: 10px 20px; border-radius: 10px; font-weight: 800; font-size: 0.85rem;
        transition: 0.3s; box-shadow: 0 5px 15px rgba(99, 102, 241, 0.3);
    }
    .btn-submit-task:hover { transform: scale(1.05); background: #4f46e5; color: white; }

    /* ── Modal Styling ── */
    .modal-content { background: #0f172a; border: 1px solid rgba(255,255,255,0.1); border-radius: 24px; box-shadow: 0 25px 50px rgba(0,0,0,0.6); }
    .modal-header { border-bottom: 1px solid rgba(255,255,255,0.05); border-radius: 24px 24px 0 0; }
    .modal-footer { border-top: 1px solid rgba(255,255,255,0.05); }
    .form-control-dark {
        background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1);
        border-radius: 12px; padding: 15px; color: white; transition: 0.3s;
    }
    .form-control-dark:focus { border-color: var(--primary); outline: none; background: rgba(0,0,0,0.4); box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1); }

    /* ── Animation ── */
    @keyframes fadeInUp { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
    .animate-fade { animation: fadeInUp 0.5s ease-out forwards; opacity: 0; }
    .delay-1 { animation-delay: 0.1s; }
    .delay-2 { animation-delay: 0.2s; }
</style>

<div class="task-glow"></div>

<div class="container-fluid px-lg-5 py-4">
    <div class="row g-4">
        
        <%-- Fixed Sidebar Layout --%>
        <div class="col-lg-3 d-none d-lg-block">
            <%@ include file="../common/sidebar.jsp" %>
        </div>

        <div class="col-lg-9">
            
            <%-- Header --%>
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3 animate-fade">
                <div>
                    <h1 class="display-6 fw-900 text-white mb-1"><i class="fa-solid fa-list-check text-accent me-2"></i> Task Center</h1>
                    <p class="text-dim fs-6 m-0">Manage and submit your course assignments.</p>
                </div>
            </div>

            <%-- Flash Messages --%>
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success border-success border-opacity-25 bg-success bg-opacity-10 text-emerald rounded-4 fw-600 small mb-4 animate-fade delay-1 d-flex align-items-center">
                    <i class="fa-solid fa-circle-check fs-5 me-3"></i> ${successMsg}
                </div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger border-danger border-opacity-25 bg-danger bg-opacity-10 text-danger rounded-4 fw-600 small mb-4 animate-fade delay-1 d-flex align-items-center">
                    <i class="fa-solid fa-triangle-exclamation fs-5 me-3"></i> ${errorMsg}
                </div>
            </c:if>

            <%-- Filters --%>
            <div class="d-flex gap-2 mb-4 animate-fade delay-1 overflow-auto pb-2">
                <button onclick="filterTasks('all')" id="tab-all" class="filter-tab active-tab flex-shrink-0">All Tasks</button>
                <button onclick="filterTasks('pending')" id="tab-pending" class="filter-tab flex-shrink-0">Pending</button>
                <button onclick="filterTasks('submitted')" id="tab-submitted" class="filter-tab flex-shrink-0">Submitted / Graded</button>
            </div>

            <%-- Assignments List --%>
            <div class="glass-card p-4 animate-fade delay-2">
                <c:choose>
                    <c:when test="${not empty assignments}">
                        <div class="d-flex flex-column gap-3" id="taskContainer">
                            <c:forEach var="task" items="${assignments}">
                                
                                <%-- Logic to check if submitted (assuming task.submission exists or task.status == 'SUBMITTED') --%>
                                <c:set var="isSubmitted" value="${task.submission != null}" />

                                <div class="task-card task-item ${isSubmitted ? 'submitted-item' : 'pending-item'}">
                                    <div class="row align-items-center">
                                        
                                        <div class="col-md-5 mb-3 mb-md-0 d-flex align-items-center gap-3">
                                            <div class="task-icon ${isSubmitted ? 'icon-submitted' : 'icon-pending'}">
                                                <i class="fa-solid ${isSubmitted ? 'fa-file-circle-check' : 'fa-file-pen'}"></i>
                                            </div>
                                            <div>
                                                <%-- FIX: Changed task.course.title to task.module.course.title --%>
                                                <div class="text-dim x-small fw-800 text-uppercase mb-1" style="letter-spacing: 1px;">
                                                    ${task.module != null && task.module.course != null ? task.module.course.title : 'Course'}
                                                </div>
                                                <h6 class="text-white fw-800 m-0 fs-5">${task.title}</h6>
                                            </div>
                                        </div>

                                        <div class="col-md-4 mb-3 mb-md-0">
                                            <c:choose>
                                                <c:when test="${isSubmitted}">
                                                    <span class="badge bg-success bg-opacity-20 text-emerald border border-success border-opacity-25 rounded-pill px-3 py-2 mb-1" style="font-size: 0.65rem; letter-spacing: 1px;">SUBMITTED</span>
                                                    <c:if test="${not empty task.submission.score}">
                                                        <%-- FIX: Changed totalMarks to maxMarks --%>
                                                        <div class="text-dim small mt-1 fw-700">Score: <span class="text-white">${task.submission.score} / ${task.maxMarks}</span></div>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning bg-opacity-20 text-warning border border-warning border-opacity-25 rounded-pill px-3 py-2 mb-1" style="font-size: 0.65rem; letter-spacing: 1px;">PENDING</span>
                                                    <div class="text-dim small mt-1 fw-600"><i class="fa-regular fa-clock me-1"></i> Due: <fmt:formatDate value="${task.dueDate}" pattern="MMM dd, yyyy"/></div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="col-md-3 text-md-end">
                                            <c:choose>
                                                <c:when test="${isSubmitted}">
                                                    <button class="btn btn-outline-light btn-sm rounded-pill fw-700" onclick="viewFeedback('${task.submission.feedback}')">
                                                        <i class="fa-solid fa-comment-dots me-1"></i> Feedback
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-submit-task" onclick="openSubmitModal('${task.id}', '${task.title}')">
                                                        Submit Work <i class="fa-solid fa-arrow-up-from-bracket ms-1"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- Empty State --%>
                        <div class="text-center py-5">
                            <div class="opacity-20 mb-4 mt-3"><i class="fa-solid fa-clipboard-check fa-4x text-emerald"></i></div>
                            <h4 class="text-white fw-800">You're all caught up!</h4>
                            <p class="text-dim mb-0">No pending assignments at the moment. Great job!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</div>

<%-- ── Modal for Assignment Submission ── --%>
<div class="modal fade" id="submitTaskModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header border-0 pb-0 pt-4 px-4">
                <div>
                    <h4 class="modal-title text-white fw-900" id="modalTaskTitle">Submit Assignment</h4>
                    <p class="text-dim small m-0">Paste your code, essay, or link below.</p>
                </div>
                <button type="button" class="btn-close btn-close-white opacity-50" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <form action="${pageContext.request.contextPath}/student/assignment/submit" method="post">
                <div class="modal-body p-4">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="assignmentId" id="modalAssignmentId" value=""/>
                    
                    <label class="text-dim small fw-800 text-uppercase mb-2" style="letter-spacing: 1px;">Your Submission</label>
                    <textarea name="submissionText" class="form-control-dark w-100" rows="8" placeholder="Type your answer here, or paste a link to your Google Doc / GitHub repository..." required></textarea>
                </div>
                <div class="modal-footer border-0 pt-0 pb-4 px-4">
                    <button type="button" class="btn btn-dark rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow-lg">Submit Assignment</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Tab Filtering Logic
    function filterTasks(type) {
        document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active-tab'));
        document.getElementById('tab-' + type).classList.add('active-tab');

        const items = document.querySelectorAll('.task-item');
        items.forEach(item => {
            item.style.display = 'none'; // reset
            if (type === 'all') {
                item.style.display = 'block';
            } else if (type === 'pending' && item.classList.contains('pending-item')) {
                item.style.display = 'block';
            } else if (type === 'submitted' && item.classList.contains('submitted-item')) {
                item.style.display = 'block';
            }
        });
    }

    // Open Modal Logic
    function openSubmitModal(id, title) {
        document.getElementById('modalAssignmentId').value = id;
        document.getElementById('modalTaskTitle').innerText = "Submit: " + title;
        var myModal = new bootstrap.Modal(document.getElementById('submitTaskModal'));
        myModal.show();
    }

    // Simple Feedback Alert
    function viewFeedback(feedbackText) {
        alert(feedbackText && feedbackText !== 'null' && feedbackText.trim() !== '' ? "Instructor Feedback:\n\n" + feedbackText : "No feedback provided yet. Your instructor is still reviewing this.");
    }
</script>

<%@ include file="../common/footer.jsp" %>