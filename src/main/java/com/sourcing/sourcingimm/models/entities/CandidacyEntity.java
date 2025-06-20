package com.sourcing.sourcingimm.models.entities;

import com.sourcing.sourcingimm.models.DTOs.CandidacyStatus;
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
public class CandidacyEntity {
    private Integer id;
    private Integer userId;
    private Integer offerId;
    private CandidacyStatus status;
    private String coverLetter;
    private Integer resumeFileId;
    private Integer[] additionalDocuments = new Integer[]{};
    private String motivation;
    private Integer expectedSalary;
    private Date availabilityDate;
    private String notes;
    private Integer score;
    private Timestamp appliedAt;
    private Timestamp reviewedAt;
    private Integer reviewerId;
    private Timestamp responseDate;
}
