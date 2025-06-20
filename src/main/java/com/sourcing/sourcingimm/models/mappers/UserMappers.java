package com.sourcing.sourcingimm.models.mappers;

import com.sourcing.sourcingimm.models.UserModel;
import com.sourcing.sourcingimm.models.entities.UserEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(
        componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        uses = {StudentAdditionalInfoMapper.class, CompanyAdditionalInfoMapper.class}
)
public interface UserMappers {

    @Mapping(target = "profileName", source = "profile.name")
    @Mapping(target = "roleName", source = "role.name")
    @Mapping(target = "studentInfo", source = "studentInfo")
    @Mapping(target = "companyInfo", source = "companyInfo")
    UserModel entityToModel(UserEntity entity);

    @Mapping(target = "profile", ignore = true)
    @Mapping(target = "role", ignore = true)
    @Mapping(target = "studentInfo", ignore = true)
    @Mapping(target = "companyInfo", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    UserEntity modelToEntity(UserModel model);

    List<UserModel> entitiesToModels(List<UserEntity> entities);

    void updateEntityFromModel(UserModel model, @MappingTarget UserEntity entity);

}
