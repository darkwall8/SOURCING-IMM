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
                    .set(COMPANY_ADDITIONAL_INFORMATION.CONTACT_PHONE, entity.getContactPhone())
                    .set(COMPANY_ADDITIONAL_INFORMATION.DESCRIPTION, entity.getDescription())
                    .set(COMPANY_ADDITIONAL_INFORMATION.INDUSTRY, entity.getIndustry())
                    .set(COMPANY_ADDITIONAL_INFORMATION.WEBSITE , entity.getWebsite())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_CORPORATE , entity.getCompanyCorporate())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_NIU , entity.getCompanyNIU())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_RCCM , entity.getCompanyRCCM())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_COMMERCIAL_REGISTER , entity.getCompanyCommercialRegister())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_HAS_INTERN_OPPORTUNITY , entity.getCompanyHasInternOpportunity())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_INTERNSHIP_DURATION , entity.getCompanyInternshipDuration())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_STATIC_DECLARATION_NUMBER , entity.getCompanyStaticDeclarationNumber())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_LEGAL_STATUS , entity.getCompanyLegalStatus())
                    .returning()
                    .fetchOne();

            return record.into(CompanyAdditionalInformationEntity.class);
        } else {
            dsl.update(COMPANY_ADDITIONAL_INFORMATION)
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_NAME, entity.getCompanyName())
                    .set(COMPANY_ADDITIONAL_INFORMATION.USER_EMAIL, entity.getUserEmail())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_SIZE, entity.getCompanySize())
                    .set(COMPANY_ADDITIONAL_INFORMATION.ADDRESS, entity.getAddress())
                    .set(COMPANY_ADDITIONAL_INFORMATION.CONTACT_PHONE, entity.getContactPhone())
                    .set(COMPANY_ADDITIONAL_INFORMATION.DESCRIPTION, entity.getDescription())
                    .set(COMPANY_ADDITIONAL_INFORMATION.INDUSTRY, entity.getIndustry())
                    .set(COMPANY_ADDITIONAL_INFORMATION.WEBSITE , entity.getWebsite())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_CORPORATE , entity.getCompanyCorporate())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_NIU , entity.getCompanyNIU())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_RCCM , entity.getCompanyRCCM())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_COMMERCIAL_REGISTER , entity.getCompanyCommercialRegister())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_HAS_INTERN_OPPORTUNITY , entity.getCompanyHasInternOpportunity())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_INTERNSHIP_DURATION , entity.getCompanyInternshipDuration())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_STATIC_DECLARATION_NUMBER , entity.getCompanyStaticDeclarationNumber())
                    .set(COMPANY_ADDITIONAL_INFORMATION.COMPANY_LEGAL_STATUS , entity.getCompanyLegalStatus())
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

