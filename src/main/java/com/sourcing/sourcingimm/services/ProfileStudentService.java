package com.sourcing.sourcingimm.services;

import com.sourcing.sourcingimm.utils.exception.DuplicateResourceException;
import com.sourcing.sourcingimm.models.StudentAdditionalInfoModel;
import com.sourcing.sourcingimm.models.entities.StudentAdditionalInformationEntity;
import com.sourcing.sourcingimm.models.mappers.StudentAdditionalInfoMapper;
import com.sourcing.sourcingimm.repository.StudentAdditionalInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

@Service
@Transactional
public class ProfileStudentService {

    private StudentAdditionalInfoMapper mapper;

    @Autowired
    private StudentAdditionalInfoRepository repository;

    @Transactional(readOnly = true)
    public StudentAdditionalInfoModel getStudentAdditionalInfoByUserEmail(String email) {
        StudentAdditionalInformationEntity entity = repository.findByUserEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Additional information not found for this student maybe this user isn't a student" + email));
        return mapper.entityToModel(entity);
    }

    public StudentAdditionalInfoModel addStudentAdditionalInfo(StudentAdditionalInfoModel model) {
        if (repository.existByUserEmail(model.getUserEmail())) {
            throw new DuplicateResourceException();
        }

        StudentAdditionalInformationEntity entity = mapper.modelToEntity(model);

        StudentAdditionalInformationEntity savedEntity = repository.save(entity);
        return mapper.entityToModel(savedEntity);
    }

    public StudentAdditionalInfoModel updateCompanyAdditionalInfo(String userEmail, StudentAdditionalInfoModel model) {
        StudentAdditionalInformationEntity existingEntity = repository.findByUserEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Additional information not found for this enterprise maybe this user isn't an enterprise" + userEmail));

        mapper.updateEntityFromModel(model, existingEntity);

        StudentAdditionalInformationEntity savedEntity = repository.save(existingEntity);
        return mapper.entityToModel(savedEntity);
    }
}
