package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.models.entities.OfferEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static com.sourcing.sourcingimm.generated.recruitment.Tables.OFFER;

@Repository
public class OfferRepository {

    @Autowired
    private DSLContext dsl;

    public List<OfferEntity> getAllOffers() {
        return dsl.select(
                OFFER.IS_CUSTOM_OFFER,
                OFFER.COMPANY_EMAIL,
                OFFER.DESCRIPTION,
                OFFER.IS_REMUNERATED,
                OFFER.LOCATION,
                OFFER.LIMIT_DATE,
                OFFER.TITLE,
                OFFER.RECEIVER_EMAIL,
                OFFER.USER_EMAIL,
                OFFER.COMPANY_EMAIL,
                OFFER.PERIOD
        )
                .from(OFFER)
                .fetchInto(OfferEntity.class);
    }

    public Optional<OfferEntity> findById(UUID id) {
        var record = dsl.select(
                        OFFER.IS_CUSTOM_OFFER,
                        OFFER.COMPANY_EMAIL,
                        OFFER.DESCRIPTION,
                        OFFER.IS_REMUNERATED,
                        OFFER.LOCATION,
                        OFFER.LIMIT_DATE,
                        OFFER.TITLE,
                        OFFER.RECEIVER_EMAIL,
                        OFFER.USER_EMAIL,
                        OFFER.COMPANY_EMAIL,
                        OFFER.PERIOD
                )
                .from(OFFER)
                .where(OFFER.ID.eq(id))
                .fetchOne();

        return record != null ? Optional.of(record.into(OfferEntity.class)) : Optional.empty();
    }

    public OfferEntity save(OfferEntity entity) {
        if (entity.getId() == null) {
            var record = dsl.insertInto(OFFER)
                    .set(OFFER.IS_CUSTOM_OFFER, entity.getIsCustomOffer())
                    .set(OFFER.COMPANY_EMAIL, entity.getCompanyEmail())
                    .set(OFFER.DESCRIPTION, entity.getDescription())
                    .set(OFFER.IS_REMUNERATED, entity.getIsRemunerated())
                    .set(OFFER.LOCATION, entity.getLocation())
                    .set(OFFER.PERIOD, entity.getPeriod())
                    .set(OFFER.RECEIVER_EMAIL, entity.getReceiverEmail())
                    .set(OFFER.USER_EMAIL, entity.getUserEmail())
                    .set(OFFER.TITLE, entity.getTitle())
                    .set(OFFER.LIMIT_DATE, entity.getLimitDate())
                    .returning()
                    .fetchOne();

            return record.into(OfferEntity.class);

        } else {
            dsl.update(OFFER)
                    .set(OFFER.IS_CUSTOM_OFFER, entity.getIsCustomOffer())
                    .set(OFFER.COMPANY_EMAIL, entity.getCompanyEmail())
                    .set(OFFER.DESCRIPTION, entity.getDescription())
                    .set(OFFER.IS_REMUNERATED, entity.getIsRemunerated())
                    .set(OFFER.LOCATION, entity.getLocation())
                    .set(OFFER.PERIOD, entity.getPeriod())
                    .set(OFFER.RECEIVER_EMAIL, entity.getReceiverEmail())
                    .set(OFFER.USER_EMAIL, entity.getUserEmail())
                    .set(OFFER.TITLE, entity.getTitle())
                    .set(OFFER.LIMIT_DATE, entity.getLimitDate())
                    .where(OFFER.ID.eq(entity.getId()))
                    .execute();

            return findById(entity.getId()).orElse(entity);
        }
    }
}
