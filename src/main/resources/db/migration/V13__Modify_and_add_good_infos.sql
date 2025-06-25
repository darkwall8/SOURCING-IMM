-- =========================================
-- V13__Modify_and_add_good_infos.sql
-- migration pour modifier les informations
-- non conformes avec le MLD
-- =========================================

-- Modification de la table StudentAdditionnalInformations
-- Supprimer ce qui ne doit pas être là
ALTER TABLE user_management.student_additional_information
    DROP COLUMN IF EXISTS university,
    DROP COLUMN IF EXISTS current_level,
    DROP COLUMN IF EXISTS graduation_year,
    DROP COLUMN IF EXISTS bio,
    DROP COLUMN IF EXISTS availability_date,
    DROP COLUMN IF EXISTS phone,
    DROP COLUMN IF EXISTS availability_date;

-- Ajouter les bonnes informations
ALTER TABLE user_management.student_additional_information
    ADD COLUMN student_country                      VARCHAR(255),
    ADD COLUMN student_school_level                 VARCHAR(255),
    ADD COLUMN student_specification                VARCHAR(255),
    ADD COLUMN student_want_to_receive_notification BOOLEAN DEFAULT FALSE,
    ADD COLUMN student_cv                           TEXT;

-- Création de la table student_additional_information_offer_preference
CREATE TABLE user_management.student_additional_information_offer_preference
(
    id               UUID DEFAULT uuid_generate_v4() REFERENCES user_management.student_additional_information (id) ON DELETE SET NULL,
    offer_preference VARCHAR(255)                    NOT NULL

);

-- Modification table skill
ALTER TABLE academic.skill
    DROP COLUMN IF EXISTS description,
    DROP COLUMN IF EXISTS category,
    DROP COLUMN IF EXISTS is_active;

-- Modification table profile
ALTER TABLE user_management.profile
    DROP COLUMN IF EXISTS description,
    DROP COLUMN IF EXISTS updated_at,
    DROP COLUMN IF EXISTS profile_type;

-- Modification table candidature
ALTER TABLE recruitment.candidature
    DROP COLUMN IF EXISTS additional_documents,
    DROP COLUMN IF EXISTS motivation,
    DROP COLUMN IF EXISTS expected_salary,
    DROP COLUMN IF EXISTS availability_date,
    DROP COLUMN IF EXISTS notes,
    DROP COLUMN IF EXISTS score,
    DROP COLUMN IF EXISTS applied_at,
    DROP COLUMN IF EXISTS reviewed_at,
    DROP COLUMN IF EXISTS response_date,
    DROP COLUMN IF EXISTS reviewed_by_email,
    DROP COLUMN IF EXISTS resume_file_id;

-- Candidature_offer création

CREATE TABLE recruitment.candidature_offer
(
    offer_id       UUID DEFAULT uuid_generate_v4() REFERENCES recruitment.offer (id) ON DELETE SET NULL,
    candidature_id UUID DEFAULT uuid_generate_v4() REFERENCES recruitment.candidature (id) ON DELETE SET NULL,
    cover_letter   VARCHAR(255),
    status         VARCHAR(255),
    PRIMARY KEY (offer_id, candidature_id)
);

-- Modification offerRequireSkill
ALTER TABLE recruitment.offer_required_skill
    DROP COLUMN IF EXISTS required_level,
    DROP COLUMN IF EXISTS is_mandatory,
    DROP COLUMN IF EXISTS weight;

-- Modification offer
ALTER TABLE recruitment.offer
    DROP COLUMN IF EXISTS offer_type,
    DROP COLUMN IF EXISTS status,
    DROP COLUMN IF EXISTS remote_possible,
    DROP COLUMN IF EXISTS salary_max,
    DROP COLUMN IF EXISTS salary_min,
    DROP COLUMN IF EXISTS currency,
    DROP COLUMN IF EXISTS duration_months,
    DROP COLUMN IF EXISTS start_date,
    DROP COLUMN IF EXISTS benefits,
    DROP COLUMN IF EXISTS application_process,
    DROP COLUMN IF EXISTS applications_count,
    DROP COLUMN IF EXISTS views_count,
    DROP COLUMN IF EXISTS published_at,
    DROP COLUMN IF EXISTS required_level;

-- Ajout des informations conformes au model
ALTER TABLE recruitment.offer
    ADD COLUMN period          VARCHAR(255),
    ADD COLUMN is_custom_offer BOOLEAN,
    ADD COLUMN receiver_email  VARCHAR(255) REFERENCES user_management."user" (email) ON DELETE SET NULL,
    ADD COLUMN user_email      VARCHAR(255) REFERENCES user_management."user" (email) ON DELETE SET NULL;

