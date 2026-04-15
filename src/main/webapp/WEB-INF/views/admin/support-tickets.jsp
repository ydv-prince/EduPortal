<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support Desk | E-Learn Admin</title>
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

        /* --- UI FIX: Dark Text on White Background --- */
        .custom-table { border-collapse: separate; border-spacing: 0 10px; margin-bottom: 0;}
        .custom-table thead th { border: none; color: var(--text-dim); font-size: 0.75rem; text-transform: uppercase; padding: 0 15px 15px; }
        
        .custom-table tbody tr { background: white !important; transition: 0.3s; border-radius: 12px; }
        .custom-table td { border: none; padding: 15px; vertical-align: middle; color: #1e293b; }
        .custom-table td:first-child { border-radius: 12px 0 0 12px; }
        .custom-table td:last-child { border-radius: 0 12px 12px 0; }

        .ticket-id { font-family: monospace; font-size: 0.75rem; color: #4338ca; background: #e0e7ff; padding: 4px 8px; border-radius: 6px; font-weight: 700;}
        .reporter-name { color: #4f46e5 !important; font-weight: 800; font-size: 0.95rem; }
        .ticket-subject { color: #1e293b; font-weight: 700; font-size: 0.9rem; }
        
        .action-btn { height: 35px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center; transition: 0.3s; border: none; font-size: 0.85rem; font-weight: 700; padding: 0 15px; gap: 8px;}
        .action-btn.resolve { background: #ecfdf5; color: #059669; }
        .action-btn.resolve:hover { background: #059669; color: white; }
        .action-btn.view { background: #f1f5f9; color: #475569; }
        .action-btn.view:hover { background: #e2e8f0; }
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
                <a href="${pageContext.request.contextPath}/admin/payout-requests" class="nav-item-link"><i class="fa-solid fa-building-columns w-20px text-center"></i> Payout Requests</a>
                <a href="${pageContext.request.contextPath}/admin/support-tickets" class="nav-item-link active"><i class="fa-solid fa-headset w-20px text-center"></i> Support Desk</a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item-link"><i class="fa-solid fa-sliders w-20px text-center"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout"><i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="mb-4">
                    <h2 class="fw-bold m-0 text-white">Support Desk</h2>
                    <p class="text-dim m-0">Handle user inquiries and technical issues.</p>
                </div>

                <div class="content-card">
                    <div class="filter-tabs">
                        <a href="${pageContext.request.contextPath}/admin/support-tickets" class="filter-tab ${empty param.status ? 'active' : ''}">All</a>
                        <a href="${pageContext.request.contextPath}/admin/support-tickets?status=OPEN" class="filter-tab ${param.status == 'OPEN' ? 'active' : ''}">Open</a>
                        <a href="${pageContext.request.contextPath}/admin/support-tickets?status=RESOLVED" class="filter-tab ${param.status == 'RESOLVED' ? 'active' : ''}">Resolved</a>
                    </div>

                    <div class="table-responsive">
                        <table class="table custom-table">
                            <thead>
                                <tr>
                                    <th>Ticket Info</th>
                                    <th>Reported By</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ticket" items="${tickets}">
                                    <tr>
                                        <td>
                                            <span class="ticket-id">#${ticket.id}</span>
                                            <div class="ticket-subject mt-1 text-truncate" style="max-width: 200px;">${ticket.subject}</div>
                                        </td>
                                        
                                        <td>
                                            <div class="reporter-name">${ticket.user.fullName}</div>
                                            <div class="small text-muted">${ticket.user.email}</div>
                                        </td>
                                        
                                        <td class="small fw-medium text-muted">
                                            ${ticket.createdAt.toLocalDate()}
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${ticket.status == 'OPEN'}">
                                                    <span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 px-2 py-1">OPEN</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">RESOLVED</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-end">
                                            <div class="d-flex gap-2 justify-content-end">
                                                <button class="action-btn view" onclick="alert('Message: ${ticket.message}')">View</button>
                                                <c:if test="${ticket.status == 'OPEN'}">
                                                    <form action="${pageContext.request.contextPath}/admin/support-tickets/${ticket.id}/resolve" method="post" class="m-0">
                                                        <button type="submit" class="action-btn resolve">Resolve</button>
                                                    </form>
                                                </c:if>
                                            </div>
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