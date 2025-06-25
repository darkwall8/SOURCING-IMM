package com.sourcing.sourcingimm.models.DTOs;

import com.sourcing.sourcingimm.models.StudentAdditionalInfoModel;
import com.sourcing.sourcingimm.models.UserModel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentUserCreationResponse {
    private UserModel user;
    private StudentAdditionalInfoModel studentAdditionalInfo;
    private String message;
}
