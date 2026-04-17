package com.elearn.config;

import com.elearn.model.*;
import com.elearn.model.enums.CourseLevel;
import com.elearn.model.enums.Role;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final CourseRepository courseRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (userRepository.count() > 0) {
            System.out.println("ℹ️ Data exists — skipping");
            return;
        }
        createDefaultUsers();
        createDefaultCategories();
        createSampleCourses();
        System.out.println("✅ Initialization complete!");
    }

    private void createDefaultUsers() {
        User admin = new User();
        admin.setFullName("Super Admin");
        admin.setEmail("admin@elearn.com");
        admin.setPassword(passwordEncoder.encode("Admin@123"));
        admin.setRole(Role.ADMIN);
        admin.setEnabled(true);
        admin.setEmailVerified(true);

        User teacher = new User();
        teacher.setFullName("Rajesh Kumar");
        teacher.setEmail("teacher@elearn.com");
        teacher.setPassword(passwordEncoder.encode("Teacher@123"));
        teacher.setRole(Role.TEACHER);
        teacher.setEnabled(true);
        teacher.setEmailVerified(true);
        teacher.setBio("10+ years Java experience");

        User student = new User();
        student.setFullName("Priya Sharma");
        student.setEmail("student@elearn.com");
        student.setPassword(passwordEncoder.encode("Student@123"));
        student.setRole(Role.STUDENT);
        student.setEnabled(true);
        student.setEmailVerified(true);

        userRepository.saveAll(List.of(admin, teacher, student));
        System.out.println("✅ Users created");
    }

    private void createDefaultCategories() {
        String[][] cats = {
            {"Web Development","HTML, CSS, JS, Spring Boot","fa-code"},
            {"Mobile Development","Android, iOS, Flutter","fa-mobile-alt"},
            {"Data Science","Python, ML, AI","fa-brain"},
            {"Database","MySQL, MongoDB, PostgreSQL","fa-database"},
            {"Cloud Computing","AWS, Azure, DevOps","fa-cloud"},
            {"Cybersecurity","Ethical Hacking, Security","fa-shield-alt"}
        };

        for (String[] c : cats) {
            Category cat = new Category();
            cat.setName(c[0]);
            cat.setDescription(c[1]);
            cat.setIconClass(c[2]);
            categoryRepository.save(cat);
        }
        System.out.println("✅ Categories created");
    }

    private void createSampleCourses() {
        User teacher = userRepository
                .findByEmail("teacher@elearn.com").orElseThrow();
        Category webDev = categoryRepository
                .findByName("Web Development").orElseThrow();

        Course course = new Course();
        course.setTitle("Complete Spring Boot Masterclass");
        course.setDescription("Spring Boot scratch se sikhein");
        course.setPrice(new BigDecimal("999.00"));
        course.setDiscountPrice(new BigDecimal("499.00"));
        course.setLevel(CourseLevel.BEGINNER);
        course.setLanguage("Hindi + English");
        course.setInstructor(teacher);
        course.setCategory(webDev);
        course.setPublished(true);
        course.setApproved(true);
        courseRepository.save(course);

        CourseModule module = new CourseModule();
        module.setTitle("Introduction to Spring Boot");
        module.setOrderIndex(1);
        module.setCourse(course);

        Lesson lesson1 = new Lesson();
        lesson1.setTitle("Spring Boot kya hai?");
        lesson1.setVideoUrl("https://www.youtube.com/embed/sample1");
        lesson1.setDurationMinutes(15);
        lesson1.setOrderIndex(1);
        lesson1.setFreePreview(true);
        lesson1.setModule(module);

        Lesson lesson2 = new Lesson();
        lesson2.setTitle("Project Setup");
        lesson2.setVideoUrl("https://www.youtube.com/embed/sample2");
        lesson2.setDurationMinutes(20);
        lesson2.setOrderIndex(2);
        lesson2.setFreePreview(false);
        lesson2.setModule(module);

        module.getLessons().add(lesson1);
        module.getLessons().add(lesson2);
        course.getModules().add(module);

        courseRepository.save(course);
        System.out.println("✅ Sample courses created");
    }
}