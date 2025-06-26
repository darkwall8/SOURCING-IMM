package com.sourcing.sourcingimm.repository;

import com.sourcing.sourcingimm.models.entities.UserEntity;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import static com.sourcing.sourcingimm.generated.user_management.Tables.USER;
import static com.sourcing.sourcingimm.generated.user_management.Tables.PROFILE;
import static com.sourcing.sourcingimm.generated.user_management.Tables.ROLE;


import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class UserRepository {

    @Autowired
    private DSLContext dsl;

    public List<UserEntity> findAll() {
        return dsl.select(
                        USER.NAME,
                        USER.EMAIL,
                        USER.PROFILE,
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
                .leftJoin(ROLE).on(USER.ROLE_ID.eq(ROLE.ID))
                .fetchInto(UserEntity.class);
    }

    public Optional<UserEntity> findByEmail(String email) {
        var record = dsl.select(
                        USER.NAME,
                        USER.EMAIL,
                        USER.PROFILE,
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
                .leftJoin(ROLE).on(USER.ROLE_ID.eq(ROLE.ID))
                .where(USER.EMAIL.eq(email))
                .fetchOne();

        return record != null ? Optional.of(record.into(UserEntity.class)) : Optional.empty();
    }

    public UserEntity save(UserEntity user) {
        // Correction: vérifier si l'utilisateur existe déjà
        if (!existsByEmail(user.getEmail())) {
            // Nouveau utilisateur
            var record = dsl.insertInto(USER)
                    .set(USER.NAME, user.getName())
                    .set(USER.EMAIL, user.getEmail())
                    .set(USER.PROFILE, user.getProfile())
                    .set(USER.ROLE_ID, user.getRoleId())
                    .set(USER.HAS_PREMIUM, user.getHasPremium())
                    .set(USER.IS_ACTIVATED, user.getIsActivated())
                    .returning()
                    .fetchOne();

            return record.into(UserEntity.class);
        } else {
            // Mise à jour de l'utilisateur existant
            dsl.update(USER)
                    .set(USER.NAME, user.getName())
                    .set(USER.PROFILE, user.getProfile())
                    .set(USER.ROLE_ID, user.getRoleId())
                    .set(USER.HAS_PREMIUM, user.getHasPremium())
                    .set(USER.IS_ACTIVATED, user.getIsActivated())
                    .where(USER.EMAIL.eq(user.getEmail()))
                    .execute();

            return findByEmail(user.getEmail()).orElse(user);
        }
    }

    public List<UserEntity> findByRoleId(UUID roleId) {
        return dsl.select(
                        USER.NAME,
                        USER.EMAIL,
                        USER.PROFILE,
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
                .leftJoin(ROLE).on(USER.ROLE_ID.eq(ROLE.ID))
                .where(USER.ROLE_ID.eq(roleId))
                .fetchInto(UserEntity.class);
    }

    public List<UserEntity> findByRoleName(String roleName) {
        return dsl.select(
                        USER.NAME,
                        USER.EMAIL,
                        USER.PROFILE,
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