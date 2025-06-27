package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.models.entities.OfferRequiredSkillEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static com.sourcing.sourcingimm.generated.recruitment.Tables.OFFER_REQUIRED_SKILL;

@Repository
public class OfferRequiredSkillRepository {

    @Autowired
    private DSLContext dsl;

    public List<OfferRequiredSkillEntity> getAllOffers() {
        return dsl.select(
                        OFFER_REQUIRED_SKILL.OFFER_ID,
                        OFFER_REQUIRED_SKILL.SKILL_ID
                )
                .from(OFFER_REQUIRED_SKILL)
                .fetchInto(OfferRequiredSkillEntity.class);
    }

    public Optional<OfferRequiredSkillEntity> findById(UUID id) {
        var record = dsl.select(
                        OFFER_REQUIRED_SKILL.OFFER_ID,
                        OFFER_REQUIRED_SKILL.SKILL_ID
                )
                .from(OFFER_REQUIRED_SKILL)
                .where(OFFER_REQUIRED_SKILL.ID.eq(id))
                .fetchOne();

        return record != null ? Optional.of(record.into(OfferRequiredSkillEntity.class)) : Optional.empty();
    }

    public OfferRequiredSkillEntity save(OfferRequiredSkillEntity offerRequiredSkillEntity) {
        if (offerRequiredSkillEntity.getId() == null) {
            var record = dsl.insertInto(OFFER_REQUIRED_SKILL)
                    .set(OFFER_REQUIRED_SKILL.OFFER_ID, offerRequiredSkillEntity.getOfferId())
                    .set(OFFER_REQUIRED_SKILL.SKILL_ID, offerRequiredSkillEntity.getSkillId())
                    .returning()
                    .fetchOne();

            return record.into(OfferRequiredSkillEntity.class);
        } else {
            dsl.update(OFFER_REQUIRED_SKILL)
                    .set(OFFER_REQUIRED_SKILL.OFFER_ID, offerRequiredSkillEntity.getOfferId())
                    .set(OFFER_REQUIRED_SKILL.SKILL_ID, offerRequiredSkillEntity.getSkillId())
                    .where(OFFER_REQUIRED_SKILL.ID.eq(offerRequiredSkillEntity.getId()))
                    .execute();

            return findById(offerRequiredSkillEntity.getId()).orElse(offerRequiredSkillEntity);
        }
    }
}
