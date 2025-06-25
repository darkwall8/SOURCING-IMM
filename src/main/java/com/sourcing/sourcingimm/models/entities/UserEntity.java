package com.sourcing.sourcingimm.models.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserEntity {
        private String name;
        private String email;
        private UUID profileId;
        private UUID roleId;
        private Boolean hasPremium;
        private Boolean isActivated;
        private LocalDateTime lastLogin;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;

        private ProfileEntity profile;
        private RoleEntity role;
        private StudentAdditionalInformationEntity studentInfo;
        private CompanyAdditionalInformationEntity companyInfo;
}
