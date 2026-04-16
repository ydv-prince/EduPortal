package com.elearn.service;

import com.elearn.dto.UserRegistrationDto;
import com.elearn.model.User;
import com.elearn.model.enums.Role;
import com.elearn.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    /**
     * Registers a new user and sends an initial OTP for verification.
     */
    public User registerUser(UserRegistrationDto dto) {
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Email is already registered: " + dto.getEmail());
        }
        
        User user = new User();
        user.setFullName(dto.getFullName());
        user.setEmail(dto.getEmail());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setRole(dto.getRole());
        user.setEnabled(false);
        user.setEmailVerified(false);

        // 1. Generate OTP
        String otp = generateOTP();
        user.setOtp(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(10));

        // 2. Save to Database FIRST
        User savedUser = userRepository.save(user);
        
        // 3. Log check (Console mein check karna ki OTP generate hua ya nahi)
        log.info("Generating OTP for {}: {}", savedUser.getEmail(), otp);

        try {
            // 4. Send OTP Email (savedUser ka data use karein)
            emailService.sendOtpEmail(savedUser.getEmail(), savedUser.getFullName(), otp);
            log.info("OTP Email triggered successfully!");
        } catch (Exception e) {
            log.error("Failed to trigger OTP email: {}", e.getMessage());
        }
        
        return savedUser;
    }

    // UserService.java
    public User findByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    /**
     * Verifies the OTP entered by the user.
     */
    public boolean verifyOtp(String email, String otp) {
        User user = getUserByEmail(email);

        if (user.getOtp() == null || !user.getOtp().equals(otp)) {
            throw new RuntimeException("Invalid OTP. Please try again.");
        }

        if (user.getOtpExpiry().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("OTP has expired. Please request a new one.");
        }

        user.setEnabled(true);
        user.setEmailVerified(true);
        user.setOtp(null); // Clear OTP after success
        user.setOtpExpiry(null);
        userRepository.save(user);
        
        return true;
    }

    /**
     * Regenerates a new OTP and sends it via email.
     */
    public void resendOtp(String email) {
        User user = getUserByEmail(email);
        String newOtp = generateOTP();
        user.setOtp(newOtp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(10));
        
        userRepository.save(user);
        sendOtpEmail(user.getEmail(), user.getFullName(), newOtp);
        
        log.info("New OTP generated and sent to: {}", email);
    }

    public void sendOtpEmail(String email, String name, String otp) {
        try {
            emailService.sendOtpEmail(email, name, otp);
        } catch (Exception e) {
            log.error("Failed to send OTP email to {}: {}", email, e.getMessage());
        }
    }

    public String generateOTP() {
        Random random = new Random();
        int otpValue = 100000 + random.nextInt(900000); 
        return String.valueOf(otpValue);
    }

    // --- Admin Dashboard & Analytics Methods ---

    @Transactional(readOnly = true)
    public long countByRole(Role role) {
        return userRepository.countByRole(role);
    }

    @Transactional(readOnly = true)
    public List<User> getUsersByRole(Role role) {
        return userRepository.findByRole(role);
    }

    // --- Data Retrieval Methods ---

    @Transactional(readOnly = true)
    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
    }

    @Transactional(readOnly = true)
    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
    }

    // --- Profile & Status Management ---

    // ✅ FIX: Parameter 'String profilePicture' changed to 'MultipartFile profileImage' to support real uploads
    public User updateProfile(Long userId, String fullName, String bio, String phone, org.springframework.web.multipart.MultipartFile profileImage) throws Exception {
        User user = getUserById(userId);
        user.setFullName(fullName);
        user.setBio(bio);
        user.setPhone(phone);
        
        // Profile Photo Upload Logic integration
        if (profileImage != null && !profileImage.isEmpty()) {
            String uploadDir = "uploads/profiles/";
            java.nio.file.Path uploadPath = java.nio.file.Paths.get(uploadDir);

            if (!java.nio.file.Files.exists(uploadPath)) {
                java.nio.file.Files.createDirectories(uploadPath);
            }

            String fileName = System.currentTimeMillis() + "_" + profileImage.getOriginalFilename();
            java.nio.file.Path filePath = uploadPath.resolve(fileName);

            java.nio.file.Files.copy(profileImage.getInputStream(), filePath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

            user.setProfilePicture("/" + uploadDir + fileName);
        }
        
        return userRepository.save(user);
    }

    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = getUserById(userId);
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("The current password you entered is incorrect");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public void toggleUserStatus(Long userId) {
        User user = getUserById(userId);
        user.setEnabled(!user.isEnabled());
        userRepository.save(user);
    }

    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }
}