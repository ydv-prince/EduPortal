<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reviews | E-Learn Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #070b14;
            --surface: #111827;
            --primary: #6366f1;
            --emerald: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --border: rgba(255, 255, 255, 0.08);
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
        }

        body { background-color: var(--bg-dark); color: var(--text-main); font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        
        .portal-nav { background: rgba(7, 11, 20, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid var(--border); }
        .nav-item-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 5px; font-weight: 500;}
        .nav-item-link:hover, .nav-item-link.active { background: rgba(99, 102, 241, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: var(--danger); margin-top: 25px; }

        .content-card { background: var(--surface); border-radius: 24px; padding: 30px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.2); }

        .custom-table { color: white; border-collapse: separate; border-spacing: 0 10px; margin-bottom: 0;}
        .custom-table thead th { border: none; color: var(--text-dim); font-size: 0.75rem; text-transform: uppercase; padding: 0 15px 15px; letter-spacing: 1px;}
        .custom-table tbody tr { background: white !important; transition: 0.3s; color: #1e293b; } /* UI ko clean karne ke liye Row background white kiya */
        .custom-table td { border: none; padding: 15px; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
        
        .star-rating i { color: var(--warning); font-size: 0.85rem; }
        .star-rating i.empty { color: #cbd5e1; }
        
        /* ✅ Contrast ke liye Name Indigo kiya */
        .student-name { 
            color: #4f46e5 !important; 
            font-weight: 800 !important; 
            font-size: 1rem;
            display: block;
            margin-bottom: 2px;
        }
        .student-email {
            color: #64748b;
            font-size: 0.8rem;
            font-weight: 500;
        }
        .review-quote { 
            font-size: 0.85rem; 
            color: #334155; 
            font-style: italic; 
            border-left: 3px solid var(--primary); 
            padding-left: 12px; 
            margin: 0; 
            line-height: 1.4; 
        }
        .student-badge { background: rgba(99, 102, 241, 0.1); color: var(--primary); padding: 4px 10px; border-radius: 8px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase;}
        
        .action-btn { height: 35px; width: 35px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center; transition: 0.3s; border: none; font-size: 0.85rem; background: rgba(239, 68, 68, 0.1); color: var(--danger); }
        .action-btn:hover { background: var(--danger); color: white; }
    </style>
</head>
<body>

<nav class="portal-nav d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center gap-2">
        <div class="bg-primary p-2 rounded-3 text-white"><i class="fa-solid fa-shield-halved"></i></div>
        <h4 class="m-0 fw-bold text-white">E-Learn <span class="text-primary fw-light">Admin</span></h4>
    </div>
</nav>

<div class="container-fluid px-lg-5 px-3 mb-5">
    <div class="row g-4 mt-2">
        
        <%-- SIDEBAR --%>
        <div class="col-lg-3">
            <div class="sidebar shadow-sm">
                <div class="portal-label mb-3" style="font-size:0.65rem; color:var(--text-dim); font-weight:800;">MASTER CONTROL</div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item-link"><i class="fa-solid fa-chart-pie w-20px text-center"></i> Overview</a>
                <a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-item-link"><i class="fa-solid fa-layer-group w-20px text-center"></i> Categories</a>
                <a href="${pageContext.request.contextPath}/admin/manage-courses" class="nav-item-link"><i class="fa-solid fa-video w-20px text-center"></i> All Courses</a>
                <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-item-link"><i class="fa-solid fa-users-gear w-20px text-center"></i> User Management</a>
                <a href="${pageContext.request.contextPath}/admin/manage-payments" class="nav-item-link"><i class="fa-solid fa-money-bill-transfer w-20px text-center"></i> Transactions</a>
                <a href="${pageContext.request.contextPath}/admin/payout-requests" class="nav-item-link"><i class="fa-solid fa-building-columns w-20px text-center"></i> Payout Requests</a>
                <a href="${pageContext.request.contextPath}/admin/support-tickets" class="nav-item-link"><i class="fa-solid fa-headset w-20px text-center"></i> Support Desk</a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item-link"><i class="fa-solid fa-sliders w-20px text-center"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout"><i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="mb-4">
                    <h2 class="fw-bold m-0 text-white">Course Feedback Moderation</h2>
                    <p class="text-dim m-0">Identify students and manage their shared experiences.</p>
                </div>

                <div class="content-card">
                    <div class="table-responsive">
                        <table class="table custom-table">
                            <thead>
                                <tr>
                                    <th style="width: 22%;">Student Info</th>
                                    <th style="width: 20%;">Course</th>
                                    <th style="width: 15%;">Rating</th>
                                    <th style="width: 33%;">Comment</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="review" items="${reviews}">
                                    <tr>
                                        <%-- ✅ FIXED: Classes applied properly now --%>
                                        <td>
                                            <div class="student-name">
                                                <c:out value="${review.user.fullName}" default="Student Name"/>
                                            </div>
                                            <div class="student-email mb-1">
                                                ${review.user.email}
                                            </div>
                                            <span class="student-badge">Learner</span>
                                        </td>
                                        
                                        <td>
                                            <div class="fw-bold text-dark text-truncate" style="max-width: 150px;">${review.course.title}</div>
                                            <div class="text-muted x-small" style="font-size: 0.7rem;">
                                                On: ${review.createdAt.toLocalDate()}
                                            </div>
                                        </td>
                                        
                                        <td>
                                            <div class="star-rating">
                                                <c:forEach begin="1" end="${review.rating}">
                                                    <i class="fa-solid fa-star"></i>
                                                </c:forEach>
                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                    <i class="fa-solid fa-star empty"></i>
                                                </c:forEach>
                                            </div>
                                        </td>

                                        <td>
                                            <p class="review-quote">
                                                "${review.comment}"
                                            </p>
                                        </td>

                                        <td class="text-end">
                                            <form action="${pageContext.request.contextPath}/admin/manage-reviews/${review.id}/delete" method="post" class="m-0" onsubmit="return confirm('Delete this feedback?')">
                                                <button type="submit" class="action-btn" title="Delete">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>