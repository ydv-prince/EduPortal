package com.elearn.service;

import com.elearn.dto.LessonDto;
import com.elearn.model.CourseModule;
import com.elearn.model.Lesson;
import com.elearn.repository.LessonRepository;
import com.elearn.repository.ModuleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class LessonService {

    private final LessonRepository lessonRepository;
    private final ModuleRepository moduleRepository;

    /**
     * Complete Method: Video Link, Video File aur PDF Upload handle karne ke liye
     */
    public void createLessonWithFiles(Long moduleId, String title, int duration, String videoUrl, 
                                     String content, MultipartFile videoFile, MultipartFile pdfFile) throws IOException {
        
        CourseModule module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not found"));

        Lesson lesson = new Lesson();
        lesson.setTitle(title);
        lesson.setDurationMinutes(duration);
        lesson.setContent(content);
        lesson.setModule(module);

        // 1. Handle Video (Priority: Uploaded File > Embed Link)
        if (videoFile != null && !videoFile.isEmpty()) {
            String videoPath = saveToDisk(videoFile, "uploads/videos");
            lesson.setVideoUrl(videoPath); 
        } else {
            lesson.setVideoUrl(videoUrl); 
        }

        // 2. Handle PDF Notes
        if (pdfFile != null && !pdfFile.isEmpty()) {
            String pdfPath = saveToDisk(pdfFile, "uploads/docs");
            lesson.setPdfUrl(pdfPath); 
        }

        lessonRepository.save(lesson);
    }
    
    public String sanitizeYoutubeUrl(String url) {
        if (url != null && url.contains("watch?v=")) {
            return url.replace("watch?v=", "embed/");
        }
        return url;
    }

    /**
     * DTO based lesson creation (Standard)
     * Added 'throws IOException' to handle saveToDisk call
     */
    public Lesson createLesson(LessonDto dto) throws IOException {
        CourseModule module = moduleRepository.findById(dto.getModuleId())
                .orElseThrow(() -> new RuntimeException("Module not found"));

        String resourceUrl = null;
        if (dto.getResourceFile() != null && !dto.getResourceFile().isEmpty()) {
            resourceUrl = saveToDisk(dto.getResourceFile(), "uploads/resources");
        }

        Lesson lesson = new Lesson();
        lesson.setTitle(dto.getTitle());
        lesson.setContent(dto.getContent());
        lesson.setVideoUrl(dto.getVideoUrl());
        lesson.setResourceUrl(resourceUrl);
        lesson.setDurationMinutes(dto.getDurationMinutes());
        lesson.setOrderIndex(dto.getOrderIndex() != null ? dto.getOrderIndex() : 0);
        lesson.setFreePreview(dto.isFreePreview());
        lesson.setModule(module);

        return lessonRepository.save(lesson);
    }

    /**
     * File saving logic (Helper)
     */
    private String saveToDisk(MultipartFile file, String uploadDir) throws IOException {
        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path uploadPath = Paths.get(uploadDir);

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        try (InputStream inputStream = file.getInputStream()) {
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
            return "/" + uploadDir + "/" + fileName; 
        }
    }

    @Transactional(readOnly = true)
    public Lesson getLessonById(Long id) {
        return lessonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Lesson not found: " + id));
    }

    @Transactional(readOnly = true)
    public List<Lesson> getLessonsByModule(Long moduleId) {
        return lessonRepository.findByModuleIdOrderByOrderIndexAsc(moduleId);
    }

    @Transactional(readOnly = true)
    public List<Lesson> getAllLessonsByCourse(Long courseId) {
        return lessonRepository.findAllByCourseId(courseId);
    }

    public void updateLesson(Long lessonId, String title, Integer durationMinutes, String content, String videoUrl) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Lesson not found"));

        lesson.setTitle(title);
        lesson.setDurationMinutes(durationMinutes);
        lesson.setContent(content);
        lesson.setVideoUrl(videoUrl);

        lessonRepository.save(lesson);
    }

    public void deleteLesson(Long id) {
        if (lessonRepository.existsById(id)) {
            lessonRepository.deleteById(id);
        } else {
            throw new RuntimeException("Lesson not found with ID: " + id);
        }
    }
}
