package com.sourcing.sourcingimm.models.entities;

import com.sourcing.sourcingimm.utils.enumerations.OfferStatus;
import jakarta.persistence.Column;
import jakarta.validation.constraints.Size;
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
public class OfferEntity {

    private UUID id;
    private String companyEmail;
    private String period;
    private Boolean isCustomOffer;
    private String receiverEmail;
    private String userEmail;

    @Builder.Default
    private Boolean isRemunerated = true;

    private Date limitDate;
    private String location;
    private String description;
    private String title;

    private Timestamp createdAt;
    private Timestamp updatedAt;
}