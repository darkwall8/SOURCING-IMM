package com.sourcing.sourcingimm.services;

import com.sourcing.sourcingimm.utils.exception.DuplicateResourceException;
import com.sourcing.sourcingimm.models.CompanyAdditionalInfoModel;
import com.sourcing.sourcingimm.models.entities.CompanyAdditionalInformationEntity;
import com.sourcing.sourcingimm.models.mappers.CompanyAdditionalInfoMapper;
import com.sourcing.sourcingimm.repository.CompanyAdditionalRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;

@Service
@Transactional
public class ProfileEnterpriseService {


    private CompanyAdditionalInfoMapper mapper;

    @Autowired
    private CompanyAdditionalRepository companyAdditionalRepository;

    @Transactional(readOnly = true)
    public CompanyAdditionalInfoModel getCompanyAdditionalInfoByUserEmail(String email) {
        CompanyAdditionalInformationEntity entity = companyAdditionalRepository.findByUserEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Additional information not found for this enterprise maybe this user isn't an enterprise" + email));
        return mapper.entityToModel(entity);
    }

    public CompanyAdditionalInfoModel addCompanyAdditionalInfo(CompanyAdditionalInfoModel model) {
        if (companyAdditionalRepository.existByUserEmail(model.getUserEmail())) {
            throw new DuplicateResourceException();
        }

        CompanyAdditionalInformationEntity entity = mapper.modelToEntity(model);

        CompanyAdditionalInformationEntity savedEntity = companyAdditionalRepository.save(entity);
        return mapper.entityToModel(savedEntity);
    }

    public CompanyAdditionalInfoModel updateCompanyAdditionalInfo(String userEmail, CompanyAdditionalInfoModel model) {
        CompanyAdditionalInformationEntity existingEntity = companyAdditionalRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Additional information not found for this enterprise maybe this user isn't an enterprise" + userEmail));

        mapper.updateEntityFromModel(model, existingEntity);

        CompanyAdditionalInformationEntity savedEntity = companyAdditionalRepository.save(existingEntity);
        return mapper.entityToModel(savedEntity);
    }
}
