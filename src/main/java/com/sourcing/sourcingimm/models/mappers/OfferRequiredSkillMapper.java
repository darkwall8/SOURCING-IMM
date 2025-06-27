package com.sourcing.sourcingimm.models.mappers;

import com.sourcing.sourcingimm.models.OfferRequiredSkillModel;
import com.sourcing.sourcingimm.models.entities.OfferRequiredSkillEntity;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(
        componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE
)
public interface OfferRequiredSkillMapper {
    OfferRequiredSkillModel entityToModel(OfferRequiredSkillEntity entity);

    List<OfferRequiredSkillModel> entitiesToModels(List<OfferRequiredSkillEntity> entities);

    OfferRequiredSkillEntity modelToEntity(OfferRequiredSkillModel model);

    void updateEntityFromModel(OfferRequiredSkillModel model, @MappingTarget OfferRequiredSkillEntity entity);
}
