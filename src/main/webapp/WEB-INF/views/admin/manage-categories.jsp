<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories | E-Learn Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #070b14;
            --surface: #111827;
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --emerald: #10b981;
            --danger: #ef4444;
            --border: rgba(255, 255, 255, 0.08);
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
        }

        body { background-color: var(--bg-dark); color: var(--text-main); font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        
        .portal-nav { background: rgba(7, 11, 20, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        .sidebar { background: var(--surface); border-radius: 24px; padding: 24px; height: fit-content; border: 1px solid rgba(255,255,255,0.05); }
        .nav-item-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-dim); text-decoration: none; transition: 0.3s; margin-top: 5px; font-weight: 500;}
        .nav-item-link:hover, .nav-item-link.active { background: rgba(99, 102, 241, 0.1); color: var(--primary); }
        .nav-item-link.logout { color: var(--danger); margin-top: 25px; }

        .content-card { background: var(--surface); border-radius: 24px; padding: 30px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.2); }

        /* --- UI Table Styles --- */
        .custom-table { border-collapse: separate; border-spacing: 0 10px; margin-bottom: 0;}
        .custom-table thead th { border: none; color: var(--text-dim); font-size: 0.75rem; text-transform: uppercase; padding: 0 15px 15px; }
        
        .custom-table tbody tr { background: white !important; transition: 0.3s; border-radius: 12px; }
        .custom-table td { border: none; padding: 15px; vertical-align: middle; color: #1e293b; }
        .custom-table td:first-child { border-radius: 12px 0 0 12px; }
        .custom-table td:last-child { border-radius: 0 12px 12px 0; }

        .category-name { color: #4f46e5 !important; font-weight: 800; font-size: 1rem; }
        .category-desc { color: #64748b; font-size: 0.85rem; line-height: 1.4; }

        .cat-icon-box {
            width: 42px; height: 42px; border-radius: 12px;
            background: #e0e7ff; color: #4f46e5;
            display: flex; align-items: center; justify-content: center; font-size: 1.1rem;
        }

        .action-btn { width: 35px; height: 35px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center; transition: 0.3s; border: none; }
        .action-btn.edit { background: #ecfdf5; color: #059669; }
        .action-btn.delete { background: #fef2f2; color: #dc2626; }
        .action-btn:hover { transform: translateY(-2px); }

        /* Modal Styles */
        .modal-content { background: var(--surface); color: white; border: 1px solid var(--border); border-radius: 24px; padding: 15px;}
        .modal-header { border-bottom: 1px solid var(--border); }
        .custom-input { background: rgba(255, 255, 255, 0.05); border: 1px solid var(--border); border-radius: 12px; color: white; padding: 12px; width: 100%; margin-bottom: 20px; outline: none; transition: 0.3s;}
        .custom-input:focus { border-color: var(--primary); background: rgba(255, 255, 255, 0.08); }
        .custom-label { font-size: 0.8rem; font-weight: 700; color: var(--text-dim); margin-bottom: 8px; display: block; }
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
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item-link logout"><i class="fa-solid fa-power-off w-20px text-center"></i> Secure Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold m-0 text-white">Course Categories</h2>
                        <p class="text-dim m-0">Organize your platform's curriculum.</p>
                    </div>
                    <button class="btn btn-primary rounded-pill px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                        <i class="fa-solid fa-plus me-2"></i> Add New
                    </button>
                </div>

                <%-- Alerts --%>
                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success bg-success bg-opacity-10 text-success border-0 rounded-4 mb-4">
                        <i class="fa-solid fa-check-circle me-2"></i> ${successMsg}
                    </div>
                </c:if>

                <div class="content-card">
                    <div class="table-responsive">
                        <table class="table custom-table">
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Description</th>
                                    <th>Stats</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cat" items="${categories}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="cat-icon-box"><i class="fa-solid fa-folder"></i></div>
                                                <div class="category-name">${cat.name}</div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="category-desc text-truncate" style="max-width: 300px;">
                                                <c:out value="${cat.description}" default="General category for various courses."/>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-2 py-1">
                                                ${not empty cat.courses ? cat.courses.size() : 0} Courses
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <div class="d-flex gap-2 justify-content-end">
                                                <button class="action-btn edit" onclick="openEditModal(${cat.id}, '${cat.name}', '${cat.description}')">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </button>
                                                <form action="${pageContext.request.contextPath}/admin/categories/delete/${cat.id}" method="post" class="m-0" onsubmit="return confirm('Deleting this category will affect linked courses. Continue?')">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="action-btn delete">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </form>
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

<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Add New Category</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories/add" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="modal-body">
                    <label class="custom-label">CATEGORY NAME</label>
                    <input type="text" name="name" class="custom-input" placeholder="e.g. Web Development" required>
                    
                    <label class="custom-label">DESCRIPTION</label>
                    <textarea name="description" class="custom-input" rows="3" placeholder="Briefly describe what courses fall under this category..."></textarea>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-link text-dim text-decoration-none" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">Create Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Update Category</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="editForm" action="" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="modal-body">
                    <label class="custom-label">CATEGORY NAME</label>
                    <input type="text" name="name" id="editName" class="custom-input" required>
                    
                    <label class="custom-label">DESCRIPTION</label>
                    <textarea name="description" id="editDesc" class="custom-input" rows="3"></textarea>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-link text-dim text-decoration-none" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openEditModal(id, name, desc) {
        // Populate fields
        document.getElementById('editName').value = name;
        document.getElementById('editDesc').value = (desc && desc !== 'null') ? desc : '';
        
        // Update form action with dynamic ID
        document.getElementById('editForm').action = '${pageContext.request.contextPath}/admin/categories/update/' + id;
        
        // Trigger Modal
        new bootstrap.Modal(document.getElementById('editCategoryModal')).show();
    }
</script>
</body>
</html>