package com.sourcing.sourcingimm.models.DTOs;

import com.sourcing.sourcingimm.models.StudentAdditionalInfoModel;
import com.sourcing.sourcingimm.models.UserModel;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentUserCreationRequest {
    @Valid
    @NotNull
    private UserModel user;

    @Valid
    @NotNull
    private StudentAdditionalInfoModel studentInfo;
}
