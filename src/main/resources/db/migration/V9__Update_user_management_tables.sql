-- =========================================
-- V9__Update_user_management_tables.sql
-- Migration pour passer à email comme PK et UUID pour les autres tables
-- =========================================

-- Activer l'extension UUID si pas déjà fait
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Étape 1: Supprimer TOUTES les contraintes de clés étrangères qui dépendent de user_management.user
-- Contraintes dans user_management
ALTER TABLE user_management.student_additional_information
DROP CONSTRAINT IF EXISTS student_additional_information_user_id_fkey;

ALTER TABLE user_management.company_additional_information
DROP CONSTRAINT IF EXISTS company_additional_information_user_id_fkey;

ALTER TABLE user_management.role
DROP CONSTRAINT IF EXISTS role_profile_id_fkey;

ALTER TABLE user_management.user
DROP CONSTRAINT IF EXISTS user_profile_id_fkey,
DROP CONSTRAINT IF EXISTS user_role_id_fkey;

-- Contraintes dans academic
ALTER TABLE academic.skill
DROP CONSTRAINT IF EXISTS skill_profile_id_fkey;

ALTER TABLE academic.student_skill
DROP CONSTRAINT IF EXISTS student_skill_user_id_fkey,
DROP CONSTRAINT IF EXISTS student_skill_validated_by_fkey;

ALTER TABLE academic.student_file
DROP CONSTRAINT IF EXISTS student_file_user_id_fkey;

ALTER TABLE academic.student_link
DROP CONSTRAINT IF EXISTS student_link_user_id_fkey;

ALTER TABLE academic.student_filter_param
DROP CONSTRAINT IF EXISTS student_filter_param_user_id_fkey;

-- Contraintes dans recruitment
ALTER TABLE recruitment.offer
DROP CONSTRAINT IF EXISTS offer_company_id_fkey;

ALTER TABLE recruitment.candidature
DROP CONSTRAINT IF EXISTS candidature_user_id_fkey,
DROP CONSTRAINT IF EXISTS candidature_reviewed_by_fkey;

-- Contraintes dans system
ALTER TABLE system.token
DROP CONSTRAINT IF EXISTS token_user_id_fkey;

ALTER TABLE system.traceability
DROP CONSTRAINT IF EXISTS traceability_user_id_fkey;

ALTER TABLE system.feedback
DROP CONSTRAINT IF EXISTS feedback_user_id_fkey,
DROP CONSTRAINT IF EXISTS feedback_resolved_by_fkey;

-- Étape 2: Modifier la table profile pour utiliser UUID
ALTER TABLE user_management.profile
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mettre à jour les références dans la table role
ALTER TABLE user_management.role
    ADD COLUMN new_profile_id UUID;

UPDATE user_management.role
SET new_profile_id = p.new_id
    FROM user_management.profile p
WHERE role.profile_id = p.id;

-- Mettre à jour les références dans la table user
ALTER TABLE user_management.user
    ADD COLUMN new_profile_id UUID;

UPDATE user_management.user
SET new_profile_id = p.new_id
    FROM user_management.profile p
WHERE user_management.user.profile_id = p.id;

-- Préparer la modification de academic.skill.profile_id
ALTER TABLE academic.skill
    ADD COLUMN new_profile_id UUID;

UPDATE academic.skill
SET new_profile_id = p.new_id
    FROM user_management.profile p
WHERE academic.skill.profile_id = p.id;

ALTER TABLE academic.skill
DROP COLUMN profile_id;

ALTER TABLE academic.skill
    RENAME COLUMN new_profile_id TO profile_id;

-- Supprimer les anciennes colonnes et renommer les nouvelles pour profile
ALTER TABLE user_management.profile
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

ALTER TABLE user_management.profile
    RENAME COLUMN new_id TO id;

ALTER TABLE user_management.profile
    ADD PRIMARY KEY (id);

-- Étape 3: Modifier la table role pour utiliser UUID
ALTER TABLE user_management.role
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mettre à jour les références dans la table user
ALTER TABLE user_management.user
    ADD COLUMN new_role_id UUID;

UPDATE user_management.user
SET new_role_id = r.new_id
    FROM user_management.role r
WHERE user_management.user.role_id = r.id;

