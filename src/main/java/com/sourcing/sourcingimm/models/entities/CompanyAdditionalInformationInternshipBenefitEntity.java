package com.sourcing.sourcingimm.models.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CompanyAdditionalInformationInternshipBenefitEntity {

    private UUID companyAdditionalInformationId;
    private String internshipBenefit;
}
