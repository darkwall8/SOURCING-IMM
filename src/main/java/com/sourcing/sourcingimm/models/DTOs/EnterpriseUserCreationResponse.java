package com.sourcing.sourcingimm.models.DTOs;

import com.sourcing.sourcingimm.models.CompanyAdditionalInfoModel;
import com.sourcing.sourcingimm.models.UserModel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EnterpriseUserCreationResponse {
    private UserModel user;
    private CompanyAdditionalInfoModel companyInfo;
    private String message;
}
