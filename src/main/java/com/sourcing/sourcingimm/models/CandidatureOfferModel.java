package com.sourcing.sourcingimm.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CandidatureOfferModel {
    private UUID offerId;
    private UUID candidateId;
    private String coverLetter;
    private String status;
}
