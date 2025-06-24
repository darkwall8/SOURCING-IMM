package com.sourcing.sourcingimm.models.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.Date;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentAdditionalInformationEntity {
    private UUID id;
    private String userEmail;
    private String university;
    private Integer graduationYear;
    private String currentLevel;
    private String portfolioUrl;
    private String githubUrl;
    private String linkedinUrl;
    private String phone;
    private String address;
    private String bio;
    private LocalDate availabilityDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
