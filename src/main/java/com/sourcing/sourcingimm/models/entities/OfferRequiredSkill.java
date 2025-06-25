package com.sourcing.sourcingimm.models.entities;

import com.sourcing.sourcingimm.utils.enumerations.AcademicSkillLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OfferRequiredSkill {
    private Integer id;
    private Integer offerId;
    private Integer skillId;
    private AcademicSkillLevel requiredLevel;

    @Builder.Default
    private boolean isMandatory = true;

    @Builder.Default
    private Integer weight = 1;

    private Timestamp createdAt;
}
