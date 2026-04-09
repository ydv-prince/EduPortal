package com.elearn.dto;

import com.elearn.model.enums.Role;
import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class UserRegistrationDto {

    @NotBlank(message = "Full name required hai")
    @Size(min = 2, max = 100)
    private String fullName;

    @NotBlank(message = "Email required hai")
    @Email(message = "Valid email daalein")
    private String email;

    @NotBlank(message = "Password required hai")
    @Size(min = 6, message = "Password kam se kam 6 characters ka hona chahiye")
    private String password;

    @NotBlank(message = "Confirm password required hai")
    private String confirmPassword;

    @NotNull(message = "Role select karo")
    private Role role; // STUDENT ya TEACHER

    // Password match check
    public boolean isPasswordMatching() {
        return password != null && password.equals(confirmPassword);
    }
}