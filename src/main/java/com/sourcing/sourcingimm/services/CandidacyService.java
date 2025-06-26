package com.sourcing.sourcingimm.services;

import com.sourcing.sourcingimm.models.CandidacyModel;
import com.sourcing.sourcingimm.models.entities.CandidacyEntity;
import com.sourcing.sourcingimm.models.mappers.CandidacyMappers;
import com.sourcing.sourcingimm.repository.CandidacyRepository;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class CandidacyService {

    @Autowired
    private CandidacyRepository candidacyRepository;

    @Autowired
    private CandidacyMappers candidacyMappers;

    @Transactional(readOnly = true)
    public List<CandidacyModel> getAllCandidacy() {
        List<CandidacyEntity> entities = candidacyRepository.getAllCandidacy();
        return candidacyMappers.entitiesToModels(entities);
    }

    @Transactional(readOnly = true)
    public CandidacyModel getCandidacyById(UUID id) {
        CandidacyEntity entity = candidacyRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("no candidacy"));
        return candidacyMappers.entityToModel(entity);
    }

    public CandidacyModel createCandidacy(CandidacyModel candidacyModel) {
        CandidacyEntity entity = candidacyMappers.modelToEntity(candidacyModel);

        CandidacyEntity savedEntity = candidacyRepository.save(entity);
        return candidacyMappers.entityToModel(savedEntity);
    }

    public CandidacyModel updateCandidacy(UUID id,CandidacyModel candidacyModel) {
        CandidacyEntity existingEntity = candidacyRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("no candidacy"));

        candidacyMappers.updateEntityFromModel(candidacyModel, existingEntity);
        return candidacyMappers.entityToModel(existingEntity);
    }

}
