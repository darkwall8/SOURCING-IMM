package com.sourcing.sourcingimm.models;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserModel {

    @NotBlank(message = "The name is required")
    @Size(max = 255, message = "The name can't go further than 255 characters")
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email")
    @Size(max = 255, message = "Email size can't be superior to 255")
    private String email;


    private UUID profileId;
    private String profileName;

    private UUID roleId;
    private String roleName;

    private Boolean hasPremium;
    private Boolean isActivated;


}

