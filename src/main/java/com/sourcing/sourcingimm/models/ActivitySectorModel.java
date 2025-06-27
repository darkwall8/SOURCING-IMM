package com.sourcing.sourcingimm.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ActivitySectorModel {

    private UUID id;
    private String name;
}
