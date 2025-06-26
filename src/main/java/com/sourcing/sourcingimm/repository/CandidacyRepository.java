package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.generated.recruitment.enums.CandidatureStatusEnum;
import com.sourcing.sourcingimm.models.CandidacyModel;
import com.sourcing.sourcingimm.models.entities.CandidacyEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static com.sourcing.sourcingimm.generated.recruitment.Tables.CANDIDATURE;

@Repository
public class CandidacyRepository {

    @Autowired
    private DSLContext dsl;

    public List<CandidacyEntity> getAllCandidacy() {
        return dsl.select(
                CANDIDATURE.COVER_LETTER,
                CANDIDATURE.USER_EMAIL,
                CANDIDATURE.OFFER_ID,
                CANDIDATURE.ID,
                CANDIDATURE.COVER_LETTER
        )
                .from(CANDIDATURE)
                .fetchInto(CandidacyEntity.class);
    }

    public Optional<CandidacyEntity> findById(UUID id) {
        var record = dsl.select(
                CANDIDATURE.COVER_LETTER,
                CANDIDATURE.STATUS,
                CANDIDATURE.ID,
                CANDIDATURE.OFFER_ID,
                CANDIDATURE.USER_EMAIL
        )
                .from(CANDIDATURE)
                .where(CANDIDATURE.ID.eq(id))
                .fetchOne();
        return record != null ? Optional.of(record.into(CandidacyEntity.class)) : Optional.empty();
    }

    public CandidacyEntity save(CandidacyEntity entity) {
        if (entity.getId() == null) {
            var record = dsl.insertInto(CANDIDATURE)
                    .set(CANDIDATURE.COVER_LETTER, entity.getCoverLetter())
                    .set(CANDIDATURE.USER_EMAIL, entity.getUserEmail())
                    .set(CANDIDATURE.OFFER_ID, entity.getOfferId())
                    .set(CANDIDATURE.STATUS, CandidatureStatusEnum.valueOf(entity.getStatus().name()))
                    .returning()
                    .fetchOne();

            return record.into(CandidacyEntity.class);
        } else {
            dsl.update(CANDIDATURE)
                    .set(CANDIDATURE.COVER_LETTER, entity.getCoverLetter())
                    .set(CANDIDATURE.USER_EMAIL, entity.getUserEmail())
                    .set(CANDIDATURE.OFFER_ID, entity.getOfferId())
                    .set(CANDIDATURE.STATUS, CandidatureStatusEnum.valueOf(entity.getStatus().name()))
                    .where(CANDIDATURE.ID.eq(entity.getId()))
                    .execute();

            return findById(entity.getId()).orElse(entity);
        }
    }

}
