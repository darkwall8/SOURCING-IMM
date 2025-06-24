package com.sourcing.sourcingimm.models.mappers;

import com.sourcing.sourcingimm.models.StudentAdditionalInfoModel;
import com.sourcing.sourcingimm.models.entities.CompanyAdditionalInformationEntity;
import com.sourcing.sourcingimm.models.entities.StudentAdditionalInformationEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(
        componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE
)
public interface StudentAdditionalInfoMapper {

    StudentAdditionalInfoModel entityToModel(StudentAdditionalInformationEntity entity);

    @Mapping(target = "createAt", ignore = true)
    @Mapping(target = "updateAt", ignore = true)
    StudentAdditionalInformationEntity modelToEntity(StudentAdditionalInfoModel model);

    List<StudentAdditionalInfoModel> entitiesToModels(List<StudentAdditionalInformationEntity> entities);
    List<StudentAdditionalInformationEntity> modelsToEntities(List<StudentAdditionalInfoModel> models);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createAt", ignore = true)
    @Mapping(target = "updateAt" ,ignore = true)
    void updateEntityFromModel(StudentAdditionalInfoModel model, @MappingTarget StudentAdditionalInformationEntity entity);
}
