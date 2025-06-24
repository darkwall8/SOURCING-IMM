package com.sourcing.sourcingimm.models.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentAdditionalInformation {
    private Integer id;
    private Integer userId;
    private String university;
    private String currentLevel;
    private String portfolioUrl;
    private String githubUrl;
    private String linkedinUrl;
    private String phone;
    private String address;
    private String bio;
    private Date availibilityDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
