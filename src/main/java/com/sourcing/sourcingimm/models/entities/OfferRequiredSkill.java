package com.sourcing.sourcingimm.models.entities;

import com.sourcing.sourcingimm.models.DTOs.AcademicSkillLevel;
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
    private boolean isMandatory = true;
    private Integer weight = 1;
    private Timestamp createdAt;
}
