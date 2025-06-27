package com.sourcing.sourcingimm.models;

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
public class OfferModel {

    private UUID id;
    private String companyEmail;
    private String period;
    private Boolean isCustomOffer;
    private String receiverEmail;
    private String userEmail;

    private Boolean isRemunerated;

    private Date limitDate;
    private String location;
    private String description;
    private String title;

    private Timestamp createdAt;
    private Timestamp updatedAt;
}
