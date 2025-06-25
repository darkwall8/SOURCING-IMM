package com.sourcing.sourcingimm.models.DTOs;

import com.sourcing.sourcingimm.models.CompanyAdditionalInfoModel;
import com.sourcing.sourcingimm.models.UserModel;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EnterPriseUserCreationRequest {
    @Valid
    @NotNull
    private UserModel user;

    @Valid
    @NotNull
    private CompanyAdditionalInfoModel companyInfo;
}
