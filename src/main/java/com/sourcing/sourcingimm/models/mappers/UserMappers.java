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

    // Conversion UserModel -> UserEntity
    @Mapping(target = "role", ignore = true)
    @Mapping(target = "studentInfo", ignore = true)
    @Mapping(target = "companyInfo", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "lastLogin", ignore = true)
    UserEntity modelToEntity(UserModel model);

    // Conversion UserEntity -> UserModel (MÉTHODE MANQUANTE)
    @Mapping(target = "profile", source = "profile")
    UserModel entityToModel(UserEntity entity);

    // Conversion List<UserEntity> -> List<UserModel>
    List<UserModel> entitiesToModels(List<UserEntity> entities);

    // Mise à jour d'une entité à partir d'un modèle
    @Mapping(target = "role", ignore = true)
    @Mapping(target = "studentInfo", ignore = true)
    @Mapping(target = "companyInfo", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "lastLogin", ignore = true)
    void updateEntityFromModel(UserModel model, @MappingTarget UserEntity entity);
}