-- Supprimer les anciennes colonnes et renommer les nouvelles pour role
ALTER TABLE user_management.role
DROP COLUMN id,
DROP COLUMN profile_id,
ALTER COLUMN new_id SET NOT NULL,
ALTER COLUMN new_profile_id SET DEFAULT NULL;

ALTER TABLE user_management.role
    RENAME COLUMN new_id TO id;
ALTER TABLE user_management.role
    RENAME COLUMN new_profile_id TO profile_id;

ALTER TABLE user_management.role
    ADD PRIMARY KEY (id);

-- Étape 4: Préparer les tables dépendantes pour la migration vers email
-- Ajouter les colonnes email aux tables qui référencent user.id
ALTER TABLE user_management.student_additional_information
    ADD COLUMN user_email VARCHAR(255);

ALTER TABLE user_management.company_additional_information
    ADD COLUMN user_email VARCHAR(255);

ALTER TABLE academic.student_skill
    ADD COLUMN user_email VARCHAR(255),
    ADD COLUMN validated_by_email VARCHAR(255);

ALTER TABLE academic.student_file
    ADD COLUMN user_email VARCHAR(255);

ALTER TABLE academic.student_link
    ADD COLUMN user_email VARCHAR(255);

ALTER TABLE academic.student_filter_param
    ADD COLUMN user_email VARCHAR(255);

ALTER TABLE recruitment.offer
    ADD COLUMN company_email VARCHAR(255);

ALTER TABLE recruitment.candidature
    ADD COLUMN user_email VARCHAR(255),
    ADD COLUMN reviewed_by_email VARCHAR(255);

ALTER TABLE system.token
    ADD COLUMN user_email VARCHAR(255);

ALTER TABLE system.traceability
    ADD COLUMN user_email VARCHAR(255);

ALTER TABLE system.feedback
    ADD COLUMN user_email VARCHAR(255),
    ADD COLUMN resolved_by_email VARCHAR(255);

-- Remplir les nouvelles colonnes email avec les emails correspondants
UPDATE user_management.student_additional_information
SET user_email = u.email
    FROM user_management.user u
WHERE user_management.student_additional_information.user_id = u.id;

UPDATE user_management.company_additional_information
SET user_email = u.email
    FROM user_management.user u
WHERE user_management.company_additional_information.user_id = u.id;

UPDATE academic.student_skill
SET user_email = u.email
    FROM user_management.user u
WHERE academic.student_skill.user_id = u.id;

UPDATE academic.student_skill
SET validated_by_email = u.email
    FROM user_management.user u
WHERE academic.student_skill.validated_by = u.id;

UPDATE academic.student_file
SET user_email = u.email
    FROM user_management.user u
WHERE academic.student_file.user_id = u.id;

UPDATE academic.student_link
SET user_email = u.email
    FROM user_management.user u
WHERE academic.student_link.user_id = u.id;

UPDATE academic.student_filter_param
SET user_email = u.email
    FROM user_management.user u
WHERE academic.student_filter_param.user_id = u.id;

UPDATE recruitment.offer
SET company_email = u.email
    FROM user_management.user u
WHERE recruitment.offer.company_id = u.id;

UPDATE recruitment.candidature
SET user_email = u.email
    FROM user_management.user u
WHERE recruitment.candidature.user_id = u.id;

UPDATE recruitment.candidature
SET reviewed_by_email = u.email
    FROM user_management.user u
WHERE recruitment.candidature.reviewed_by = u.id;

UPDATE system.token
SET user_email = u.email
    FROM user_management.user u
WHERE system.token.user_id = u.id;

UPDATE system.traceability
SET user_email = u.email
    FROM user_management.user u
WHERE system.traceability.user_id = u.id;

UPDATE system.feedback
SET user_email = u.email
    FROM user_management.user u
WHERE system.feedback.user_id = u.id;

UPDATE system.feedback
SET resolved_by_email = u.email
    FROM user_management.user u
WHERE system.feedback.resolved_by = u.id;

-- Rendre les colonnes email NOT NULL où nécessaire (sauf pour les colonnes optionnelles)
ALTER TABLE user_management.student_additional_information
    ALTER COLUMN user_email SET NOT NULL;

