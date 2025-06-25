package com.sourcing.sourcingimm.services;

import com.sourcing.sourcingimm.models.DTOs.StudentUserCreationRequest;
import com.sourcing.sourcingimm.models.DTOs.StudentUserCreationResponse;
import com.sourcing.sourcingimm.models.StudentAdditionalInfoModel;
import com.sourcing.sourcingimm.utils.exception.DuplicateResourceException;
import com.sourcing.sourcingimm.utils.exception.ValidationException;
import com.sourcing.sourcingimm.models.CompanyAdditionalInfoModel;
import com.sourcing.sourcingimm.models.DTOs.EnterPriseUserCreationRequest;
import com.sourcing.sourcingimm.models.DTOs.EnterpriseUserCreationResponse;
import com.sourcing.sourcingimm.models.UserModel;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * this service is to create a user with additional information directly
 */
@Service
@Transactional
@Slf4j
public class UserCreateCompleteService {

    @Autowired
    private UserService userService;

    @Autowired
    private ProfileEnterpriseService profileEnterpriseService;

    @Autowired
    private ProfileStudentService profileStudentService;

    public EnterpriseUserCreationResponse createCompanyUser(EnterPriseUserCreationRequest request) {

        try {
            if (!request.getUser().getEmail().equals(request.getCompanyInfo().getUserEmail())) {
                throw new ValidationException("Email mismatch between user and company info");
            }

            UserModel createdUser = userService.createUser(request.getUser());

            CompanyAdditionalInfoModel createdCompanyInfo =
                    profileEnterpriseService.addCompanyAdditionalInfo(request.getCompanyInfo());

            return EnterpriseUserCreationResponse.builder()
                    .user(createdUser)
                    .companyInfo(createdCompanyInfo)
                    .message("Company user created successfully")
                    .build();
        } catch (DuplicateResourceException e) {
            log.error(e.getMessage());
            throw new DuplicateResourceException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
            throw new ValidationException(e.getMessage());
        }
    }

    public StudentUserCreationResponse createStudentUser(StudentUserCreationRequest request) {

        try {
            if (!request.getUser().getEmail().equals(request.getStudentInfo().getUserEmail())) {
                throw new ValidationException("Email mismatch between user and company info");
            }

            UserModel createdUser = userService.createUser(request.getUser());

            StudentAdditionalInfoModel createdStudentInfo =
                    profileStudentService.addStudentAdditionalInfo(request.getStudentInfo());

            return StudentUserCreationResponse.builder()
                    .user(createdUser)
                    .studentAdditionalInfo(createdStudentInfo)
                    .message("Student user created successfully")
                    .build();
        } catch (DuplicateResourceException e) {
            log.error(e.getMessage());
            throw new DuplicateResourceException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
            throw new ValidationException(e.getMessage());
        }
    }


}
