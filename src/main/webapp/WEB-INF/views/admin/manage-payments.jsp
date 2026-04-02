<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Payments | E-Learn Admin</title>
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

        /* --- TABLE UI FIXES --- */
        .custom-table { color: #1e293b; border-collapse: separate; border-spacing: 0 10px; margin-bottom: 0;}
        .custom-table thead th { border: none; color: var(--text-dim); font-size: 0.75rem; text-transform: uppercase; padding: 0 15px 15px; letter-spacing: 1px;}
        
        /* Row ko bright (White) rakha hai taaki text dikhe */
        .custom-table tbody tr { background: white !important; transition: 0.3s; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .custom-table td { border: none; padding: 15px; vertical-align: middle; border-bottom: 1px solid #f1f5f9;}
        .custom-table td:first-child { border-radius: 12px 0 0 12px; }
        .custom-table td:last-child { border-radius: 0 12px 12px 0; }

        /* Student & Course Info Text Colors */
        .student-name { color: #4f46e5 !important; font-weight: 800; font-size: 0.95rem; }
        .student-email { color: #64748b; font-size: 0.8rem; }
        .course-title { color: #1e293b; font-weight: 700; font-size: 0.9rem; }
        .instructor-name { color: #8b5cf6; font-size: 0.75rem; font-weight: 600; }

        .txn-id { font-family: monospace; font-size: 0.8rem; color: #4338ca; background: #e0e7ff; padding: 4px 8px; border-radius: 6px; font-weight: 600;}
        .amount-text { font-weight: 800; font-size: 1.1rem; color: #059669; }
        .date-text { color: #475569; font-size: 0.8rem; font-weight: 500; }
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
                <a href="${pageContext.request.contextPath}/admin/manage-payments" class="nav-item-link active"><i class="fa-solid fa-money-bill-transfer w-20px text-center"></i> Transactions</a>
                <a href="${pageContext.request.contextPath}/admin/payout-requests" class="nav-item-link"><i class="fa-solid fa-building-columns w-20px text-center"></i> Payout Requests</a>
                <a href="${pageContext.request.contextPath}/admin/support-tickets" class="nav-item-link"><i class="fa-solid fa-headset w-20px text-center"></i> Support Desk</a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item-link"><i class="fa-solid fa-sliders w-20px text-center"></i> Settings</a>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout"><i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="mb-4">
                    <h2 class="fw-bold m-0 text-white">Platform Transactions</h2>
                    <p class="text-dim m-0">Monitor enrollments and financial history.</p>
                </div>

                <div class="content-card">
                    <div class="table-responsive">
                        <table class="table custom-table">
                            <thead>
                                <tr>
                                    <th>Txn Info</th>
                                    <th>Student</th>
                                    <th>Course Details</th>
                                    <th>Amount</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="payment" items="${payments}">
                                    <tr>
                                        <td>
                                            <span class="txn-id">#${payment.transactionId}</span>
                                            <div class="text-muted x-small mt-1" style="font-size: 0.65rem;">VIA: ${payment.paymentMethod}</div>
                                        </td>
                                        
                                        <td>
                                            <div class="student-name">${payment.user.fullName}</div>
                                            <div class="student-email">${payment.user.email}</div>
                                        </td>
                                        
                                        <td>
                                            <div class="course-title text-truncate" style="max-width: 180px;">${payment.course.title}</div>
                                            <div class="instructor-name">By: ${payment.course.instructor.fullName}</div>
                                        </td>
                                        
                                        <td class="amount-text">₹${payment.amount}</td>
                                        
                                        <td class="date-text">
                                            <div>${payment.paidAt.toLocalDate()}</div>
                                            <div class="small opacity-75">${payment.paidAt.toLocalTime().toString().substring(0,5)}</div>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${payment.status.name() == 'SUCCESS' || payment.status.name() == 'COMPLETED'}">
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">SUCCESS</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-2 py-1">${payment.status}</span>
                                                </c:otherwise>
                                            </c:choose>
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