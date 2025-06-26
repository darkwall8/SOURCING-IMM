package com.sourcing.sourcingimm.models.entities;

import com.sourcing.sourcingimm.utils.enumerations.CandidacyStatus;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
public class CandidacyEntity {
    private UUID id;
    private String userEmail;
    private UUID offerId;

    private CandidacyStatus status;
    private String coverLetter;
}
