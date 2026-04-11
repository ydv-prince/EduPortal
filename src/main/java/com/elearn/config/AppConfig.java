package com.elearn.config;

import jakarta.annotation.PostConstruct;
	
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@Configuration
public class AppConfig implements WebMvcConfigurer {

    @Value("${app.upload-dir:uploads/}")
    private String uploadDir;

    @Value("${app.certificate-dir:certificates/}")
    private String certificateDir;
    
 // ✅ JSP ViewResolver — MANUALLY define karo
    @Bean
    public ViewResolver jspViewResolver() {
        InternalResourceViewResolver resolver =
            new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setOrder(1);
        return resolver;
    }

    @Override
    public void addResourceHandlers(
            ResourceHandlerRegistry registry) {

        // ✅ Static files — webapp/static/ se serve hoga
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");

        // Uploaded files
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(
                    "file:" + uploadDir);

        // Certificates
        registry.addResourceHandler("/certificates/**")
                .addResourceLocations(
                    "file:" + certificateDir);
    }

    @PostConstruct
    public void createDirectories() {
        try {
            Files.createDirectories(
                Paths.get(uploadDir));
            Files.createDirectories(
                Paths.get(uploadDir + "thumbnails/"));
            Files.createDirectories(
                Paths.get(uploadDir + "profiles/"));
            Files.createDirectories(
                Paths.get(certificateDir));
            System.out.println(
                "✅ Upload directories created");
        } catch (IOException e) {
            System.err.println(
                "❌ Directory error: " + e.getMessage());
        }
    }
}