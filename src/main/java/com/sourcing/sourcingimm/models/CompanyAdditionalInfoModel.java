package com.sourcing.sourcingimm.models;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CompanyAdditionalInfoModel {
//TODO: add constraint related  to siret and others
    private Integer id;

    @NotBlank(message = "The company name is required")
    @Size(max = 255, message = "The company name can't containt more than 255 characters")
    private String companyName;

    @NotBlank(message = "This information is required")
    private String siret;

    @NotBlank(message = "This information is required")
    private String industry;

    @NotBlank(message = "This information is required")
    private String companySize;

    private String website;
    private String description;

    @NotBlank(message = "This information is required")
    private String address;

    @NotBlank(message = "This information is required")
    private String contactPerson;

    @NotBlank(message = "This information is required")
    private String contactPhone;

    private Timestamp createdAt;
    private Timestamp updatedAt;

}
