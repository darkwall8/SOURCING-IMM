package com.sourcing.sourcingimm.models.entities;

import com.sourcing.sourcingimm.models.DTOs.OfferStatus;
import jakarta.persistence.Column;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OfferEntity {
    private Integer id;
    private String title;
    private Integer companyId;
    private OfferStatus status;
    private String location;
    private Boolean remotePossible = false;
    private Integer salaryMin;
    private Integer salaryMax;
    @Column(length = 3, nullable = false)
    @Size(max = 3)
    private String currency = "EUR";
    private Integer durationMonths;
    private Date startDate;
    private Date endDate;
    private Date limitDate;
    private boolean isRemunerated = true;
    @Column(length = 100, nullable = false)
    @Size(max = 100)
    private String requiredLevel;
    private String text;
    private String applicationProcess;
    private Integer viewsCount = 0;
    private Integer applicationsCount = 0;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp publishedAt;
}
