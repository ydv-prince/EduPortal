package com.elearn.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "app")
@Getter
@Setter
public class AppProperties {

    private String baseUrl;
    private String uploadDir;
    private String certificateDir;
    private int tokenExpiryHours = 24;

    private Email email = new Email();

    @Getter @Setter
    public static class Email {
        private String from;
    }
}