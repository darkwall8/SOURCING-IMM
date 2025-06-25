package com.sourcing.sourcingimm.models.entities;

import com.sourcing.sourcingimm.utils.enumerations.AcademicSkillLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OfferRequiredSkill {

    private UUID id;
    private UUID skillId;
    private UUID offerId;
    private Timestamp createdAt;
}
