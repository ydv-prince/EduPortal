<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Profile Settings"/>
<%@ include file="../common/header.jsp" %>

<style>
    :root {
        --bg-dark: #020617;
        --surface: rgba(15, 23, 42, 0.6);
        --primary: #6366f1;
        --accent: #a855f7;
        --emerald: #10b981;
        --warning: #f59e0b;
        --text-dim: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.08);
    }

    body { background-color: var(--bg-dark); color: #f8fafc; overflow-x: hidden; }

    /* ── Ambient Background Glow ── */
    .profile-glow {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: radial-gradient(circle at 10% 20%, rgba(99, 102, 241, 0.03) 0%, transparent 50%),
                    radial-gradient(circle at 90% 80%, rgba(168, 85, 247, 0.03) 0%, transparent 50%);
        z-index: -1; pointer-events: none;
    }

    /* ── Profile Header & Card ── */
    .profile-card-main {
        background: var(--surface); backdrop-filter: blur(12px);
        border: 1px solid var(--glass-border); border-radius: 24px;
        overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.3);
    }
    .profile-banner {
        height: 120px;
        background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
        position: relative; overflow: hidden;
    }
    .banner-circle { position: absolute; top: -30px; right: -30px; width: 150px; height: 150px; background: white; opacity: 0.1; border-radius: 50%; }

    .profile-avatar-wrap {
        width: 100px; height: 100px;
        background: var(--bg-dark); border: 4px solid var(--glass-border);
        border-radius: 25px; display: flex; align-items: center; justify-content: center;
        font-size: 2.8rem; font-weight: 900; color: white;
        margin-top: -50px; margin-left: auto; margin-right: auto;
        box-shadow: 0 10px 25px rgba(0,0,0,0.5); position: relative; z-index: 2;
        overflow: hidden; /* Important for the image to fit nicely */
    }
    .profile-avatar-img {
        width: 100%; height: 100%; object-fit: cover;
    }

    /* ── Tab Styling ── */
    .p-nav-tabs { background: rgba(255, 255, 255, 0.02); padding: 8px; border-radius: 16px; border: 1px solid var(--glass-border); }
    .p-tab-btn {
        flex: 1; border: none; background: transparent; color: var(--text-dim);
        padding: 14px; border-radius: 12px; font-weight: 800; font-size: 0.85rem;
        transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .p-tab-btn.active { background: var(--primary); color: white; box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3); }
    .p-tab-btn:hover:not(.active) { background: rgba(255,255,255,0.05); color: white; }

    /* ── Input & Form Styling ── */
    .glass-card { background: var(--surface); backdrop-filter: blur(12px); border: 1px solid var(--glass-border); border-radius: 24px; }
    
    .p-input-group { position: relative; margin-bottom: 24px; }
    .profile-label { display: block; font-size: 0.75rem; font-weight: 800; color: var(--text-dim); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
    .p-input-group i { position: absolute; left: 18px; top: 40px; color: #64748b; font-size: 1rem; transition: 0.3s; }
    
    .p-input {
        width: 100%; background: rgba(255, 255, 255, 0.02); border: 1.5px solid var(--glass-border);
        border-radius: 14px; padding: 14px 20px 14px 50px; color: white; transition: 0.3s;
    }
    .p-input:focus { border-color: var(--primary); outline: none; background: rgba(255, 255, 255, 0.05); box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1); }
    .p-input:focus + i, .p-input-group:focus-within i { color: var(--primary); }
    .p-input[readonly] { background: rgba(0,0,0,0.3); color: var(--text-dim); cursor: not-allowed; border-style: dashed; }
    
    /* Specific styling for file input */
    input[type="file"].p-input {
        padding-top: 11px;
        padding-bottom: 11px;
    }

    .btn-save {
        background: var(--primary); color: white; border: none; padding: 14px 35px;
        border-radius: 14px; font-weight: 800; transition: 0.3s; display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-save:hover { transform: translateY(-3px); background: #4f46e5; box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3); }
    
    /* ── Animation ── */
    @keyframes fadeInUp { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
    .animate-fade { animation: fadeInUp 0.5s ease-out forwards; }
</style>

<div class="profile-glow"></div>

<div class="container-fluid px-lg-5 py-4">
    <div class="row g-4">
        
        <%-- Fixed Sidebar Grid --%>
        <div class="col-lg-3 d-none d-lg-block">
            <%@ include file="../common/sidebar.jsp" %>
        </div>

        <%-- Fixed Main Content Grid --%>
        <div class="col-lg-9 animate-fade">
            
            <%-- Global Flash Messages --%>
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success border-success border-opacity-25 bg-success bg-opacity-10 text-emerald rounded-4 fw-600 small mb-4 d-flex align-items-center shadow-sm">
                    <i class="fa-solid fa-circle-check fs-5 me-3"></i> ${successMsg}
                </div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger border-danger border-opacity-25 bg-danger bg-opacity-10 text-danger rounded-4 fw-600 small mb-4 d-flex align-items-center shadow-sm">
                    <i class="fa-solid fa-triangle-exclamation fs-5 me-3"></i> ${errorMsg}
                </div>
            </c:if>

            <div class="row g-4">
                
                <%-- Left Profile Summary Card --%>
                <div class="col-lg-4">
                    <div class="profile-card-main text-center pb-4 mb-4">
                        <div class="profile-banner"><div class="banner-circle"></div></div>
                        
                        <%-- ✅ Profile Picture Logic --%>
                        <div class="profile-avatar-wrap text-primary">
                            <c:choose>
                                <c:when test="${not empty student.profilePicture}">
                                    <img src="${pageContext.request.contextPath}${student.profilePicture}" alt="Profile" class="profile-avatar-img">
                                </c:when>
                                <c:otherwise>
                                    ${student.fullName.substring(0,1).toUpperCase()}
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <h4 class="text-white fw-900 mt-3 mb-1">${student.fullName}</h4>
                        <p class="text-dim small mb-4">${student.email}</p>
                        
                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-4 py-2 fw-800" style="font-size: 0.7rem; letter-spacing: 1px;">
                            <i class="fa-solid fa-user-astronaut me-2"></i> STUDENT
                        </span>

                        <div class="mt-5 px-4">
                            <div class="d-flex justify-content-between p-3 rounded-4 mb-3" style="background: rgba(255,255,255,0.02); border: 1px solid var(--glass-border);">
                                <span class="text-dim small fw-600"><i class="fa-solid fa-book-open me-2"></i> Enrolled Courses</span>
                                <span class="text-white fw-900 h6 m-0">${totalEnrolled}</span>
                            </div>
                            <div class="d-flex justify-content-between p-3 rounded-4" style="background: rgba(255,255,255,0.02); border: 1px solid var(--glass-border);">
                                <span class="text-dim small fw-600"><i class="fa-solid fa-award text-warning me-2"></i> Certificates</span>
                                <span class="text-white fw-900 h6 m-0">${certificates.size()}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Right Settings Area --%>
                <div class="col-lg-8">

                    <div class="p-nav-tabs d-flex mb-4 shadow-sm">
                        <button class="p-tab-btn active" id="btn-profile" onclick="switchTab('profile')"><i class="fa-solid fa-user-pen me-2"></i> Edit Profile</button>
                        <button class="p-tab-btn" id="btn-password" onclick="switchTab('password')"><i class="fa-solid fa-shield-halved me-2"></i> Security</button>
                    </div>

                    <%-- Profile Tab --%>
                    <div id="pane-profile" class="glass-card p-4 p-md-5">
                        <h4 class="text-white fw-900 mb-1">Personal Details</h4>
                        <p class="text-dim small mb-4 pb-3 border-bottom border-white-50 border-opacity-10">Update your public information and contact details.</p>
                        
                        <%-- ✅ Added enctype="multipart/form-data" for file uploads --%>
                        <form action="${pageContext.request.contextPath}/student/profile/update" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <%-- ✅ New File Input for Profile Picture --%>
                            <div class="p-input-group mb-4">
                                <label class="profile-label">Profile Picture (Optional)</label>
                                <i class="fa-solid fa-camera"></i>
                                <input type="file" name="profileImage" class="p-input" accept="image/png, image/jpeg, image/jpg">
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="p-input-group">
                                        <label class="profile-label">Full Name</label>
                                        <i class="fa-solid fa-user"></i>
                                        <input type="text" name="fullName" class="p-input" value="${student.fullName}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-input-group">
                                        <label class="profile-label">Phone Number</label>
                                        <i class="fa-solid fa-phone"></i>
                                        <input type="text" name="phone" class="p-input" value="${student.phone}" placeholder="+91 ...">
                                    </div>
                                </div>
                            </div>

                            <div class="p-input-group">
                                <label class="profile-label">Email Address <span class="text-danger small text-lowercase ms-2">(Immutable)</span></label>
                                <i class="fa-solid fa-envelope"></i>
                                <input type="email" class="p-input" value="${student.email}" readonly title="You cannot change your registered email.">
                            </div>

                            <div class="mb-4 pb-2">
                                <label class="profile-label">Short Bio</label>
                                <textarea name="bio" class="p-input" style="padding-left:20px; height: 120px; resize: none;" placeholder="Tell us a little about your learning goals...">${student.bio}</textarea>
                            </div>

                            <button type="submit" class="btn-save shadow-lg">
                                <i class="fa-solid fa-floppy-disk"></i> Save Changes
                            </button>
                        </form>
                    </div>

                    <%-- Security Tab --%>
                    <div id="pane-password" class="glass-card p-4 p-md-5" style="display: none;">
                        <h4 class="text-white fw-900 mb-1">Account Security</h4>
                        <p class="text-dim small mb-4 pb-3 border-bottom border-white-50 border-opacity-10">Ensure your account is using a strong password to stay secure.</p>
                        
                        <form action="${pageContext.request.contextPath}/student/profile/change-password" method="post" onsubmit="return validatePasswordForm(event)">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <div class="p-input-group">
                                <label class="profile-label">Current Password</label>
                                <i class="fa-solid fa-lock"></i>
                                <input type="password" name="currentPassword" class="p-input" placeholder="Enter your current password" required>
                            </div>

                            <div class="p-input-group mb-2">
                                <label class="profile-label">New Password</label>
                                <i class="fa-solid fa-key text-warning"></i>
                                <input type="password" name="newPassword" id="newPwd" class="p-input" placeholder="Minimum 8 characters" oninput="checkStrength(this.value)" required>
                            </div>
                            
                            <%-- Password Strength Meter --%>
                            <div class="d-flex gap-2 mb-4 px-1">
                                <div id="s1" class="flex-grow-1" style="height:4px; border-radius:10px; background:rgba(255,255,255,0.05); transition: 0.3s;"></div>
                                <div id="s2" class="flex-grow-1" style="height:4px; border-radius:10px; background:rgba(255,255,255,0.05); transition: 0.3s;"></div>
                                <div id="s3" class="flex-grow-1" style="height:4px; border-radius:10px; background:rgba(255,255,255,0.05); transition: 0.3s;"></div>
                            </div>

                            <div class="p-input-group mb-5">
                                <label class="profile-label">Confirm New Password</label>
                                <i class="fa-solid fa-shield-check text-emerald"></i>
                                <input type="password" name="confirmPassword" id="confirmPwd" class="p-input" placeholder="Type new password again" required>
                            </div>

                            <button type="submit" class="btn btn-warning rounded-4 px-4 py-3 fw-800 shadow-lg border-0 d-inline-flex align-items-center gap-2">
                                <i class="fa-solid fa-arrows-rotate"></i> Update Password
                            </button>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Tab Switcher
    function switchTab(tab) {
        const profilePane = document.getElementById('pane-profile');
        const passwordPane = document.getElementById('pane-password');
        const btnProfile = document.getElementById('btn-profile');
        const btnPassword = document.getElementById('btn-password');

        if(tab === 'profile') {
            profilePane.style.display = 'block';
            passwordPane.style.display = 'none';
            btnProfile.classList.add('active');
            btnPassword.classList.remove('active');
        } else {
            profilePane.style.display = 'none';
            passwordPane.style.display = 'block';
            btnProfile.classList.remove('active');
            btnPassword.classList.add('active');
        }
    }

    // Fixed Password Strength Meter Logic
    function checkStrength(val) {
        const s1 = document.getElementById('s1');
        const s2 = document.getElementById('s2');
        const s3 = document.getElementById('s3');
        
        let score = 0;
        if(val.length >= 8) score++;
        if(/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
        if(/[0-9]/.test(val) && /[^A-Za-z0-9]/.test(val)) score++; // Number + Special Char

        // Reset colors
        s1.style.background = 'rgba(255,255,255,0.05)';
        s2.style.background = 'rgba(255,255,255,0.05)';
        s3.style.background = 'rgba(255,255,255,0.05)';
        
        // Progressive coloring
        if(score >= 1) { s1.style.background = '#ef4444'; } // Red
        if(score >= 2) { s1.style.background = '#f59e0b'; s2.style.background = '#f59e0b'; } // Orange
        if(score >= 3) { s1.style.background = '#10b981'; s2.style.background = '#10b981'; s3.style.background = '#10b981'; } // Green
    }

    // Smart Validation: Check if passwords match before sending to server
    function validatePasswordForm(e) {
        const newPwd = document.getElementById('newPwd').value;
        const confirmPwd = document.getElementById('confirmPwd').value;
        
        if (newPwd !== confirmPwd) {
            e.preventDefault(); // Stop form submission
            alert("Oops! The New Password and Confirm Password do not match. Please check and try again.");
            return false;
        }
        return true;
    }
</script>

<%@ include file="../common/footer.jsp" %>