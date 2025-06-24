package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.models.entities.StudentAdditionalInformationEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Optional;

import static com.sourcing.sourcingimm.generated.user_management.Tables.STUDENT_ADDITIONAL_INFORMATION;

@Repository
public class StudentAdditionalInfoRepository {

    @Autowired
    private DSLContext dsl;

    public Optional<StudentAdditionalInformationEntity> findByUserEmail(String email) {
        var record = dsl.select()
                .from(STUDENT_ADDITIONAL_INFORMATION)
                .where(STUDENT_ADDITIONAL_INFORMATION.USER_EMAIL.eq(email))
                .fetchOne();

        return record != null ? Optional.of(record.into(StudentAdditionalInformationEntity.class)) : Optional.empty();
    }

    public StudentAdditionalInformationEntity save(StudentAdditionalInformationEntity entity) {
        if (entity.getId() == null) {
            var record = dsl.insertInto(STUDENT_ADDITIONAL_INFORMATION)
                    .set(STUDENT_ADDITIONAL_INFORMATION.UNIVERSITY, entity.getUniversity())
                    .set(STUDENT_ADDITIONAL_INFORMATION.USER_EMAIL, entity.getUserEmail())
                    .set(STUDENT_ADDITIONAL_INFORMATION.GRADUATION_YEAR, entity.getGraduationYear())
                    .set(STUDENT_ADDITIONAL_INFORMATION.PORTFOLIO_URL, entity.getPortfolioUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.GITHUB_URL, entity.getGithubUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.LINKEDIN_URL, entity.getLinkedinUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.PHONE, entity.getPhone())
                    .set(STUDENT_ADDITIONAL_INFORMATION.ADDRESS, entity.getAddress())
                    .set(STUDENT_ADDITIONAL_INFORMATION.BIO, entity.getBio())
                    .set(STUDENT_ADDITIONAL_INFORMATION.AVAILABILITY_DATE , entity.getAvailabilityDate())
                    .returning()
                    .fetchOne();

            return record.into(StudentAdditionalInformationEntity.class);
        } else {
            dsl.update(STUDENT_ADDITIONAL_INFORMATION)
                    .set(STUDENT_ADDITIONAL_INFORMATION.UNIVERSITY, entity.getUniversity())
                    .set(STUDENT_ADDITIONAL_INFORMATION.USER_EMAIL, entity.getUserEmail())
                    .set(STUDENT_ADDITIONAL_INFORMATION.GRADUATION_YEAR, entity.getGraduationYear())
                    .set(STUDENT_ADDITIONAL_INFORMATION.PORTFOLIO_URL, entity.getPortfolioUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.GITHUB_URL, entity.getGithubUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.LINKEDIN_URL, entity.getLinkedinUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.PHONE, entity.getPhone())
                    .set(STUDENT_ADDITIONAL_INFORMATION.ADDRESS, entity.getAddress())
                    .set(STUDENT_ADDITIONAL_INFORMATION.BIO, entity.getBio())
                    .set(STUDENT_ADDITIONAL_INFORMATION.AVAILABILITY_DATE , entity.getAvailabilityDate())
                    .where(STUDENT_ADDITIONAL_INFORMATION.USER_EMAIL.eq(entity.getUserEmail()))
                    .execute();

            return findByUserEmail(entity.getUserEmail()).orElse(entity);
        }
    }

    public boolean existByUserEmail(String email) {
        return dsl.fetchExists(
                dsl.selectOne()
                        .from(STUDENT_ADDITIONAL_INFORMATION)
                        .where(STUDENT_ADDITIONAL_INFORMATION.USER_EMAIL.eq(email))
        );
    }

}
