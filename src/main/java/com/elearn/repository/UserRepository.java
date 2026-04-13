package com.elearn.repository;

import com.elearn.model.User;
import com.elearn.model.enums.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // 1. Authentication & Security
    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    // 2. OTP Specific Query
    // Ye tab kaam aayega jab humein direct email aur OTP se user check karna ho
    Optional<User> findByEmailAndOtp(String email, String otp);

    // 3. Admin & Analytics (Fixes your Controller errors)
    List<User> findByRole(Role role);

    long countByRole(Role role);

    // 4. Status Management
    List<User> findByEnabledTrue();
    
    List<User> findByEmailVerifiedFalse(); // Pending verifications list ke liye

    // 5. Advanced Search (Fixed Query with @Param for better compatibility)
    @Query("SELECT u FROM User u WHERE " +
           "LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<User> searchByKeyword(@Param("keyword") String keyword);

    // 6. Bulk Actions (Optional but good for Admin)
    @Query("SELECT COUNT(u) FROM User u WHERE u.enabled = true")
    long countActiveUsers();
}