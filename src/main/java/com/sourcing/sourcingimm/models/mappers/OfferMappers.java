package com.sourcing.sourcingimm.models.mappers;

import com.sourcing.sourcingimm.models.CandidatureOfferModel;
import com.sourcing.sourcingimm.models.OfferModel;
import com.sourcing.sourcingimm.models.entities.CandidatureOfferEntity;
import com.sourcing.sourcingimm.models.entities.OfferEntity;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(
        componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE
)
public interface OfferMappers {
    OfferModel entityToModel(OfferEntity entity);

    List<OfferModel> entitiesToModels(List<OfferEntity> entities);

    OfferEntity modelToEntity(OfferModel model);

    void updateEntityFromModel(OfferModel model, @MappingTarget OfferEntity entity);
}
