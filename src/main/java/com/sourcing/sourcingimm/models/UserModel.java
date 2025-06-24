package com.sourcing.sourcingimm.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserModel {

    private Integer id;

    @NotBlank(message = "The name is required")
    @Size(max = 255, message = "The name can't go further than 255 characters")
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email")
    @Size(max = 255, message = "Email size can't be superior to 255")
    private String email;

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    @Size(min = 8, message = "The password should contain at least 8 character, one upper case , one number and one special character")
    private String password;

    private Integer profileId;
    private String profileName;

    private Integer roleId;
    private String roleName;

    private Boolean hasPremium;
    private Boolean isActivated;
    private LocalDateTime lastLogin;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;


}

// TODO remove id on user