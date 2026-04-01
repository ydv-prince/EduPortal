<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Secure Checkout"/>
<%@ include file="../common/header.jsp" %>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<style>
    :root {
        --bg-dark: #020617;
        --surface: rgba(15, 23, 42, 0.7);
        --primary: #6366f1;
        --text-dim: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.08);
    }
    body { background-color: var(--bg-dark); color: #f8fafc; }
    .glass-card { background: var(--surface); backdrop-filter: blur(16px); border: 1px solid var(--glass-border); border-radius: 24px; }
    .btn-pay { background: var(--primary); color: white; padding: 16px; border-radius: 16px; font-weight: 800; border: none; width: 100%; }
</style>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 animate-fade">
            <div class="glass-card p-5 shadow-lg">
                <h2 class="fw-900 mb-4 text-center">Complete Enrollment</h2>
                
                <div class="p-4 rounded-4 mb-4" style="background: rgba(255,255,255,0.03); border: 1px solid var(--glass-border);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="m-0 fw-800">${course.title}</h5>
                            <p class="text-dim m-0 small">Access: Lifetime + Certificate</p>
                        </div>
                        <div class="text-end">
                            <span class="display-6 fw-900 text-primary">₹${course.discountPrice != null ? course.discountPrice : course.price}</span>
                        </div>
                    </div>
                </div>

                <p class="text-center text-dim small mb-4">Click below to open the secure payment gateway.</p>
                
                <button type="button" class="btn-pay" id="razorpay-btn">
                    <i class="fa-solid fa-shield-lock me-2"></i> Pay Securely via Razorpay
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Get numeric amount safely
    const finalAmount = "${course.discountPrice != null ? course.discountPrice : course.price}";

    document.getElementById('razorpay-btn').onclick = function(e) {
        const btn = this;
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin me-2"></i> Initializing Gateway...';

        // 1. Create Order on Server
        fetch('${pageContext.request.contextPath}/student/payment/create-order?courseId=${course.id}&amount=' + parseFloat(finalAmount), {
            method: 'POST',
            headers: { 'X-CSRF-TOKEN': '${_csrf.token}' }
        })
        .then(res => {
            if(!res.ok) throw new Error("Order creation failed");
            return res.json();
        })
        .then(order => {
            // 2. Open Razorpay Modal
            const options = {
                "key": "rzp_test_Sc4LZ5NOERXsqr", // IMPORTANT: REPLACE THIS
                "amount": order.amount,
                "currency": "INR",
                "name": "E-Learn Academy",
                "description": "Enrollment: ${course.title}",
                "order_id": order.id,
                "handler": function (response) {
                    submitVerification(response);
                },
                "prefill": {
                    "name": "${student.fullName}",
                    "email": "${student.email}"
                },
                "theme": { "color": "#6366f1" }
            };
            const rzp = new Razorpay(options);
            rzp.open();
            btn.disabled = false;
            btn.innerHTML = 'Pay Securely via Razorpay';
        })
        .catch(err => {
            alert("Error: " + err.message);
            btn.disabled = false;
            btn.innerHTML = 'Pay Securely via Razorpay';
        });
    };

    function submitVerification(response) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/student/payment/verify';

        const params = {
            razorpay_payment_id: response.razorpay_payment_id,
            razorpay_order_id: response.razorpay_order_id,
            razorpay_signature: response.razorpay_signature,
            courseId: "${course.id}",
            amount: finalAmount,
            "${_csrf.parameterName}": "${_csrf.token}"
        };

        for (const key in params) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = params[key];
            form.appendChild(input);
        }

        document.body.appendChild(form);
        form.submit();
    }
</script>

<%@ include file="../common/footer.jsp" %>