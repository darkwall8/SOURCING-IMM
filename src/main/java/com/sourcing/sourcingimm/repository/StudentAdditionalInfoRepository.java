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
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_COUNTRY, entity.getStudentCountry())
                    .set(STUDENT_ADDITIONAL_INFORMATION.USER_EMAIL, entity.getUserEmail())
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_SCHOOL_LEVEL, entity.getStudentSchoolLevel())
                    .set(STUDENT_ADDITIONAL_INFORMATION.PORTFOLIO_URL, entity.getPortfolioUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.GITHUB_URL, entity.getGithubUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.LINKEDIN_URL, entity.getLinkedinUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_SPECIFICATION, entity.getStudentSpecification())
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_CV, entity.getStudentCv())
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_WANT_TO_RECEIVE_NOTIFICATION, entity.getStudentWantToReceiveNotification())
                    .set(STUDENT_ADDITIONAL_INFORMATION.ADDRESS, entity.getAddress())

                    .returning()
                    .fetchOne();

            return record.into(StudentAdditionalInformationEntity.class);
        } else {
            dsl.update(STUDENT_ADDITIONAL_INFORMATION)
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_COUNTRY, entity.getStudentCountry())
                    .set(STUDENT_ADDITIONAL_INFORMATION.USER_EMAIL, entity.getUserEmail())
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_SCHOOL_LEVEL, entity.getStudentSchoolLevel())
                    .set(STUDENT_ADDITIONAL_INFORMATION.PORTFOLIO_URL, entity.getPortfolioUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.GITHUB_URL, entity.getGithubUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.LINKEDIN_URL, entity.getLinkedinUrl())
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_SPECIFICATION, entity.getStudentSpecification())
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_CV, entity.getStudentCv())
                    .set(STUDENT_ADDITIONAL_INFORMATION.STUDENT_WANT_TO_RECEIVE_NOTIFICATION, entity.getStudentWantToReceiveNotification())
                    .set(STUDENT_ADDITIONAL_INFORMATION.ADDRESS, entity.getAddress())
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
