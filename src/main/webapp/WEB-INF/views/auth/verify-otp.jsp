<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Verify OTP | E-Learn Security</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet"/>
    <style>
        :root {
            --bg-dark: #050505;
            --surface: #0f172a;
            --primary: #6366f1;
            --emerald: #10b981;
            --text-dim: #94a3b8;
        }

        body { 
            background: var(--bg-dark); 
            color: white; 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            min-height: 100vh; 
            display: flex; align-items: center; justify-content: center; 
            padding: 20px;
            overflow: hidden;
        }

        /* Background Glow Elements */
        body::before { content: ''; position: fixed; width: 400px; height: 400px; background: radial-gradient(circle, rgba(99, 102, 241, 0.1) 0%, transparent 70%); top: -10%; left: -10%; z-index: -1; }

        .otp-card { 
            background: #000; 
            padding: 50px 40px; 
            border-radius: 30px; 
            box-shadow: 0 40px 100px rgba(0,0,0,0.8); 
            width: 100%; max-width: 480px; 
            text-align: center; 
            border: 1px solid rgba(255,255,255,0.08); 
            position: relative;
        }

        .otp-icon-wrap {
            width: 80px; height: 80px;
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary);
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 25px;
            font-size: 2rem;
            border: 1px solid rgba(99, 102, 241, 0.2);
        }

        /* 6 Separate Input Blocks */
        .otp-inputs { display: flex; justify-content: center; gap: 12px; margin-bottom: 30px; }
        .otp-field { 
            width: 55px; height: 65px; 
            border: 2px solid rgba(255,255,255,0.1); 
            border-radius: 15px; 
            background: #0f172a; 
            text-align: center; 
            font-size: 1.8rem; font-weight: 800; 
            color: white; 
            transition: 0.3s;
            outline: none;
        }
        .otp-field:focus { border-color: var(--primary); background: #1e293b; box-shadow: 0 0 20px rgba(99, 102, 241, 0.2); }

        .btn-verify { 
            width: 100%; padding: 16px; border-radius: 15px; 
            background: var(--primary); border: none; 
            color: white; font-weight: 800; font-size: 1rem;
            transition: 0.3s; box-shadow: 0 10px 25px rgba(99, 102, 241, 0.3);
        }
        .btn-verify:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(99, 102, 241, 0.4); filter: brightness(1.1); }

        .resend-link { color: var(--primary); font-weight: 700; text-decoration: none; transition: 0.3s; }
        .resend-link:hover { color: white; text-decoration: underline; }

        .timer { font-size: 0.85rem; color: var(--text-dim); margin-top: 15px; display: block; }
    </style>
</head>
<body>

<div class="otp-card">
    <div class="otp-icon-wrap">
        <i class="fa-solid fa-envelope-circle-check"></i>
    </div>

    <div class="mb-4">
        <h3 class="fw-800 m-0">Check your Email</h3>
        <p class="small text-muted mt-2">
            We've sent a 6-digit verification code to <br/>
            <span class="text-white fw-bold">${email}</span>
        </p>
    </div>

    <form action="${pageContext.request.contextPath}/auth/verify-otp" method="post" id="otpForm">
        <input type="hidden" name="email" value="${email}"/>
        <input type="hidden" name="otp" id="finalOtp"/>
        
        <div class="otp-inputs">
            <input type="text" class="otp-field" maxlength="1" pattern="\d*" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" pattern="\d*" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" pattern="\d*" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" pattern="\d*" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" pattern="\d*" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" pattern="\d*" inputmode="numeric">
        </div>

        <button type="submit" class="btn-verify">Verify & Activate Account</button>
    </form>

    <div class="mt-4">
        <p class="small text-muted m-0">Didn't receive the code?</p>
        <a href="#" class="resend-link">Resend OTP</a>
        <span class="timer" id="timer">Resend available in 00:59</span>
    </div>

    <a href="${pageContext.request.contextPath}/auth/register" class="text-muted d-block mt-4 small text-decoration-none">
        <i class="fa-solid fa-arrow-left me-1"></i> Back to Register
    </a>
</div>

<script>
    const fields = document.querySelectorAll('.otp-field');
    const finalInput = document.getElementById('finalOtp');
    const form = document.getElementById('otpForm');

    // Auto-focus logic
    fields.forEach((field, index) => {
        field.addEventListener('input', (e) => {
            if (e.target.value.length === 1 && index < fields.length - 1) {
                fields[index + 1].focus();
            }
            updateFinalValue();
        });

        field.addEventListener('keydown', (e) => {
            if (e.key === 'Backspace' && !e.target.value && index > 0) {
                fields[index - 1].focus();
            }
        });
    });

    function updateFinalValue() {
        let otp = "";
        fields.forEach(f => otp += f.value);
        finalInput.value = otp;
    }

    form.addEventListener('submit', (e) => {
        updateFinalValue();
        if (finalInput.value.length < 6) {
            e.preventDefault();
            alert("Please enter the complete 6-digit code.");
        }
    });

    // Simple Timer Logic
    let timeLeft = 59;
    const timerElem = document.getElementById('timer');
    const timerInterval = setInterval(() => {
        if (timeLeft <= 0) {
            clearInterval(timerInterval);
            timerElem.innerText = "You can resend now!";
        } else {
            timerElem.innerText = `Resend available in 00:\${timeLeft < 10 ? '0' : ''}\${timeLeft}`;
            timeLeft -= 1;
        }
    }, 1000);
</script>

</body>
</html>