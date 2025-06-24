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
    private String siret;
    private String industry;
    private String companySize;
    private String website;
    private String description;
    private String address;
    private String contactPerson;
    private String contactPhone;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
