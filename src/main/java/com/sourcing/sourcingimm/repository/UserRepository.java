package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.models.entities.UserEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import static com.sourcing.sourcingimm.generated.user_management.Tables.*;

import java.util.List;
import java.util.Optional;

@Repository
public class UserRepository {

    @Autowired
    private DSLContext dsl;

    public List<UserEntity> findAll() {
        return dsl.select(
                USER.ID,
                USER.NAME,
                USER.EMAIL,
                USER.PROFILE_ID,
                USER.ROLE_ID,
                USER.HAS_PREMIUM,
                USER.IS_ACTIVATED,
                USER.LAST_LOGIN,
                USER.CREATED_AT,
                USER.UPDATED_AT,
                PROFILE.NAME.as("profile_name"),
                ROLE.NAME.as("role_name")
        )
                .from(USER)
                .leftJoin(PROFILE).on(USER.PROFILE_ID.eq(PROFILE.ID))
                .leftJoin(ROLE).on(USER.ROLE_ID.eq(ROLE.ID))
                .fetchInto(UserEntity.class);
    }

    public Optional<UserEntity> findById(Integer id) {
        var record = dsl.select(
                USER.ID,
                USER.NAME,
                USER.EMAIL,
                USER.PASSWORD,
                USER.PROFILE_ID,
                USER.ROLE_ID,
                USER.HAS_PREMIUM,
                USER.IS_ACTIVATED,
                USER.LAST_LOGIN,
                USER.CREATED_AT,
                USER.UPDATED_AT,
                PROFILE.NAME.as("profile_name"),
                ROLE.NAME.as("role_name")
        )
                .from(USER)
                .leftJoin(PROFILE).on(USER.PROFILE_ID.eq(PROFILE.ID))
                .leftJoin(ROLE).on(USER.ROLE_ID.eq(ROLE.ID))
                .where(USER.ID.eq(id))
                .fetchOne();

        return record != null ? Optional.of(record.into(UserEntity.class)) : Optional.empty();
    }

    public Optional<UserEntity> findByEmail(String email) {
        var record = dsl.select()
                .from(USER)
                .where(USER.EMAIL.eq(email))
                .fetchOne();

        return record != null ? Optional.of(record.into(UserEntity.class)) : Optional.empty();
    }

    public UserEntity save(UserEntity user) {
        if (user.getId() == null) {
            var record = dsl.insertInto(USER)
                    .set(USER.NAME, user.getName())
                    .set(USER.EMAIL, user.getEmail())
                    .set(USER.PASSWORD, user.getPassword())
                    .set(USER.PROFILE_ID, user.getProfileId())
                    .set(USER.ROLE_ID, user.getRoleId())
                    .set(USER.HAS_PREMIUM, user.getHasPremium())
                    .set(USER.IS_ACTIVATED, user.getIsActivated())
                    .returning()
                    .fetchOne();

            return record.into(UserEntity.class);
        } else {
            dsl.update(USER)
                    .set(USER.NAME, user.getName())
                    .set(USER.EMAIL, user.getEmail())
                    .set(USER.PROFILE_ID, user.getProfileId())
                    .set(USER.ROLE_ID, user.getRoleId())
                    .set(USER.HAS_PREMIUM, user.getHasPremium())
                    .set(USER.IS_ACTIVATED, user.getIsActivated())
                    .where(USER.ID.eq(user.getId()))
                    .execute();

            return findById(user.getId()).orElse(user);
        }
    }

    public List<UserEntity> findByRoleId(String roleName) {
        return dsl.select()
                .from(USER)
                .join(ROLE).on(USER.ROLE_ID.eq(ROLE.ID))
                .where(ROLE.NAME.eq(roleName))
                .fetchInto(UserEntity.class);
    }

    public boolean existsByEmail(String email) {
        return dsl.fetchExists(
                dsl.selectOne()
                        .from(USER)
                        .where(USER.EMAIL.eq(email))
        );
    }
}
