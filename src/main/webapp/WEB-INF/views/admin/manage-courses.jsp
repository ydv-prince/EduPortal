<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Courses | E-Learn Admin</title>
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

        .filter-tabs { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 1px solid var(--border); padding-bottom: 15px; }
        .filter-tab { color: var(--text-dim); text-decoration: none; font-weight: 600; padding: 8px 20px; border-radius: 20px; transition: 0.3s; font-size: 0.9rem;}
        .filter-tab:hover { color: white; background: rgba(255,255,255,0.05); }
        .filter-tab.active { background: var(--primary); color: white; }

        /* --- UI Fix: Table Rows --- */
        .custom-table { border-collapse: separate; border-spacing: 0 10px; margin-bottom: 0;}
        .custom-table thead th { border: none; color: var(--text-dim); font-size: 0.75rem; text-transform: uppercase; padding: 0 15px 15px; }
        
        /* Fixed: Keeping your white row design but ensuring internal text is dark enough to read */
        .custom-table tbody tr { background: white !important; transition: 0.3s; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .custom-table td { border: none; padding: 15px; vertical-align: middle; color: #1e293b; }
        .custom-table td:first-child { border-radius: 12px 0 0 12px; }
        .custom-table td:last-child { border-radius: 0 12px 12px 0; }

        .course-title { color: #0f172a !important; font-weight: 800; font-size: 0.95rem; line-height: 1.2; }
        .instructor-name { color: #4338ca !important; font-weight: 700; font-size: 0.85rem; }
        .instructor-email { color: #64748b; font-size: 0.75rem; }

        .course-thumb { width: 60px; height: 45px; border-radius: 8px; object-fit: cover; background: #f1f5f9; border: 1px solid #e2e8f0; }
        .thumb-placeholder { width: 60px; height: 45px; border-radius: 8px; background: #e0e7ff; color: #4f46e5; display: flex; align-items: center; justify-content: center; }

        .action-btn { height: 35px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center; transition: 0.3s; border: none; font-size: 0.85rem; font-weight: 700; padding: 0 15px; gap: 8px;}
        .action-btn.approve { background: #ecfdf5; color: #059669; }
        .action-btn.approve:hover { background: #059669; color: white; }
        .action-btn.delete { background: #fef2f2; color: #dc2626; width: 35px; padding: 0;}
        .action-btn.delete:hover { background: #dc2626; color: white; }
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
        
        <div class="col-lg-3">
            <div class="sidebar shadow-sm">
                <div class="portal-label mb-3" style="font-size:0.65rem; color:var(--text-dim); font-weight:800;">MASTER CONTROL</div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item-link active"><i class="fa-solid fa-chart-pie w-20px text-center"></i> Overview</a>
                <a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-item-link"><i class="fa-solid fa-layer-group w-20px text-center"></i> Categories</a>
                <a href="${pageContext.request.contextPath}/admin/manage-courses" class="nav-item-link"><i class="fa-solid fa-video w-20px text-center"></i> All Courses</a>
                <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-item-link"><i class="fa-solid fa-users-gear w-20px text-center"></i> User Management</a>
                <a href="${pageContext.request.contextPath}/admin/manage-payments" class="nav-item-link"><i class="fa-solid fa-money-bill-transfer w-20px text-center"></i> Transactions</a>
                <a href="${pageContext.request.contextPath}/admin/payout-requests" class="nav-item-link"><i class="fa-solid fa-building-columns w-20px text-center"></i> Payout Requests</a>
                <a href="${pageContext.request.contextPath}/admin/support-tickets" class="nav-item-link"><i class="fa-solid fa-headset w-20px text-center"></i> Support Desk</a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item-link"><i class="fa-solid fa-sliders w-20px text-center"></i> Settings</a>
            
                <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="nav-item-link logout border-0 bg-transparent w-100 text-start">
                        <i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout
                    </button>
                </form>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="mb-4">
                    <h2 class="fw-bold m-0 text-white">Course Repository</h2>
                    <p class="text-dim m-0">Review, approve, or manage platform content.</p>
                </div>

                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success border-0 rounded-4 shadow-sm mb-4 bg-success bg-opacity-10 text-success">
                        <i class="fa-solid fa-circle-check me-2"></i> ${successMsg}
                    </div>
                </c:if>

                <div class="content-card">
                    <div class="filter-tabs">
                        <a href="${pageContext.request.contextPath}/admin/manage-courses" 
                           class="filter-tab ${empty filter ? 'active' : ''}">All Courses</a>
                        
                        
                        
                        <a href="${pageContext.request.contextPath}/admin/manage-courses?filter=pending" 
                           class="filter-tab ${filter == 'pending' ? 'active' : ''}">Pending Approval</a>
                    </div>

                    <div class="table-responsive">
                        <table class="table custom-table">
                            <thead>
                                <tr>
                                    <th>Course Details</th>
                                    <th>Instructor</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="course" items="${courses}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <c:choose>
                                                    <c:when test="${not empty course.thumbnailUrl}">
                                                        <img src="${pageContext.request.contextPath}${course.thumbnailUrl}" class="course-thumb">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="thumb-placeholder"><i class="fa-solid fa-video"></i></div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <div class="course-title text-truncate" style="max-width: 200px;">${course.title}</div>
                                                    <span class="badge bg-light text-secondary border mt-1" style="font-size: 0.65rem;">${course.category.name}</span>
                                                </div>
                                            </div>
                                        </td>
                                        
                                        <td>
                                            <div class="instructor-name">${course.instructor.fullName}</div>
                                            <div class="instructor-email">${course.instructor.email}</div>
                                        </td>
                                        
                                        <td>
                                            <div class="fw-bold" style="color: #059669;">
                                                <c:choose>
                                                    <c:when test="${course.price > 0}">₹${course.price}</c:when>
                                                    <c:otherwise><span class="text-primary">FREE</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${course.approved && course.published}">
                                                    <span class="badge bg-success bg-opacity-10 text-success px-2 py-1 border border-success border-opacity-25">LIVE</span>
                                                </c:when>
                                                <c:when test="${not course.approved}">
                                                    <span class="badge bg-warning bg-opacity-10 text-warning px-2 py-1 border border-warning border-opacity-25">NEEDS APPROVAL</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info bg-opacity-10 text-info px-2 py-1 border border-info border-opacity-25">DRAFT</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-end">
                                            <div class="d-flex gap-2 justify-content-end align-items-center">
                                                <c:if test="${not course.approved}">
                                                    <form action="${pageContext.request.contextPath}/admin/courses/${course.id}/approve" method="post" class="m-0">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <button type="submit" class="action-btn approve">Approve</button>
                                                    </form>
                                                </c:if>
                                                
                                                <form action="${pageContext.request.contextPath}/admin/courses/delete/${course.id}" method="post" class="m-0" onsubmit="return confirm('Permanent delete this course?')">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="action-btn delete">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty courses}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5">
                                            <div class="text-muted small">No courses found matching this criteria.</div>
                                        </td>
                                    </tr>
                                </c:if>
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