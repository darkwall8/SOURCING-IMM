package com.sourcing.sourcingimm.models.mappers;

import com.sourcing.sourcingimm.models.CandidatureOfferModel;
import com.sourcing.sourcingimm.models.entities.CandidatureOfferEntity;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(
        componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE
)
public interface CandidatureOfferMapper {
    CandidatureOfferModel entityToModel(CandidatureOfferEntity entity);

    List<CandidatureOfferModel> entitiesToModels(List<CandidatureOfferEntity> entities);

    CandidatureOfferEntity modelToEntity(CandidatureOfferModel model);

    void updateEntityFromModel(CandidatureOfferModel model, @MappingTarget CandidatureOfferEntity entity);
}
