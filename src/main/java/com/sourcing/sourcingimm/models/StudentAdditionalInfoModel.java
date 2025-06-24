package com.sourcing.sourcingimm.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.Date;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class StudentAdditionalInfoModel {

    private UUID id;
    private String userEmail;
    private Integer graduationYear;
    private String university;
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
