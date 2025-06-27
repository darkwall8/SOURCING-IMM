package com.sourcing.sourcingimm.services;

import com.sourcing.sourcingimm.models.ActivitySectorModel;
import com.sourcing.sourcingimm.models.entities.ActivitySectorEntity;
import com.sourcing.sourcingimm.models.mappers.ActivitySectorMapper;
import com.sourcing.sourcingimm.repository.ActivitySectorRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
public class MoreInformationManagementService {

    @Autowired
    private ActivitySectorRepository activitySectorRepository;

    @Autowired
    private ActivitySectorMapper activitySectorMapper;

    @Transactional(readOnly = true)
    public List<ActivitySectorModel> findAllActivitySectors() {
        List<ActivitySectorEntity> entities = activitySectorRepository.getAllActivitySector();
        return activitySectorMapper.entitiesToModels(entities);
    }

}
