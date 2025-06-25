package com.sourcing.sourcingimm.models.mappers;

import com.sourcing.sourcingimm.models.CompanyAdditionalInfoModel;
import com.sourcing.sourcingimm.models.entities.CompanyAdditionalInformationEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(
        componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE
)
public interface CompanyAdditionalInfoMapper {

    CompanyAdditionalInfoModel entityToModel(CompanyAdditionalInformationEntity entity);

    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    CompanyAdditionalInformationEntity modelToEntity(CompanyAdditionalInfoModel model);

    List<CompanyAdditionalInfoModel> entitiesToModels(List<CompanyAdditionalInformationEntity> entities);

    List<CompanyAdditionalInformationEntity> modelsToEntities(List<CompanyAdditionalInfoModel> models);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    void updateEntityFromModel(CompanyAdditionalInfoModel model, @MappingTarget CompanyAdditionalInformationEntity entity);
}