package com.elearn.dto;

import com.elearn.model.enums.CourseLevel;
import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.math.BigDecimal;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class CourseCreateDto {

    @NotBlank(message = "Course title required hai")
    @Size(min = 5, max = 200)
    private String title;

    @NotBlank(message = "Description required hai")
    private String description;

    private String whatYoullLearn;

    @NotNull(message = "Price required hai")
    @DecimalMin(value = "0.0", message = "Price negative nahi ho sakti")
    private BigDecimal price;

    private BigDecimal discountPrice;

    @NotNull(message = "Level select karo")
    private CourseLevel level;

    private String language;

    @NotNull(message = "Category select karo")
    private Long categoryId;

    private MultipartFile thumbnailFile;
    private String previewVideoUrl;
}