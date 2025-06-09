package com.sourcing.sourcingimm.models.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserEntity {
        private Integer id;
        private String name;
        private String email;
        private String password;
        private Integer profileId;
        private Integer roleId;
        private Boolean hasPremium;
        private Boolean isActivated;
        private LocalDateTime lastLogin;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;

        // Entités liées
//        private ProfileEntity profile;
//        private RoleEntity role;
//        private StudentAdditionalInfoEntity studentInfo;
//        private CompanyAdditionalInfoEntity companyInfo;
}
