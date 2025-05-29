package com.sourcing.sourcingimm.models.DTOs;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;

import java.time.Instant;

public record UserDto(

        @NotBlank(message = "Name is required")
        String name,

        @NotBlank(message = "School level is required")
        String schoolLevel,

        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern =  "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")
        Instant createAt,

        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")
        Instant updatedAt
) {
        public static UserDto create(String email, String name) {
                return new UserDto(email, name, null, null);
        }
}
