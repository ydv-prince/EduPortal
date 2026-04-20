<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Platform Settings | E-Learn Admin</title>
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
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
            --input-bg: #f8fafc;
            --input-border: #e2e8f0;
        }

        body { background-color: var(--bg-dark); color: var(--text-main); font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        
        .portal-nav { background: rgba(7, 11, 20, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid rgba(255,255,255,0.08); position: sticky; top: 0; z-index: 1000; }
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid rgba(255,255,255,0.05); }
        .nav-item-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 5px; font-weight: 500;}
        .nav-item-link:hover, .nav-item-link.active { background: rgba(99, 102, 241, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: var(--danger); margin-top: 25px; }

        /* --- UI FIX: White Cards for Better Contrast --- */
        .content-card { 
            background: white !important; 
            border-radius: 24px; 
            padding: 30px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.2); 
            margin-bottom: 25px;
        }
        
        .card-header-title { 
            font-size: 1.1rem; 
            font-weight: 800; 
            margin-bottom: 25px; 
            display: flex; 
            align-items: center; 
            gap: 12px; 
            padding-bottom: 15px;
            border-bottom: 1px solid #f1f5f9;
        }

        /* Forms Styling */
        .form-label { color: #475569; font-size: 0.75rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        
        .custom-input { 
            background: var(--input-bg); 
            border: 2px solid var(--input-border); 
            color: #1e293b; 
            border-radius: 12px; 
            padding: 12px 15px; 
            width: 100%; 
            transition: 0.3s; 
            font-weight: 500;
        }
        .custom-input:focus { 
            border-color: var(--primary); 
            background: white; 
            outline: none; 
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1); 
        }
        
        .input-group-text { 
            background: #e2e8f0; 
            border: 2px solid var(--input-border); 
            border-right: none; 
            border-radius: 12px 0 0 12px; 
            color: #475569; 
            font-weight: 700;
        }
        .addon-input { border-radius: 0 12px 12px 0 !important; border-left: none !important; }
        
        .helper-text { font-size: 0.75rem; color: #64748b; margin-top: 8px; font-weight: 500; }
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
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item-link active"><i class="fa-solid fa-sliders w-20px text-center"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout"><i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="mb-4">
                    <h2 class="fw-bold m-0 text-white">System Configuration</h2>
                    <p class="text-dim m-0">Global platform rules and administrator security.</p>
                </div>

                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success border-0 rounded-4 mb-4">
                        <i class="fa-solid fa-circle-check me-2"></i> ${successMsg}
                    </div>
                </c:if>

                <div class="row g-4">
                    <%-- Platform Prefs --%>
                    <div class="col-lg-7">
                        <div class="content-card">
                            <div class="card-header-title" style="color: #4f46e5;">
                                <i class="fa-solid fa-sliders"></i> General Settings
                            </div>
                            
                            <form action="${pageContext.request.contextPath}/admin/settings/update-platform" method="post">
                                <div class="mb-4">
                                    <label class="form-label">Platform Branding Name</label>
                                    <input type="text" name="platformName" class="custom-input" value="E-Learn Platform" required>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label">Official Support Email</label>
                                    <input type="email" name="supportEmail" class="custom-input" value="support@elearn.com" required>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Instructor Payout Share</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-percent"></i></span>
                                        <input type="number" name="commissionRate" class="form-control custom-input addon-input" value="70" required>
                                    </div>
                                    <p class="helper-text">Current: 70% goes to Instructor, 30% to Platform.</p>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 py-3 rounded-3 fw-bold shadow">Save Changes</button>
                            </form>
                        </div>
                    </div>

                    <%-- Security --%>
                    <div class="col-lg-5">
                        <div class="content-card">
                            <div class="card-header-title" style="color: #ef4444;">
                                <i class="fa-solid fa-shield-halved"></i> Admin Security
                            </div>
                            
                            <form action="${pageContext.request.contextPath}/admin/settings/update-password" method="post">
                                <div class="mb-4 text-center">
                                    <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-2" style="width:60px; height:60px;">
                                        <i class="fa-solid fa-user-shield fs-3 text-danger"></i>
                                    </div>
                                    <h6 class="text-dark fw-bold m-0">${admin.fullName}</h6>
                                    <p class="small text-muted">${admin.email}</p>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Current Password</label>
                                    <input type="password" name="oldPassword" class="custom-input" placeholder="••••••••" required>
                                </div>
                                
                                <div class="mb-4">
                                    <label class="form-label">Set New Password</label>
                                    <input type="password" name="newPassword" class="custom-input" placeholder="••••••••" required>
                                </div>

                                <button type="submit" class="btn btn-danger w-100 py-3 rounded-3 fw-bold">Update Admin Credentials</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>