-- Ajout de la table CompanyAdditionalInformation_internship_type
CREATE TABLE user_management.company_additional_information_internship_type
(
    company_additional_information_id UUID DEFAULT uuid_generate_v4() REFERENCES user_management.company_additional_information (id) ON DELETE SET NULL,
    internship_type                   VARCHAR(255)                    NOT NULL
);

-- Ajout de la table CompanyAdditionalInformation_intern_benefit
CREATE TABLE user_management.company_additional_information_internship_benefit
(
    company_additional_information_id UUID DEFAULT uuid_generate_v4() REFERENCES user_management.company_additional_information (id) ON DELETE SET NULL,
    internship_benefit                VARCHAR(255)                    NOT NULL
);

-- Ajout de la table inter_preference
CREATE TABLE user_management.company_additional_information_intern_preference
(
    company_additional_information_id UUID DEFAULT uuid_generate_v4() REFERENCES user_management.company_additional_information (id) ON DELETE SET NULL,
    profile_id                        UUID DEFAULT uuid_generate_v4() REFERENCES user_management.profile (id) ON DELETE SET NULL
);

-- Ajout de la table activity sector
CREATE TABLE user_management.activity_sector
(
    id   UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255)
);

-- Modification de company add infos en fonction d'activity sector
ALTER TABLE user_management.company_additional_information
    DROP COLUMN IF EXISTS industry,
    ADD COLUMN company_activity_sector_id UUID DEFAULT uuid_generate_v4() REFERENCES user_management.activity_sector (id);

-- Modification de token
ALTER TABLE system.token
    DROP COLUMN IF EXISTS token_hash,
    DROP COLUMN IF EXISTS token_hash,
    DROP COLUMN IF EXISTS used_at,
    DROP COLUMN IF EXISTS metadata,
    DROP COLUMN IF EXISTS is_revoked,
    DROP COLUMN IF EXISTS expires_at,
    ADD COLUMN exp_date VARCHAR(255) NOT NULL,
    ADD COLUMN new_id   UUID DEFAULT uuid_generate_v4(),
    DROP COLUMN id;

ALTER TABLE system.token
    ALTER COLUMN new_id SET NOT NULL;

ALTER TABLE system.token
    RENAME COLUMN new_id TO id;

ALTER TABLE system.token
    ADD PRIMARY KEY (id);

-- Modification de la table feedback
ALTER TABLE system.feedback
    DROP COLUMN IF EXISTS feedback_type,
    DROP COLUMN IF EXISTS subject,
    DROP COLUMN IF EXISTS message,
    DROP COLUMN IF EXISTS rating,
    DROP COLUMN IF EXISTS is_resolved,
    DROP COLUMN IF EXISTS resolution_notes,
    DROP COLUMN IF EXISTS resolved_by_email;

ALTER TABLE system.feedback
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

ALTER TABLE system.feedback
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

ALTER TABLE system.feedback
    RENAME COLUMN new_id TO id;

ALTER TABLE system.feedback
    ADD PRIMARY KEY (id);

ALTER TABLE system.feedback
    ADD COLUMN comment VARCHAR(255);

-- Modification de la table role
ALTER TABLE user_management.role
    DROP COLUMN IF EXISTS description,
    DROP COLUMN IF EXISTS permissions;

-- Creation de student_stack
-- Fixed: Changed skill_id from UUID to INTEGER to match academic.skill(id) type
CREATE TABLE user_management.student_stack
(
    id         UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL REFERENCES user_management."user" (email) ON DELETE CASCADE,
    skill_id   INTEGER      NOT NULL REFERENCES academic.skill (id) ON DELETE CASCADE
);

-- Modifier la table tracability
ALTER TABLE system.traceability
    DROP COLUMN IF EXISTS action,
    DROP COLUMN IF EXISTS entity_id,
    DROP COLUMN IF EXISTS entity_type,
    DROP COLUMN IF EXISTS old_values,
    DROP COLUMN IF EXISTS ip_address,
    DROP COLUMN IF EXISTS user_agent,
    DROP COLUMN IF EXISTS session_id;

ALTER TABLE system.traceability
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

ALTER TABLE system.traceability
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

ALTER TABLE system.traceability
    RENAME COLUMN new_id TO id;

ALTER TABLE system.traceability
    ADD PRIMARY KEY (id);