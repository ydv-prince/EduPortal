<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quiz: ${assignment.title}"/>
<%@ include file="../common/header.jsp" %>

<div class="container py-5">
    <div class="glass-card p-5 shadow-lg border-primary border-opacity-25" style="background: rgba(15, 23, 42, 0.8); border-radius: 24px;">
        <div class="text-center mb-5">
            <span class="badge bg-primary px-3 py-2 rounded-pill mb-3">KNOWLEDGE ASSESSMENT</span>
            <h1 class="text-white fw-900">${assignment.title}</h1>
            <p class="text-dim">${assignment.description}</p>
        </div>

        <form action="${pageContext.request.contextPath}/student/quiz/submit" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="assignmentId" value="${assignment.id}"/>

            <c:forEach var="q" items="${questions}" varStatus="status">
                <div class="mb-5 p-4 rounded-4" style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.05);">
                    <h5 class="text-white mb-4">
                        <span class="text-primary me-2">Q${status.index + 1}.</span> ${q.questionText}
                    </h5>
                    
                    <div class="d-flex flex-column gap-3">
                        <label class="d-flex align-items-center gap-3 p-3 rounded-3 cursor-pointer hover-bg-primary" style="background: rgba(0,0,0,0.2);">
                            <input type="radio" name="q_${q.id}" value="A" required> <span class="text-white-50">${q.optionA}</span>
                        </label>
                        <label class="d-flex align-items-center gap-3 p-3 rounded-3 cursor-pointer" style="background: rgba(0,0,0,0.2);">
                            <input type="radio" name="q_${q.id}" value="B"> <span class="text-white-50">${q.optionB}</span>
                        </label>
                        <label class="d-flex align-items-center gap-3 p-3 rounded-3 cursor-pointer" style="background: rgba(0,0,0,0.2);">
                            <input type="radio" name="q_${q.id}" value="C"> <span class="text-white-50">${q.optionC}</span>
                        </label>
                        <label class="d-flex align-items-center gap-3 p-3 rounded-3 cursor-pointer" style="background: rgba(0,0,0,0.2);">
                            <input type="radio" name="q_${q.id}" value="D"> <span class="text-white-50">${q.optionD}</span>
                        </label>
                    </div>
                </div>
            </c:forEach>

            <div class="text-center mt-5">
                <button type="submit" class="btn btn-primary px-5 py-3 rounded-pill fw-bold shadow-lg">
                    SUBMIT ANSWERS <i class="fa-solid fa-paper-plane ms-2"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>x