//package com.elearn;
//
//import org.springframework.boot.SpringApplication;
//import org.springframework.boot.autoconfigure.SpringBootApplication;
//import org.springframework.boot.builder.SpringApplicationBuilder;
//import org.springframework.boot.web.servlet.support
//        .SpringBootServletInitializer;
//import org.springframework.scheduling.annotation.EnableAsync;
//
//@SpringBootApplication
//@EnableAsync
//public class ElearnApplication
//        extends SpringBootServletInitializer {
//
//    @Override
//    protected SpringApplicationBuilder configure(
//            SpringApplicationBuilder builder) {
//        return builder.sources(ElearnApplication.class);
//    }
//
//    public static void main(String[] args) {
//        SpringApplication.run(
//            ElearnApplication.class, args);
//    }
//}

package com.elearn;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support
        .SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class ElearnApplication
        extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(
            SpringApplicationBuilder builder) {
        return builder.sources(ElearnApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(
            ElearnApplication.class, args);
    }
}



