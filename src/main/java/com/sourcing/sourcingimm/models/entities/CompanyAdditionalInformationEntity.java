package com.sourcing.sourcingimm.models.entities;

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
public class CompanyAdditionalInformationEntity {
    private UUID id;
    private String userEmail;
    private String companyName;
    /**
     * secteur d'activité
     */
    private UUID companyActivitySectorId;
    private String companySize;
    private String website;
    private String description;
    private String address;
    private String contactPhone;
    private String companyCorporate;
    private String companyRCCM;
    private String companyNIU;
    private String companyCommercialRegister;
    private String companyLegalStatus;
    private String companyTaxConformityCertificate;
    private String companyStaticDeclarationNumber;
    private Integer companyInternshipDuration;
    private Boolean companyHasInternOpportunity;
    private Timestamp createdAt;
    private Timestamp updatedAt;


}
