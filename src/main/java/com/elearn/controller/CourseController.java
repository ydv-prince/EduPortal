package com.elearn.controller;

import com.elearn.model.Course;
import com.elearn.model.CourseModule;
import com.elearn.model.User;
import com.elearn.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/courses")
@RequiredArgsConstructor
public class CourseController {

    private final CourseService courseService;
    private final CategoryService categoryService;
    private final EnrollmentService enrollmentService;
    private final ReviewService reviewService;
    private final UserService userService;
    private final ModuleService moduleService;

    // ── Browse All Courses ──
    @GetMapping
    public String browseCourses(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            Model model) {

        List<Course> courses;

        if (keyword != null && !keyword.isBlank()) {
            courses = courseService.searchCourses(keyword);
            model.addAttribute("keyword", keyword);
        } else if (categoryId != null) {
            courses = courseService.getCoursesByCategory(categoryId);
            model.addAttribute("selectedCategoryId", categoryId);
        } else {
            // ✅ Sahi method call jo humne Service mein add kiya tha
            courses = courseService.getAllApprovedCourses(); 
        }

        model.addAttribute("courses", courses);
        model.addAttribute("categories", categoryService.getAllCategories());

        return "student/browse-courses";
    }

    // ── Course Detail Page ──
    @GetMapping("/{id}")
    public String courseDetail(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model) {

        Course course = courseService.getCourseById(id);
        
        // Modules load karein detail page par dikhane ke liye (Syllabus section)
        List<CourseModule> modules = moduleService.getModulesByCourse(id);
        
        model.addAttribute("course", course);
        model.addAttribute("modules", modules);
        model.addAttribute("reviews", reviewService.getCourseReviews(id));
        model.addAttribute("avgRating", reviewService.getAverageRating(id));

        // Check if user is logged in and enrolled
        if (userDetails != null) {
            User user = userService.getUserByEmail(userDetails.getUsername());
            boolean enrolled = enrollmentService.isEnrolled(user, course);
            model.addAttribute("isEnrolled", enrolled);
            model.addAttribute("currentUser", user);
        } else {
            model.addAttribute("isEnrolled", false);
        }

        return "student/course-detail";
    }

    // ── Teacher Side: Course Builder ──
    @GetMapping("/builder/{id}")
    public String showCourseBuilder(@PathVariable Long id, Model model) {
        Course course = courseService.getCourseById(id);
        List<CourseModule> modules = moduleService.getModulesByCourse(id);
        
        // Force load assignments to avoid LazyInitializationException
        modules.forEach(m -> m.getAssignments().size()); 

        model.addAttribute("course", course);
        model.addAttribute("modules", modules);
        return "teacher/course-builder"; 
    }
}