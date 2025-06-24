package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.models.entities.CompanyAdditionalInformationEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Optional;

import static com.sourcing.sourcingimm.generated.user_management.Tables.COMPANY_ADDITIONAL_INFORMATION;

@Repository
public class CompanyAdditionalRepository {

    @Autowired
    private DSLContext dsl;

    public Optional<CompanyAdditionalInformationEntity> findByUserEmail(String email) {
        var record = dsl.select()
                .from(COMPANY_ADDITIONAL_INFORMATION)
                .where(COMPANY_ADDITIONAL_INFORMATION.USER_EMAIL.eq(email))
                .fetchOne();

        return record != null ? Optional.of(record.into(CompanyAdditionalInformationEntity.class)) : Optional.empty();
    }

    public CompanyAdditionalInformationEntity save(CompanyAdditionalInformationEntity entity) {
        if (entity.getId() == null) {
            var record = dsl.insertInto(COMPANY_ADDITIONAL_INFORMATION)
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_NAME, entity.getCompanyName())
                    .set(COMPANY_ADDITIONAL_INFORMATION.USER_EMAIL, entity.getUserEmail())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_SIZE, entity.getCompanySize())
                    .set(COMPANY_ADDITIONAL_INFORMATION.ADDRESS, entity.getAddress())
                    .set(COMPANY_ADDITIONAL_INFORMATION.CONTACT_PERSON, entity.getContactPerson())
                    .set(COMPANY_ADDITIONAL_INFORMATION.CONTACT_PHONE, entity.getContactPhone())
                    .set(COMPANY_ADDITIONAL_INFORMATION.DESCRIPTION, entity.getDescription())
                    .set(COMPANY_ADDITIONAL_INFORMATION.INDUSTRY, entity.getIndustry())
                    .set(COMPANY_ADDITIONAL_INFORMATION.SIRET, entity.getSiret())
                    .set(COMPANY_ADDITIONAL_INFORMATION.WEBSITE , entity.getWebsite())
                    .returning()
                    .fetchOne();

            return record.into(CompanyAdditionalInformationEntity.class);
        } else {
            dsl.update(COMPANY_ADDITIONAL_INFORMATION)
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_NAME, entity.getCompanyName())
                    .set(COMPANY_ADDITIONAL_INFORMATION.USER_EMAIL, entity.getUserEmail())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_SIZE, entity.getCompanySize())
                    .set(COMPANY_ADDITIONAL_INFORMATION.ADDRESS, entity.getAddress())
                    .set(COMPANY_ADDITIONAL_INFORMATION.CONTACT_PERSON, entity.getContactPerson())
                    .set(COMPANY_ADDITIONAL_INFORMATION.CONTACT_PHONE, entity.getContactPhone())
                    .set(COMPANY_ADDITIONAL_INFORMATION.DESCRIPTION, entity.getDescription())
                    .set(COMPANY_ADDITIONAL_INFORMATION.INDUSTRY, entity.getIndustry())
                    .set(COMPANY_ADDITIONAL_INFORMATION.SIRET, entity.getSiret())
                    .set(COMPANY_ADDITIONAL_INFORMATION.WEBSITE , entity.getWebsite())
                    .where(COMPANY_ADDITIONAL_INFORMATION.USER_EMAIL.eq(entity.getUserEmail()))
                    .execute();

            return findByUserEmail(entity.getUserEmail()).orElse(entity);
        }
    }

    public boolean existByUserEmail(String email) {
        return dsl.fetchExists(
                dsl.selectOne()
                        .from(COMPANY_ADDITIONAL_INFORMATION)
                        .where(COMPANY_ADDITIONAL_INFORMATION.USER_EMAIL.eq(email))
        );
    }
}

