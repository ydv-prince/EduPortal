<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payout Requests | E-Learn Admin</title>
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
            --text-dim: #94a3b8;
        }

        body { background-color: var(--bg-dark); color: white; font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        
        .portal-nav { background: rgba(7, 11, 20, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid var(--border); }
        .nav-item-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 5px; font-weight: 500;}
        .nav-item-link:hover, .nav-item-link.active { background: rgba(99, 102, 241, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: var(--danger); margin-top: 25px; }

        .content-card { background: var(--surface); border-radius: 24px; padding: 30px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.2); }

        /* --- UI FIX: White Rows with Dark Text --- */
        .custom-table { border-collapse: separate; border-spacing: 0 10px; margin-bottom: 0;}
        .custom-table thead th { border: none; color: var(--text-dim); font-size: 0.75rem; text-transform: uppercase; padding: 0 15px 15px; }
        
        .custom-table tbody tr { background: white !important; transition: 0.3s; border-radius: 12px; }
        .custom-table td { border: none; padding: 15px; vertical-align: middle; color: #1e293b; }
        .custom-table td:first-child { border-radius: 12px 0 0 12px; }
        .custom-table td:last-child { border-radius: 0 12px 12px 0; }

        .req-id { font-family: monospace; font-size: 0.8rem; color: #d97706; background: #fffbeb; padding: 4px 8px; border-radius: 6px; font-weight: 700; border: 1px solid #fef3c7;}
        .teacher-name { color: #4f46e5 !important; font-weight: 800; font-size: 0.95rem; }
        .teacher-email { color: #64748b; font-size: 0.8rem; }
        .amount-text { font-weight: 800; font-size: 1.1rem; color: #1e293b; }
        
        .action-btn { height: 35px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center; transition: 0.3s; border: none; font-size: 0.85rem; font-weight: 700; padding: 0 15px; gap: 8px;}
        .action-btn.approve { background: #ecfdf5; color: #059669; }
        .action-btn.approve:hover { background: #059669; color: white; }
        .action-btn.reject { background: #fef2f2; color: #dc2626; }
        .action-btn.reject:hover { background: #dc2626; color: white; }
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
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item-link"><i class="fa-solid fa-chart-pie w-20px text-center"></i> Overview</a>
                <a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-item-link"><i class="fa-solid fa-layer-group w-20px text-center"></i> Categories</a>
                <a href="${pageContext.request.contextPath}/admin/manage-courses" class="nav-item-link"><i class="fa-solid fa-video w-20px text-center"></i> All Courses</a>
                <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-item-link"><i class="fa-solid fa-users-gear w-20px text-center"></i> User Management</a>
                <a href="${pageContext.request.contextPath}/admin/manage-payments" class="nav-item-link"><i class="fa-solid fa-money-bill-transfer w-20px text-center"></i> Transactions</a>
                <a href="${pageContext.request.contextPath}/admin/payout-requests" class="nav-item-link active"><i class="fa-solid fa-building-columns w-20px text-center"></i> Payout Requests</a>
                <a href="${pageContext.request.contextPath}/admin/support-tickets" class="nav-item-link"><i class="fa-solid fa-headset w-20px text-center"></i> Support Desk</a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item-link"><i class="fa-solid fa-sliders w-20px text-center"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout"><i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="mb-4">
                    <h2 class="fw-bold m-0 text-white">Instructor Payouts</h2>
                    <p class="text-dim m-0">Review and process teacher withdrawal requests.</p>
                </div>

                <div class="content-card">
                    <div class="table-responsive">
                        <table class="table custom-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Instructor</th>
                                    <th>Amount</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="req" items="${payoutRequests}">
                                    <tr>
                                        <td><span class="req-id">#${req.id}</span></td>
                                        <td>
    <div class="teacher-name">${req.teacher.fullName}</div>
    <div class="teacher-email">${req.teacher.email}</div>
</td>
                                        <td><div class="amount-text">₹${req.amount}</div></td>
                                        <td>
                                            <%-- FIXED: LocalDateTime handling --%>
                                            <div class="fw-bold small" style="color: #475569;">${req.createdAt.toLocalDate()}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${req.status.name() == 'PENDING'}">
                                                    <span class="badge bg-warning bg-opacity-10 text-warning px-2 py-1">PENDING</span>
                                                </c:when>
                                                <c:when test="${req.status.name() == 'PAID'}">
                                                    <span class="badge bg-success bg-opacity-10 text-success px-2 py-1">PAID</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger bg-opacity-10 text-danger px-2 py-1">REJECTED</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <c:if test="${req.status.name() == 'PENDING'}">
                                                <div class="d-flex gap-2 justify-content-end">
                                                    <form action="${pageContext.request.contextPath}/admin/payouts/${req.id}/approve" method="post" class="m-0">
                                                        <button type="submit" class="action-btn approve">Pay</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/payouts/${req.id}/reject" method="post" class="m-0">
                                                        <button type="submit" class="action-btn reject"><i class="fa-solid fa-xmark"></i></button>
                                                    </form>
                                                </div>
                                            </c:if>
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
