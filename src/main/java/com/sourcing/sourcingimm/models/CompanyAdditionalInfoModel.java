package com.sourcing.sourcingimm.models;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CompanyAdditionalInfoModel {
//TODO: add constraint related  to siret and others
    private UUID id;

    private String userEmail;

    @NotBlank(message = "The company name is required")
    @Size(max = 255, message = "The company name can't containt more than 255 characters")
    private String companyName;


    private String industry;
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
