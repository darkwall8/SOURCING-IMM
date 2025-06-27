package com.sourcing.sourcingimm.models.mappers;

import com.sourcing.sourcingimm.models.ActivitySectorModel;
import com.sourcing.sourcingimm.models.entities.ActivitySectorEntity;
import org.mapstruct.Mapper;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(
        componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE
)
public interface ActivitySectorMapper {

    List<ActivitySectorModel> entitiesToModels(List<ActivitySectorEntity> entities);
}
