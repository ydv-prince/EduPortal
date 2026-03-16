<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SuperAdmin Dashboard | E-Learn Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --bg-dark: #070b14; 
            --surface: #111827;
            --primary: #6366f1; 
            --emerald: #10b981;
            --border: rgba(255, 255, 255, 0.08);
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
        }

        body { background-color: var(--bg-dark); color: var(--text-main); font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        .portal-nav { background: rgba(7, 11, 20, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid rgba(255,255,255,0.05); }
        .nav-item-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 5px; font-weight: 500;}
        .nav-item-link:hover, .nav-item-link.active { background: rgba(99, 102, 241, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: #ef4444; margin-top: 25px; }
        .main-content { padding: 0; }

        .stat-card { 
            background: white !important; 
            border-radius: 20px; 
            padding: 24px; 
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            transition: 0.3s;
            border: none;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-icon-wrapper { width: 50px; height: 50px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 15px; }
        .stat-value { font-size: 1.8rem; font-weight: 800; margin-bottom: 2px; color: #0f172a !important; }
        .stat-label { font-size: 0.8rem; color: #64748b !important; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; }

        .dashboard-panel { background: white !important; border-radius: 24px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.15); height: 100%; }
        .panel-title { font-size: 1rem; font-weight: 800; margin-bottom: 20px; color: #0f172a; display: flex; align-items: center; justify-content: space-between;}
        
        .activity-item { display: flex; align-items: center; gap: 12px; padding: 12px 0; border-bottom: 1px solid #f1f5f9; }
        .activity-item:last-child { border-bottom: none; }
        .activity-text { color: #1e293b; font-size: 0.85rem; font-weight: 600; }
        .activity-subtext { color: #64748b; font-size: 0.75rem; }
    </style>
</head>
<body>

<nav class="portal-nav d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center gap-2">
        <div class="bg-primary p-2 rounded-3 text-white"><i class="fa-solid fa-shield-halved"></i></div>
        <h4 class="m-0 fw-bold text-white">E-Learn <span class="text-primary fw-light">Admin</span></h4>
    </div>
    
    <div class="d-flex align-items-center gap-4">
        <%-- ✅ Profile Link - Anchor tag is now correctly wrapping the div --%>
        <a href="${pageContext.request.contextPath}/admin/profile" class="text-decoration-none">
            <div class="bg-light rounded-circle text-primary fw-bold d-flex align-items-center justify-content-center shadow" 
                 style="width:38px; height:38px; cursor: pointer; transition: 0.3s;"
                 onmouseover="this.style.transform='scale(1.1)'" 
                 onmouseout="this.style.transform='scale(1)'">
                 <c:choose>
                     <c:when test="${not empty admin.fullName}">
                         <c:out value="${admin.fullName.substring(0,1).toUpperCase()}" />
                     </c:when>
                     <c:otherwise>A</c:otherwise>
                 </c:choose>
            </div>
        </a>
    </div>
</nav>

<div class="container-fluid px-lg-5 px-3 mb-5">
    <div class="row g-4 mt-2">
        
        <%-- SIDEBAR --%>
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
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout"><i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="mb-4">
                    <h2 class="fw-bold m-0 text-white">Platform Overview</h2>
                    <p class="text-dim m-0">Welcome back, <b class="text-white"><c:out value="${admin.fullName}" default="Super Admin" /></b>.</p>
                </div>

                <%-- Stats Row --%>
                <div class="row g-4 mb-4">
                    <div class="col-md-3 col-sm-6">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper" style="background:#eef2ff; color:#4f46e5;"><i class="fa-solid fa-users"></i></div>
                            <div class="stat-value"><c:out value="${totalUsers}" default="0"/></div>
                            <div class="stat-label">Total Users</div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper" style="background:#fff7ed; color:#d97706;"><i class="fa-solid fa-play"></i></div>
                            <div class="stat-value"><c:out value="${totalCourses}" default="0"/></div>
                            <div class="stat-label">Courses</div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper" style="background:#ecfdf5; color:#059669;"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                            <div class="stat-value">₹<c:out value="${platformRevenue}" default="0"/></div>
                            <div class="stat-label">Revenue</div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper" style="background:#fef2f2; color:#dc2626;"><i class="fa-solid fa-clock"></i></div>
                            <div class="stat-value"><c:out value="${pendingPayouts}" default="0"/></div>
                            <div class="stat-label">Pending Payouts</div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <%-- Chart --%>
                    <div class="col-lg-7">
                        <div class="dashboard-panel">
                            <div class="panel-title">Revenue Growth</div>
                            <div style="height: 300px;">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <%-- Activity --%>
                    <div class="col-lg-5">
                        <div class="dashboard-panel">
                            <div class="panel-title">Recent Activity</div>
                            <div class="activity-list">
                                <c:forEach var="user" items="${recentUsers}">
                                    <div class="activity-item">
                                        <div class="activity-icon bg-light text-primary"><i class="fa-solid fa-user-plus"></i></div>
                                        <div>
                                            <div class="activity-text"><c:out value="${user.fullName}"/></div>
                                            <div class="activity-subtext">Joined as <c:out value="${user.role}"/></div>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty recentUsers}">
                                    <div class="text-center py-5 text-muted small">No recent registrations.</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: 'Revenue (₹)',
                data: [4000, 9000, 7000, 15000, 12000, 22000],
                borderColor: '#6366f1',
                tension: 0.4,
                fill: true,
                backgroundColor: 'rgba(99, 102, 241, 0.05)'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { ticks: { color: '#64748b' }, grid: { color: '#f1f5f9' } },
                x: { ticks: { color: '#64748b' }, grid: { display: false } }
            }
        }
    });
</script>
</body>
</html>