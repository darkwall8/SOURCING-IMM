package com.sourcing.sourcingimm.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OfferRequiredSkillModel {

    private UUID id;
    private UUID skillId;
    private UUID offerId;
    private Timestamp createdAt;
}
