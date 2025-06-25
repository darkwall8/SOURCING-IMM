package com.sourcing.sourcingimm.models;

import com.sourcing.sourcingimm.utils.enumerations.CandidacyStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.Date;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CandidacyModel {

    private UUID id;
    private String userEmail;
    private UUID offerId;
    private CandidacyStatus status;
    private String coverLetter;
    private UUID resumeFileId;
    @Builder.Default
    private Integer[] additionalDocuments = new Integer[]{};
    private String motivation;
    private Integer expectedSalary;
    private Date availabilityDate;
    private String notes;
    private Integer score;
    private Timestamp appliedAt;
    private Timestamp reviewedAt;
    private String reviewedByEmail;
    private Timestamp responseDate;


}
