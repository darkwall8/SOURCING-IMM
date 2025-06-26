package com.sourcing.sourcingimm.models.mappers;

import com.sourcing.sourcingimm.models.CandidacyModel;
import com.sourcing.sourcingimm.models.entities.CandidacyEntity;
import org.mapstruct.Mapper;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(
        componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE
)
public interface CandidacyMappers {

    CandidacyModel entityToModel(CandidacyEntity entity);

    List<CandidacyModel> entitiesToModels(List<CandidacyEntity> entities);

    CandidacyEntity modelToEntity(CandidacyModel model);

    void updateEntityFromModel(CandidacyModel model, CandidacyEntity entity);
}
