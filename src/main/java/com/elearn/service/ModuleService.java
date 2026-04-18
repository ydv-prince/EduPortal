package com.elearn.service;   // ← FIXED: repository tha, service kiya

import com.elearn.dto.ModuleDto;
import com.elearn.model.Course;
import com.elearn.model.CourseModule;
import com.elearn.model.User;
import com.elearn.repository.CourseRepository;
import com.elearn.repository.ModuleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ModuleService {

    private final ModuleRepository moduleRepository;
    private final CourseRepository courseRepository;

    public CourseModule createModule(ModuleDto dto) {
        Course course = courseRepository.findById(dto.getCourseId())
                .orElseThrow(() -> new RuntimeException(
                        "Course not found: " + dto.getCourseId()));

        CourseModule module = new CourseModule();
        module.setTitle(dto.getTitle());
        module.setDescription(dto.getDescription());
        module.setOrderIndex(dto.getOrderIndex() != null
                ? dto.getOrderIndex() : 0);
        module.setCourse(course);

        return moduleRepository.save(module);
    }

    // ← TeacherController addModule(String, Course) call karta tha
    public CourseModule addModule(String title, Course course) {
        CourseModule module = new CourseModule();
        module.setTitle(title);
        module.setOrderIndex(
            (int) moduleRepository.countByCourseId(course.getId()));
        module.setCourse(course);
        return moduleRepository.save(module);
    }
    
 // --- 1. TeacherController ke liye FIXED method ---
    @Transactional(readOnly = true)
    public List<CourseModule> findAll() {
        return moduleRepository.findAll();
    }

    public CourseModule updateModule(Long id, ModuleDto dto) {
        CourseModule module = getModuleById(id);
        module.setTitle(dto.getTitle());
        module.setDescription(dto.getDescription());
        if (dto.getOrderIndex() != null) {
            module.setOrderIndex(dto.getOrderIndex());
        }
        return moduleRepository.save(module);
    }

    public void deleteModule(Long id) {
        moduleRepository.deleteById(id);
    }
 // ModuleService.java
    @Transactional(readOnly = true)
    public List<CourseModule> getModulesByTeacher(User teacher) {
        // Instructor field aapke Course model mein honi chahiye
        return moduleRepository.findByCourse_Instructor(teacher);
    }
    
 // ModuleService.java
    public void createModule(Long courseId, String title) {
        // 1. Course fetch karein (CourseService ka use karke)
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));

        // 2. Naya Module object banayein
        CourseModule module = new CourseModule();
        module.setTitle(title);
        module.setCourse(course);
        
        // 3. Order Index set karein (Optional: automatically last + 1 kar sakte ho)
     // nextOrder ko long kar do
        long nextOrder = moduleRepository.countByCourseId(courseId) + 1;
        module.setOrderIndex((int) nextOrder); // setOrderIndex int mangta hai toh yahan cast karein

        // 4. Save karein
        moduleRepository.save(module);
    }
    
 // ModuleService.java

    public void updateModule(Long moduleId, String title) {
        // 1. Pehle module ko database se fetch karein
        CourseModule module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not found"));

        // 2. Title update karein
        module.setTitle(title);

        // 3. Save karein
        moduleRepository.save(module);
    }

    @Transactional(readOnly = true)
    public CourseModule getModuleById(Long id) {
        return moduleRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Module not found: " + id));
    }

    @Transactional(readOnly = true)
    public List<CourseModule> getModulesByCourse(Long courseId) {
        return moduleRepository
                .findByCourseIdOrderByOrderIndexAsc(courseId);
    }
}