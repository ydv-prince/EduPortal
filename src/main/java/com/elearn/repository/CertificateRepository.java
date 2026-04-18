package com.elearn.repository;

import com.elearn.model.Certificate;
import com.elearn.model.Course;
import com.elearn.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CertificateRepository extends JpaRepository<Certificate, Long> {

    // 1. Student ke saare certificates nikalne ke liye
    List<Certificate> findByUser(User user);

    // 2. Check karne ke liye ki kya student ko is course ka certificate mil chuka hai
    Optional<Certificate> findByUserAndCourse(User user, Course course);

    // 3. Verification ke liye (Unique Number se search)
    Optional<Certificate> findByCertificateNumber(String certificateNumber);

    // 4. Duplicate rokne ke liye
    boolean existsByUserAndCourse(User user, Course course);
}