package com.sourcing.sourcingimm.services;

import com.sourcing.sourcingimm.models.CandidacyModel;
import com.sourcing.sourcingimm.models.OfferModel;
import com.sourcing.sourcingimm.models.entities.CandidacyEntity;
import com.sourcing.sourcingimm.models.entities.OfferEntity;
import com.sourcing.sourcingimm.models.mappers.CandidacyMappers;
import com.sourcing.sourcingimm.models.mappers.OfferMappers;
import com.sourcing.sourcingimm.repository.CandidacyRepository;
import com.sourcing.sourcingimm.repository.OfferRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class OfferService {

    @Autowired
    private OfferRepository repository;

    @Autowired
    private OfferMappers mappers;

    @Transactional(readOnly = true)
    public List<OfferModel> getAllOffers() {
        List<OfferEntity> entities = repository.getAllOffers();
        return mappers.entitiesToModels(entities);
    }

    @Transactional(readOnly = true)
    public OfferModel getOfferById(UUID id) {
        OfferEntity entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("no candidacy"));
        return mappers.entityToModel(entity);
    }

    public OfferModel createCandidacy(OfferModel model) {
        OfferEntity entity = mappers.modelToEntity(model);

        OfferEntity savedEntity = repository.save(entity);
        return mappers.entityToModel(savedEntity);
    }

    public OfferModel updateOffer(UUID id,OfferModel model) {
        OfferEntity existingEntity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("no candidacy"));

        mappers.updateEntityFromModel(model, existingEntity);
        return mappers.entityToModel(existingEntity);
    }
}