ALTER TABLE user_management.company_additional_information
    ALTER COLUMN user_email SET NOT NULL;

ALTER TABLE academic.student_skill
    ALTER COLUMN user_email SET NOT NULL;
-- validated_by_email peut être NULL

ALTER TABLE academic.student_file
    ALTER COLUMN user_email SET NOT NULL;

ALTER TABLE academic.student_link
    ALTER COLUMN user_email SET NOT NULL;

ALTER TABLE academic.student_filter_param
    ALTER COLUMN user_email SET NOT NULL;

ALTER TABLE recruitment.offer
    ALTER COLUMN company_email SET NOT NULL;

ALTER TABLE recruitment.candidature
    ALTER COLUMN user_email SET NOT NULL;
-- reviewed_by_email peut être NULL

ALTER TABLE system.token
    ALTER COLUMN user_email SET NOT NULL;

ALTER TABLE system.traceability
    ALTER COLUMN user_email SET NOT NULL;

ALTER TABLE system.feedback
    ALTER COLUMN user_email SET NOT NULL;
-- resolved_by_email peut être NULL

-- Supprimer les anciennes colonnes user_id/company_id/validated_by/reviewed_by
ALTER TABLE user_management.student_additional_information
DROP COLUMN user_id;

ALTER TABLE user_management.company_additional_information
DROP COLUMN user_id;

ALTER TABLE academic.student_skill
DROP COLUMN user_id,
DROP COLUMN validated_by;

ALTER TABLE academic.student_file
DROP COLUMN user_id;

ALTER TABLE academic.student_link
DROP COLUMN user_id;

ALTER TABLE academic.student_filter_param
DROP COLUMN user_id;

ALTER TABLE recruitment.offer
DROP COLUMN company_id;

ALTER TABLE recruitment.candidature
DROP COLUMN user_id,
DROP COLUMN reviewed_by;

ALTER TABLE system.token
DROP COLUMN user_id;

ALTER TABLE system.traceability
DROP COLUMN user_id;

ALTER TABLE system.feedback
DROP COLUMN user_id,
DROP COLUMN resolved_by;

-- Étape 5: Modifier la table user pour utiliser email comme PK
ALTER TABLE user_management.user
DROP CONSTRAINT IF EXISTS user_pkey,
DROP COLUMN id,
DROP COLUMN profile_id,
DROP COLUMN role_id,
DROP CONSTRAINT IF EXISTS user_email_key;

ALTER TABLE user_management.user
    RENAME COLUMN new_profile_id TO profile_id;
ALTER TABLE user_management.user
    RENAME COLUMN new_role_id TO role_id;

-- Ajouter la clé primaire sur email
ALTER TABLE user_management.user
    ADD PRIMARY KEY (email);

-- Étape 6: Modifier les tables additional_information pour UUID
-- Table student_additional_information
ALTER TABLE user_management.student_additional_information
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

ALTER TABLE user_management.student_additional_information
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

ALTER TABLE user_management.student_additional_information
    RENAME COLUMN new_id TO id;

ALTER TABLE user_management.student_additional_information
    ADD PRIMARY KEY (id);

-- Table company_additional_information
ALTER TABLE user_management.company_additional_information
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

ALTER TABLE user_management.company_additional_information
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

ALTER TABLE user_management.company_additional_information
    RENAME COLUMN new_id TO id;

ALTER TABLE user_management.company_additional_information
    ADD PRIMARY KEY (id);

-- Étape 7: Recréer toutes les contraintes de clés étrangères
-- Contraintes dans user_management
ALTER TABLE user_management.role
    ADD CONSTRAINT role_profile_id_fkey
        FOREIGN KEY (profile_id) REFERENCES user_management.profile(id) ON DELETE SET NULL;

ALTER TABLE user_management.user
    ADD CONSTRAINT user_profile_id_fkey
        FOREIGN KEY (profile_id) REFERENCES user_management.profile(id) ON DELETE SET NULL,
    ADD CONSTRAINT user_role_id_fkey
        FOREIGN KEY (role_id) REFERENCES user_management.role(id) ON DELETE SET NULL;

ALTER TABLE user_management.student_additional_information
    ADD CONSTRAINT student_additional_information_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE;

