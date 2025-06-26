package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.models.entities.CandidatureOfferEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import static com.sourcing.sourcingimm.generated.recruitment.Tables.CANDIDATURE_OFFER;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class CandidatureOfferRepository {

    @Autowired
    private DSLContext dsl;

    public List<CandidatureOfferEntity> findAll() {
        return dsl.select(
                CANDIDATURE_OFFER.CANDIDATURE_ID,
                CANDIDATURE_OFFER.OFFER_ID,
                CANDIDATURE_OFFER.COVER_LETTER,
                CANDIDATURE_OFFER.STATUS
        )
                .from(CANDIDATURE_OFFER)
                .fetchInto(CandidatureOfferEntity.class);
    }

    public Optional<CandidatureOfferEntity> findById(UUID offerId, UUID candidateId) {
        var record = dsl.select(
                        CANDIDATURE_OFFER.CANDIDATURE_ID,
                        CANDIDATURE_OFFER.STATUS,
                        CANDIDATURE_OFFER.COVER_LETTER,
                        CANDIDATURE_OFFER.OFFER_ID
                )
                .from(CANDIDATURE_OFFER)
                .where(CANDIDATURE_OFFER.OFFER_ID.eq(offerId).and(CANDIDATURE_OFFER.CANDIDATURE_ID.eq(candidateId)))
                .fetchOne();

        return record != null ? Optional.of(record.into(CandidatureOfferEntity.class)) : Optional.empty();
    }

    public CandidatureOfferEntity save(CandidatureOfferEntity candidatureOfferEntity) {
        if (candidatureOfferEntity.getOfferId() == null && candidatureOfferEntity.getCandidateId() == null) {
            var record = dsl.insertInto(CANDIDATURE_OFFER)
                    .set(CANDIDATURE_OFFER.OFFER_ID, candidatureOfferEntity.getOfferId())
                    .set(CANDIDATURE_OFFER.CANDIDATURE_ID, candidatureOfferEntity.getCandidateId())
                    .set(CANDIDATURE_OFFER.STATUS, candidatureOfferEntity.getStatus())
                    .set(CANDIDATURE_OFFER.COVER_LETTER, candidatureOfferEntity.getCoverLetter())
                    .returning()
                    .fetchOne();

            return record.into(CandidatureOfferEntity.class);
        } else {
            dsl.update(CANDIDATURE_OFFER)
                    .set(CANDIDATURE_OFFER.OFFER_ID, candidatureOfferEntity.getOfferId())
                    .set(CANDIDATURE_OFFER.CANDIDATURE_ID, candidatureOfferEntity.getCandidateId())
                    .set(CANDIDATURE_OFFER.STATUS, candidatureOfferEntity.getStatus())
                    .set(CANDIDATURE_OFFER.COVER_LETTER, candidatureOfferEntity.getCoverLetter())
                    .where(CANDIDATURE_OFFER.OFFER_ID.eq(candidatureOfferEntity.getOfferId()).and(CANDIDATURE_OFFER.CANDIDATURE_ID.eq(candidatureOfferEntity.getCandidateId())))
                    .execute();

            return findById(candidatureOfferEntity.getOfferId(), candidatureOfferEntity.getCandidateId()).orElse(candidatureOfferEntity);
        }
    }

}
