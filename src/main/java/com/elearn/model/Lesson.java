package com.elearn.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "lessons")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Lesson {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String content;

    private String videoUrl;
    private String resourceUrl;

    @Column(nullable = false)
    @Builder.Default
    private Integer orderIndex = 0;
    
 // Lesson.java mein ye field add karein
    @Column(length = 500)
    private String pdfUrl;

    // Agar aap Lombok use kar rahe hain toh @Data kaafi hai, 
    // warna niche diye gaye Getter aur Setter manually add karein:

    public String getPdfUrl() {
        return pdfUrl;
    }

    public void setPdfUrl(String pdfUrl) {
        this.pdfUrl = pdfUrl;
    }

    private Integer durationMinutes;

    private boolean freePreview = false;   // "isFreePreview" → "freePreview"

    @ToString.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "module_id", nullable = false)
    private CourseModule module;           // Module → CourseModule

    @ToString.Exclude
    @OneToMany(mappedBy = "lesson", cascade = CascadeType.ALL,
               fetch = FetchType.LAZY)
    @Builder.Default
    private List<Progress> progressList = new ArrayList<>();

    @CreationTimestamp
    private LocalDateTime createdAt;
}