ALTER TABLE user_management.company_additional_information
    ADD CONSTRAINT company_additional_information_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE;

-- Contraintes dans academic
ALTER TABLE academic.skill
    ADD CONSTRAINT skill_profile_id_fkey
        FOREIGN KEY (profile_id) REFERENCES user_management.profile(id) ON DELETE SET NULL;

ALTER TABLE academic.student_skill
    ADD CONSTRAINT student_skill_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE,
    ADD CONSTRAINT student_skill_validated_by_email_fkey
        FOREIGN KEY (validated_by_email) REFERENCES user_management.user(email) ON DELETE SET NULL;

ALTER TABLE academic.student_file
    ADD CONSTRAINT student_file_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE;

ALTER TABLE academic.student_link
    ADD CONSTRAINT student_link_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE;

ALTER TABLE academic.student_filter_param
    ADD CONSTRAINT student_filter_param_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE;

-- Contraintes dans recruitment
ALTER TABLE recruitment.offer
    ADD CONSTRAINT offer_company_email_fkey
        FOREIGN KEY (company_email) REFERENCES user_management.user(email) ON DELETE CASCADE;

ALTER TABLE recruitment.candidature
    ADD CONSTRAINT candidature_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE,
    ADD CONSTRAINT candidature_reviewed_by_email_fkey
        FOREIGN KEY (reviewed_by_email) REFERENCES user_management.user(email) ON DELETE SET NULL;

-- Contraintes dans system
ALTER TABLE system.token
    ADD CONSTRAINT token_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE;

ALTER TABLE system.traceability
    ADD CONSTRAINT traceability_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE;

ALTER TABLE system.feedback
    ADD CONSTRAINT feedback_user_email_fkey
        FOREIGN KEY (user_email) REFERENCES user_management.user(email) ON DELETE CASCADE,
    ADD CONSTRAINT feedback_resolved_by_email_fkey
        FOREIGN KEY (resolved_by_email) REFERENCES user_management.user(email) ON DELETE SET NULL;

-- Étape 8: Recréer les contraintes UNIQUE
ALTER TABLE user_management.student_additional_information
    ADD CONSTRAINT student_additional_information_user_email_unique
        UNIQUE (user_email);

ALTER TABLE user_management.company_additional_information
    ADD CONSTRAINT company_additional_information_user_email_unique
        UNIQUE (user_email);

-- Étape 9: Créer des index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_role_profile_id ON user_management.role(profile_id);
CREATE INDEX IF NOT EXISTS idx_user_profile_id ON user_management.user(profile_id);
CREATE INDEX IF NOT EXISTS idx_user_role_id ON user_management.user(role_id);
CREATE INDEX IF NOT EXISTS idx_student_user_email ON user_management.student_additional_information(user_email);
CREATE INDEX IF NOT EXISTS idx_company_user_email ON user_management.company_additional_information(user_email);

-- Index pour les nouvelles références email
CREATE INDEX IF NOT EXISTS idx_student_skill_user_email ON academic.student_skill(user_email);
CREATE INDEX IF NOT EXISTS idx_student_skill_validated_by_email ON academic.student_skill(validated_by_email);
CREATE INDEX IF NOT EXISTS idx_student_file_user_email ON academic.student_file(user_email);
CREATE INDEX IF NOT EXISTS idx_student_link_user_email ON academic.student_link(user_email);
CREATE INDEX IF NOT EXISTS idx_student_filter_param_user_email ON academic.student_filter_param(user_email);
CREATE INDEX IF NOT EXISTS idx_offer_company_email ON recruitment.offer(company_email);
CREATE INDEX IF NOT EXISTS idx_candidature_user_email ON recruitment.candidature(user_email);
CREATE INDEX IF NOT EXISTS idx_candidature_reviewed_by_email ON recruitment.candidature(reviewed_by_email);
CREATE INDEX IF NOT EXISTS idx_token_user_email ON system.token(user_email);
CREATE INDEX IF NOT EXISTS idx_traceability_user_email ON system.traceability(user_email);
CREATE INDEX IF NOT EXISTS idx_feedback_user_email ON system.feedback(user_email);
CREATE INDEX IF NOT EXISTS idx_feedback_resolved_by_email ON system.feedback(resolved_by_email);