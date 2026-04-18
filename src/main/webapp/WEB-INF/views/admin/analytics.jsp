<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics & Reports | E-Learn Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --bg-dark: #070b14;
            --surface: #111827;
            --primary: #6366f1;
            --border: rgba(255, 255, 255, 0.08);
            --text-dim: #94a3b8;
        }

        body { background-color: var(--bg-dark); color: white; font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        
        .portal-nav { background: rgba(7, 11, 20, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid var(--border); }
        .nav-item-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 5px; font-weight: 500;}
        .nav-item-link:hover, .nav-item-link.active { background: rgba(99, 102, 241, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: var(--danger); margin-top: 25px; }

        /* --- STAT BOXES FIX --- */
        .stat-box { 
            background: white !important; 
            border-radius: 20px; 
            padding: 25px; 
            text-align: left; 
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        .stat-icon-circle {
            width: 50px; height: 50px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem; margin-bottom: 15px;
        }
        /* Yahan Text ko explicitly Dark kiya hai */
        .stat-value { font-size: 1.8rem; font-weight: 800; color: #0f172a !important; margin-bottom: 2px;}
        .stat-label { font-size: 0.8rem; color: #64748b !important; text-transform: uppercase; letter-spacing: 1px; font-weight: 700;}

        /* --- CHART CARDS FIX --- */
        .content-card { 
            background: white !important; 
            border-radius: 24px; 
            padding: 25px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.2); 
        }
        /* Title ko dark kiya */
        .card-title { font-size: 1rem; font-weight: 800; color: #0f172a !important; margin-bottom: 25px; }
        .chart-container { position: relative; height: 300px; width: 100%; }
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
                <a href="${pageContext.request.contextPath}/admin/analytics" class="nav-item-link active"><i class="fa-solid fa-chart-line w-20px text-center"></i> Analytics</a>
                <a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-item-link"><i class="fa-solid fa-layer-group w-20px text-center"></i> Categories</a>
                <a href="${pageContext.request.contextPath}/admin/manage-courses" class="nav-item-link"><i class="fa-solid fa-video w-20px text-center"></i> All Courses</a>
                <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-item-link"><i class="fa-solid fa-users-gear w-20px text-center"></i> User Management</a>
                <a href="${pageContext.request.contextPath}/admin/manage-payments" class="nav-item-link"><i class="fa-solid fa-money-bill-transfer w-20px text-center"></i> Transactions</a>
                <a href="${pageContext.request.contextPath}/admin/manage-reviews" class="nav-item-link"><i class="fa-solid fa-star-half-stroke w-20px text-center"></i> Course Reviews</a>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout"><i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="mb-4">
                    <h2 class="fw-bold m-0 text-white">Platform Analytics</h2>
                    <p class="text-dim m-0">Detailed insights and performance metrics.</p>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="stat-box">
                            <div class="stat-icon-circle" style="background: #eef2ff; color: #4f46e5;"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                            <div class="stat-value">₹${totalRevenue != null ? totalRevenue : '0'}</div>
                            <div class="stat-label">Earnings</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box">
                            <div class="stat-icon-circle" style="background: #ecfdf5; color: #059669;"><i class="fa-solid fa-users"></i></div>
                            <div class="stat-value">${totalStudents != null ? totalStudents : '0'}</div>
                            <div class="stat-label">Students</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box">
                            <div class="stat-icon-circle" style="background: #fff7ed; color: #d97706;"><i class="fa-solid fa-chalkboard-user"></i></div>
                            <div class="stat-value">${totalTeachers != null ? totalTeachers : '0'}</div>
                            <div class="stat-label">Instructors</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box">
                            <div class="stat-icon-circle" style="background: #f0f9ff; color: #0284c7;"><i class="fa-solid fa-book"></i></div>
                            <div class="stat-value">${categories.size()}</div>
                            <div class="stat-label">Categories</div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="content-card">
                            <div class="card-title">Revenue Trend</div>
                            <div class="chart-container">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="content-card">
                            <div class="card-title">User Mix</div>
                            <div class="chart-container">
                                <canvas id="userChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // ✅ UI FIX: Chart.js text colors updated to Dark for White background
    const chartOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { labels: { color: '#1e293b', font: { weight: 'bold' } } }
        },
        scales: {
            y: { ticks: { color: '#64748b' }, grid: { color: '#f1f5f9' } },
            x: { ticks: { color: '#64748b' }, grid: { display: false } }
        }
    };

    const ctxRevenue = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctxRevenue, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: 'Revenue',
                data: [5000, 8000, 12000, 10000, 15000, 20000],
                borderColor: '#4f46e5',
                tension: 0.4,
                fill: true,
                backgroundColor: 'rgba(79, 70, 229, 0.05)'
            }]
        },
        options: chartOptions
    });

    const ctxUser = document.getElementById('userChart').getContext('2d');
    new Chart(ctxUser, {
        type: 'doughnut',
        data: {
            labels: ['Students', 'Teachers'],
            datasets: [{
                data: [${totalStudents != null ? totalStudents : 10}, ${totalTeachers != null ? totalTeachers : 2}],
                backgroundColor: ['#4f46e5', '#f59e0b'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            plugins: {
                legend: { position: 'bottom', labels: { color: '#1e293b' } }
            }
        }
    });
</script>
</body>
</html>