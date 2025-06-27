package com.sourcing.sourcingimm.services;


import com.sourcing.sourcingimm.models.CandidacyModel;
import com.sourcing.sourcingimm.models.CandidatureOfferModel;
import com.sourcing.sourcingimm.models.entities.CandidacyEntity;
import com.sourcing.sourcingimm.models.entities.CandidatureOfferEntity;
import com.sourcing.sourcingimm.models.mappers.CandidatureOfferMapper;
import com.sourcing.sourcingimm.repository.CandidatureOfferRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class CandidacyOfferService {

    @Autowired
    private CandidatureOfferRepository repository;


    private CandidatureOfferMapper mapper;

    @Transactional(readOnly = true)
    public List<CandidatureOfferModel> findAll() {
        List<CandidatureOfferEntity> candidatureOfferEntities = repository.findAll();
        return mapper.entitiesToModels(candidatureOfferEntities);
    }

    public CandidatureOfferModel createCandidacy(CandidatureOfferModel model) {
        CandidatureOfferEntity entity = mapper.modelToEntity(model);

        CandidatureOfferEntity savedEntity = repository.save(entity);
        return mapper.entityToModel(savedEntity);
    }

    public CandidatureOfferModel updateCandidacy(UUID offerId, UUID candidacyId, CandidatureOfferModel candidacyModel) {
        CandidatureOfferEntity existingEntity = repository.findById(offerId, candidacyId)
                .orElseThrow(() -> new ResourceNotFoundException("no candidacy"));

        mapper.updateEntityFromModel(candidacyModel, existingEntity);
        return mapper.entityToModel(existingEntity);
    }
}
