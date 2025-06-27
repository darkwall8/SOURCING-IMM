package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.models.entities.ActivitySectorEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.sourcing.sourcingimm.generated.user_management.Tables.ACTIVITY_SECTOR;

@Repository
public class ActivitySectorRepository {

    @Autowired
    private DSLContext dsl;

    public List<ActivitySectorEntity> getAllActivitySector() {
        return dsl.select(
                ACTIVITY_SECTOR.NAME,
                ACTIVITY_SECTOR.ID
        )
                .from(ACTIVITY_SECTOR)
                .fetchInto(ActivitySectorEntity.class);
    }
}
