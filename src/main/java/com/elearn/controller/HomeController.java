package com.elearn.controller;

import com.elearn.model.Category;
import com.elearn.model.Course;
import com.elearn.service.CategoryService;
import com.elearn.service.CourseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.*;

@Slf4j
@Controller
@RequiredArgsConstructor
public class HomeController {

    private final CourseService courseService;
    private final CategoryService categoryService;

    // --- MAIN HOME PAGE ---
    @GetMapping({"/", "/home"})
    public String homePage(Model model) {
        log.info("🏠 Home page request received");

        List<Course> topCourses = new ArrayList<>();
        List<Course> popularCourses = new ArrayList<>();
        List<Category> categories = new ArrayList<>();
        Map<Long, Long> categoryCourseCount = new HashMap<>();

        try {
            // Fetching Categories
            categories = categoryService.getAllCategories();
            
            // Fetching Top Rated Courses (Limit to 6)
            List<Course> allTop = courseService.getTopRatedCourses();
            topCourses = allTop.size() > 6 ? allTop.subList(0, 6) : allTop;

            // Fetching Popular Courses (Limit to 8)
            List<Course> allPublished = courseService.getAllPublishedCourses();
            popularCourses = allPublished.size() > 8 ? allPublished.subList(0, 8) : allPublished;

            // Fetch all category counts in one grouped query instead of one query per category
            categoryCourseCount = courseService.getPublishedApprovedCourseCountsByCategory();

        } catch (Exception e) {
            log.error("❌ Error loading homepage data: {}", e.getMessage());
            // Empty lists maintain rakhenge taaki JSP crash na ho
        }

        model.addAttribute("topCourses", topCourses);
        model.addAttribute("popularCourses", popularCourses);
        model.addAttribute("categories", categories);
        model.addAttribute("categoryCourseCount", categoryCourseCount);

        return "home/index"; 
    }

    // --- DEBUGGING ENDPOINT ---
    // Agar index.jsp nahi khul raha, toh http://localhost:8082/test-view hit karo
    @GetMapping("/test-view")
    public String testJsp(Model model) {
        log.info("🔍 Debugging: Testing JSP View Resolver");
        model.addAttribute("msg", "View Resolver is working fine!");
        return "test"; // Path: WEB-INF/views/test.jsp
    }
    
   

    @GetMapping("/go-home")
    public String goHome(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getName())) {
            return "redirect:/auth/login";
        }

        if (authentication.getAuthorities().stream().anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuthority()))) {
            return "redirect:/admin/dashboard";
        }

        if (authentication.getAuthorities().stream().anyMatch(auth -> "ROLE_TEACHER".equals(auth.getAuthority()))) {
            return "redirect:/teacher/dashboard";
        }

        if (authentication.getAuthorities().stream().anyMatch(auth -> "ROLE_STUDENT".equals(auth.getAuthority()))) {
            return "redirect:/student/dashboard";
        }

        return "redirect:/auth/login";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        log.warn("🚫 Access denied request");
        return "error/403";
    }
}
