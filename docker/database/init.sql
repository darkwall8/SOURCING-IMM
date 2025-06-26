-- =========================================
-- V1__Create_schemas_and_types.sql
-- =========================================

-- Suppression si éxistant

DROP SCHEMA IF EXISTS user_management CASCADE;
DROP SCHEMA IF EXISTS academic CASCADE;
DROP SCHEMA IF EXISTS recruitment CASCADE;
DROP SCHEMA IF EXISTS system CASCADE;

-- Création des schémas
CREATE SCHEMA IF NOT EXISTS user_management;
CREATE SCHEMA IF NOT EXISTS academic;
CREATE SCHEMA IF NOT EXISTS recruitment;
CREATE SCHEMA IF NOT EXISTS system;

-- Création des types énumérés
CREATE TYPE user_management.user_role_enum AS ENUM ('STUDENT', 'COMPANY', 'ADMIN', 'MODERATOR');
CREATE TYPE user_management.profile_type_enum AS ENUM ('TECHNICAL', 'BUSINESS', 'CREATIVE', 'RESEARCH');
CREATE TYPE recruitment.offer_status_enum AS ENUM ('DRAFT', 'PUBLISHED', 'CLOSED', 'EXPIRED');
CREATE TYPE recruitment.candidature_status_enum AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'WITHDRAWN');
CREATE TYPE recruitment.offer_type_enum AS ENUM ('INTERNSHIP', 'FULL_TIME', 'PART_TIME', 'CONTRACT', 'FREELANCE');
CREATE TYPE academic.skill_level_enum AS ENUM ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT');
CREATE TYPE system.token_type_enum AS ENUM ('ACTIVATION', 'RESET_PASSWORD', 'REFRESH');

-- =========================================
-- V2__Create_user_management_tables.sql
-- =========================================

-- Table des profils utilisateur
CREATE TABLE user_management.profile (
                                         id SERIAL PRIMARY KEY,
                                         name VARCHAR(100) NOT NULL UNIQUE,
                                         description TEXT,
                                         profile_type user_management.profile_type_enum NOT NULL,
                                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des rôles
CREATE TABLE user_management.role (
                                      id SERIAL PRIMARY KEY,
                                      name VARCHAR(50) NOT NULL UNIQUE,
                                      description TEXT,
                                      permissions JSONB,
                                      profile_id INTEGER REFERENCES user_management.profile(id) ON DELETE SET NULL,
                                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table principale des utilisateurs
CREATE TABLE user_management.user (
                                      id SERIAL PRIMARY KEY,
                                      name VARCHAR(255) NOT NULL,
                                      email VARCHAR(255) UNIQUE NOT NULL,
                                      password VARCHAR(255) NOT NULL,
                                      profile_id INTEGER REFERENCES user_management.profile(id) ON DELETE SET NULL,
                                      role_id INTEGER REFERENCES user_management.role(id) ON DELETE SET NULL,
                                      has_premium BOOLEAN DEFAULT FALSE,
                                      is_activated BOOLEAN DEFAULT FALSE,
                                      last_login TIMESTAMP,
                                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des informations supplémentaires étudiant
CREATE TABLE user_management.student_additional_information (
                                                                id SERIAL PRIMARY KEY,
                                                                user_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                                                                university VARCHAR(255),
                                                                graduation_year INTEGER,
                                                                current_level VARCHAR(100),
                                                                portfolio_url VARCHAR(500),
                                                                github_url VARCHAR(500),
                                                                linkedin_url VARCHAR(500),
                                                                phone VARCHAR(20),
                                                                address TEXT,
                                                                bio TEXT,
                                                                availability_date DATE,
                                                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                                UNIQUE(user_id)
);

-- Table des informations supplémentaires entreprise
CREATE TABLE user_management.company_additional_information (
                                                                id SERIAL PRIMARY KEY,
                                                                user_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                                                                company_name VARCHAR(255) NOT NULL,
                                                                siret VARCHAR(14),
                                                                industry VARCHAR(100),
                                                                company_size VARCHAR(50),
                                                                website VARCHAR(500),
                                                                description TEXT,
                                                                address TEXT,
                                                                contact_person VARCHAR(255),
                                                                contact_phone VARCHAR(20),
                                                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                                UNIQUE(user_id)
);

-- =========================================
-- V3__Create_academic_tables.sql
-- =========================================

-- Table des compétences
CREATE TABLE academic.skill (
                                id SERIAL PRIMARY KEY,
                                name VARCHAR(100) NOT NULL UNIQUE,
                                description TEXT,
                                category VARCHAR(50),
                                profile_id INTEGER REFERENCES user_management.profile(id) ON DELETE SET NULL,
                                is_active BOOLEAN DEFAULT TRUE,
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table de liaison étudiant-compétences
CREATE TABLE academic.student_skill (
                                        id SERIAL PRIMARY KEY,
                                        user_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                                        skill_id INTEGER NOT NULL REFERENCES academic.skill(id) ON DELETE CASCADE,
                                        level academic.skill_level_enum DEFAULT 'BEGINNER',
                                        validated BOOLEAN DEFAULT FALSE,
                                        validated_by INTEGER REFERENCES user_management.user(id),
                                        validated_at TIMESTAMP,
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        UNIQUE(user_id, skill_id)
);

-- Table des fichiers étudiants
CREATE TABLE academic.student_file (
                                       id SERIAL PRIMARY KEY,
                                       user_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                                       filename VARCHAR(255) NOT NULL,
                                       original_name VARCHAR(255) NOT NULL,
                                       file_path VARCHAR(500) NOT NULL,
                                       file_type VARCHAR(50),
                                       file_size INTEGER,
                                       description TEXT,
                                       is_public BOOLEAN DEFAULT FALSE,
                                       uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des liens étudiants
CREATE TABLE academic.student_link (
                                       id SERIAL PRIMARY KEY,
                                       user_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                                       name VARCHAR(255) NOT NULL,
                                       url VARCHAR(500) NOT NULL,
                                       description TEXT,
                                       link_type VARCHAR(50), -- 'portfolio', 'project', 'social', 'other'
                                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des paramètres de filtre étudiant
CREATE TABLE academic.student_filter_param (
                                               id SERIAL PRIMARY KEY,
                                               user_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                                               filter_name VARCHAR(100) NOT NULL,
                                               filter_value JSONB NOT NULL,
                                               is_default BOOLEAN DEFAULT FALSE,
                                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                               UNIQUE(user_id, filter_name)
);

-- =========================================
-- V4__Create_recruitment_tables.sql
-- =========================================

-- Table des offres
CREATE TABLE recruitment.offer (
                                   id SERIAL PRIMARY KEY,
                                   title VARCHAR(255) NOT NULL,
                                   description TEXT NOT NULL,
                                   company_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                                   offer_type recruitment.offer_type_enum NOT NULL,
                                   status recruitment.offer_status_enum DEFAULT 'DRAFT',
                                   location VARCHAR(255),
                                   remote_possible BOOLEAN DEFAULT FALSE,
                                   salary_min INTEGER,
                                   salary_max INTEGER,
                                   currency VARCHAR(3) DEFAULT 'EUR',
                                   duration_months INTEGER,
                                   start_date DATE,
                                   limit_date DATE,
                                   is_remunerated BOOLEAN DEFAULT TRUE,
                                   required_level VARCHAR(100),
                                   benefits TEXT,
                                   application_process TEXT,
                                   views_count INTEGER DEFAULT 0,
                                   applications_count INTEGER DEFAULT 0,
                                   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   published_at TIMESTAMP
);

-- Table de liaison offre-compétences requises
CREATE TABLE recruitment.offer_required_skill (
                                                  id SERIAL PRIMARY KEY,
                                                  offer_id INTEGER NOT NULL REFERENCES recruitment.offer(id) ON DELETE CASCADE,
                                                  skill_id INTEGER NOT NULL REFERENCES academic.skill(id) ON DELETE CASCADE,
                                                  required_level academic.skill_level_enum DEFAULT 'INTERMEDIATE',
                                                  is_mandatory BOOLEAN DEFAULT TRUE,
                                                  weight INTEGER DEFAULT 1, -- Poids pour le scoring
                                                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                  UNIQUE(offer_id, skill_id)
);

-- Table des candidatures
CREATE TABLE recruitment.candidature (
                                         id SERIAL PRIMARY KEY,
                                         user_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                                         offer_id INTEGER NOT NULL REFERENCES recruitment.offer(id) ON DELETE CASCADE,
                                         status recruitment.candidature_status_enum DEFAULT 'PENDING',
                                         cover_letter TEXT,
                                         resume_file_id INTEGER REFERENCES academic.student_file(id),
                                         additional_documents INTEGER[] DEFAULT '{}', -- Array d'IDs de fichiers
                                         motivation TEXT,
                                         expected_salary INTEGER,
                                         availability_date DATE,
                                         notes TEXT, -- Notes internes de l'entreprise
                                         score INTEGER, -- Score automatique basé sur les compétences
                                         applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                         reviewed_at TIMESTAMP,
                                         reviewed_by INTEGER REFERENCES user_management.user(id),
                                         response_date TIMESTAMP,
                                         UNIQUE(user_id, offer_id)
);

-- =========================================
-- V5__Create_system_tables.sql
-- =========================================

-- Table des tokens
CREATE TABLE system.token (
                              id SERIAL PRIMARY KEY,
                              user_id INTEGER NOT NULL REFERENCES user_management.user(id) ON DELETE CASCADE,
                              token_hash VARCHAR(255) NOT NULL UNIQUE,
                              token_type system.token_type_enum NOT NULL,
                              expires_at TIMESTAMP NOT NULL,
                              used_at TIMESTAMP,
                              is_revoked BOOLEAN DEFAULT FALSE,
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              metadata JSONB -- Informations supplémentaires (IP, user-agent, etc.)
);

-- Table de traçabilité
CREATE TABLE system.traceability (
                                     id SERIAL PRIMARY KEY,
                                     user_id INTEGER REFERENCES user_management.user(id) ON DELETE SET NULL,
                                     action VARCHAR(100) NOT NULL,
                                     entity_type VARCHAR(50), -- 'user', 'offer', 'candidature', etc.
                                     entity_id INTEGER,
                                     old_values JSONB,
                                     new_values JSONB,
                                     ip_address INET,
                                     user_agent TEXT,
                                     session_id VARCHAR(255),
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des feedbacks
CREATE TABLE system.feedback (
                                 id SERIAL PRIMARY KEY,
                                 user_id INTEGER REFERENCES user_management.user(id) ON DELETE SET NULL,
                                 feedback_type VARCHAR(50) NOT NULL, -- 'bug', 'feature', 'general', etc.
                                 subject VARCHAR(255),
                                 message TEXT NOT NULL,
                                 rating INTEGER CHECK (rating >= 1 AND rating <= 5),
                                 is_resolved BOOLEAN DEFAULT FALSE,
                                 resolved_by INTEGER REFERENCES user_management.user(id),
                                 resolved_at TIMESTAMP,
                                 resolution_notes TEXT,
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- V6__Create_indexes.sql
-- =========================================

-- Index pour user_management
CREATE INDEX idx_user_email ON user_management.user(email);
CREATE INDEX idx_user_profile ON user_management.user(profile_id);
CREATE INDEX idx_user_role ON user_management.user(role_id);
CREATE INDEX idx_user_activated ON user_management.user(is_activated);
CREATE INDEX idx_user_premium ON user_management.user(has_premium);

-- Index pour academic
CREATE INDEX idx_skill_category ON academic.skill(category);
CREATE INDEX idx_skill_profile ON academic.skill(profile_id);
CREATE INDEX idx_student_skill_user ON academic.student_skill(user_id);
CREATE INDEX idx_student_skill_skill ON academic.student_skill(skill_id);
CREATE INDEX idx_student_skill_level ON academic.student_skill(level);
CREATE INDEX idx_student_file_user ON academic.student_file(user_id);
CREATE INDEX idx_student_file_type ON academic.student_file(file_type);

-- Index pour recruitment
CREATE INDEX idx_offer_company ON recruitment.offer(company_id);
CREATE INDEX idx_offer_status ON recruitment.offer(status);
CREATE INDEX idx_offer_type ON recruitment.offer(offer_type);
CREATE INDEX idx_offer_location ON recruitment.offer(location);
CREATE INDEX idx_offer_limit_date ON recruitment.offer(limit_date);
CREATE INDEX idx_offer_created ON recruitment.offer(created_at);

CREATE INDEX idx_candidature_user ON recruitment.candidature(user_id);
CREATE INDEX idx_candidature_offer ON recruitment.candidature(offer_id);
CREATE INDEX idx_candidature_status ON recruitment.candidature(status);
CREATE INDEX idx_candidature_applied ON recruitment.candidature(applied_at);
CREATE INDEX idx_candidature_score ON recruitment.candidature(score);

-- Index pour system
CREATE INDEX idx_token_user ON system.token(user_id);
CREATE INDEX idx_token_type ON system.token(token_type);
CREATE INDEX idx_token_expires ON system.token(expires_at);
CREATE INDEX idx_token_hash ON system.token(token_hash);

CREATE INDEX idx_traceability_user ON system.traceability(user_id);
CREATE INDEX idx_traceability_action ON system.traceability(action);
CREATE INDEX idx_traceability_entity ON system.traceability(entity_type, entity_id);
CREATE INDEX idx_traceability_created ON system.traceability(created_at);

CREATE INDEX idx_feedback_user ON system.feedback(user_id);
CREATE INDEX idx_feedback_type ON system.feedback(feedback_type);
CREATE INDEX idx_feedback_resolved ON system.feedback(is_resolved);

-- =========================================
-- V7__Create_triggers_and_functions.sql
-- =========================================

-- Fonction pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers pour updated_at
CREATE TRIGGER update_user_updated_at
    BEFORE UPDATE ON user_management.user
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profile_updated_at
    BEFORE UPDATE ON user_management.profile
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_student_info_updated_at
    BEFORE UPDATE ON user_management.student_additional_information
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_company_info_updated_at
    BEFORE UPDATE ON user_management.company_additional_information
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_offer_updated_at
    BEFORE UPDATE ON recruitment.offer
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Fonction pour incrémenter le compteur de candidatures
CREATE OR REPLACE FUNCTION increment_applications_count()
    RETURNS TRIGGER AS $$
BEGIN
    UPDATE recruitment.offer
    SET applications_count = applications_count + 1
    WHERE id = NEW.offer_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour compter les candidatures
CREATE TRIGGER increment_offer_applications
    AFTER INSERT ON recruitment.candidature
    FOR EACH ROW EXECUTE FUNCTION increment_applications_count();

-- =========================================
-- V8__Insert_initial_data.sql
-- =========================================

-- Insertion des profils de base
INSERT INTO user_management.profile (name, description, profile_type) VALUES
                                                                          ('Développeur Full-Stack', 'Profil pour développeurs maîtrisant front-end et back-end', 'TECHNICAL'),
                                                                          ('Designer UX/UI', 'Profil pour designers d''expérience utilisateur et interface', 'CREATIVE'),
                                                                          ('Data Scientist', 'Profil pour analystes et scientifiques des données', 'RESEARCH'),
                                                                          ('Chef de Projet', 'Profil pour gestionnaires de projets', 'BUSINESS'),
                                                                          ('Marketing Digital', 'Profil pour spécialistes du marketing numérique', 'BUSINESS');

-- Insertion des rôles de base
INSERT INTO user_management.role (name, description, permissions) VALUES
                                                                      ('STUDENT', 'Étudiant cherchant des opportunités', '{"can_apply": true, "can_view_offers": true}'),
                                                                      ('COMPANY', 'Entreprise publiant des offres', '{"can_post_offers": true, "can_view_candidates": true}'),
                                                                      ('ADMIN', 'Administrateur système', '{"full_access": true}'),
                                                                      ('MODERATOR', 'Modérateur de contenu', '{"can_moderate": true, "can_validate": true}');

-- Insertion des compétences de base
INSERT INTO academic.skill (name, description, category) VALUES
-- Langages de programmation
('JavaScript', 'Langage de programmation web', 'Programming'),
('Python', 'Langage de programmation polyvalent', 'Programming'),
('Java', 'Langage de programmation orienté objet', 'Programming'),
('TypeScript', 'JavaScript avec typage statique', 'Programming'),
('PHP', 'Langage de programmation web côté serveur', 'Programming'),

-- Frameworks
('React', 'Bibliothèque JavaScript pour interfaces utilisateur', 'Frontend'),
('Vue.js', 'Framework JavaScript progressif', 'Frontend'),
('Angular', 'Framework TypeScript pour applications web', 'Frontend'),
('Node.js', 'Runtime JavaScript côté serveur', 'Backend'),
('Spring Boot', 'Framework Java pour applications', 'Backend'),

-- Bases de données
('PostgreSQL', 'Système de gestion de base de données', 'Database'),
('MySQL', 'Système de gestion de base de données', 'Database'),
('MongoDB', 'Base de données NoSQL', 'Database'),

-- Outils
('Git', 'Système de contrôle de version', 'Tools'),
('Docker', 'Plateforme de conteneurisation', 'DevOps'),
('AWS', 'Services cloud Amazon', 'Cloud'),

-- Design
('Figma', 'Outil de design d''interface', 'Design'),
('Adobe Photoshop', 'Logiciel de retouche photo', 'Design'),
('UI Design', 'Conception d''interfaces utilisateur', 'Design'),
('UX Design', 'Conception d''expérience utilisateur', 'Design');

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

-- =========================================
-- V10__Convert_tables_to_uuid.sql
-- Migration pour convertir les tables student_file, student_filter_param,
-- student_link, student_skill, candidature et offer vers UUID
-- =========================================

-- Activer l'extension UUID si pas déjà fait
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================
-- ÉTAPE 1: Identifier et supprimer TOUTES les contraintes FK qui dépendent des tables à modifier
-- =========================================

-- Contraintes qui référencent student_file.id
ALTER TABLE recruitment.candidature
    DROP CONSTRAINT IF EXISTS candidature_resume_file_id_fkey;

-- Contraintes qui référencent offer.id
ALTER TABLE recruitment.candidature
    DROP CONSTRAINT IF EXISTS candidature_offer_id_fkey;

ALTER TABLE recruitment.offer_required_skill
    DROP CONSTRAINT IF EXISTS offer_required_skill_offer_id_fkey;

-- Contraintes qui référencent student_skill.id (si elles existent)
ALTER TABLE recruitment.offer_required_skill
    DROP CONSTRAINT IF EXISTS offer_required_skill_skill_id_fkey;

-- =========================================
-- ÉTAPE 2: Convertir academic.student_skill
-- =========================================

-- Ajouter colonne temporaire pour stocker les nouveaux UUID
ALTER TABLE academic.student_skill
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mettre à jour les références dans offer_required_skill (si skill_id existe)
ALTER TABLE recruitment.offer_required_skill
    ADD COLUMN IF NOT EXISTS new_skill_id UUID;

-- Mettre à jour les références avec les nouveaux UUID
UPDATE recruitment.offer_required_skill
SET new_skill_id = ss.new_id
FROM academic.student_skill ss
WHERE recruitment.offer_required_skill.skill_id = ss.id;

-- Supprimer l'ancienne clé primaire et colonne id de student_skill
ALTER TABLE academic.student_skill
    DROP CONSTRAINT IF EXISTS student_skill_pkey,
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE academic.student_skill
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE academic.student_skill
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 3: Convertir academic.student_file
-- =========================================

-- Ajouter colonne temporaire pour stocker les nouveaux UUID
ALTER TABLE academic.student_file
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mettre à jour les références dans candidature (si resume_file_id existe)
ALTER TABLE recruitment.candidature
    ADD COLUMN IF NOT EXISTS new_resume_file_id UUID;

-- Mettre à jour les références avec les nouveaux UUID
UPDATE recruitment.candidature
SET new_resume_file_id = sf.new_id
FROM academic.student_file sf
WHERE recruitment.candidature.resume_file_id = sf.id;

-- Supprimer l'ancienne clé primaire et colonne id de student_file
ALTER TABLE academic.student_file
    DROP CONSTRAINT IF EXISTS student_file_pkey,
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE academic.student_file
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE academic.student_file
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 4: Convertir academic.student_link
-- =========================================

-- Ajouter la nouvelle colonne UUID
ALTER TABLE academic.student_link
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Supprimer l'ancienne clé primaire et colonne id
ALTER TABLE academic.student_link
    DROP CONSTRAINT IF EXISTS student_link_pkey,
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE academic.student_link
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE academic.student_link
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 5: Convertir academic.student_filter_param
-- =========================================

-- Ajouter la nouvelle colonne UUID
ALTER TABLE academic.student_filter_param
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Supprimer l'ancienne clé primaire et colonne id
ALTER TABLE academic.student_filter_param
    DROP CONSTRAINT IF EXISTS student_filter_param_pkey,
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE academic.student_filter_param
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE academic.student_filter_param
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 6: Convertir recruitment.offer
-- =========================================

-- Ajouter colonne temporaire pour stocker les nouveaux UUID
ALTER TABLE recruitment.offer
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mettre à jour les références dans candidature (si offer_id existe)
ALTER TABLE recruitment.candidature
    ADD COLUMN IF NOT EXISTS new_offer_id UUID;

-- Mettre à jour les références dans offer_required_skill
ALTER TABLE recruitment.offer_required_skill
    ADD COLUMN IF NOT EXISTS new_offer_id UUID;

-- Mettre à jour les références avec les nouveaux UUID
UPDATE recruitment.candidature
SET new_offer_id = o.new_id
FROM recruitment.offer o
WHERE recruitment.candidature.offer_id = o.id;

UPDATE recruitment.offer_required_skill
SET new_offer_id = o.new_id
FROM recruitment.offer o
WHERE recruitment.offer_required_skill.offer_id = o.id;

-- Supprimer l'ancienne clé primaire et colonne id de offer
ALTER TABLE recruitment.offer
    DROP CONSTRAINT IF EXISTS offer_pkey,
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE recruitment.offer
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE recruitment.offer
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 7: Convertir recruitment.candidature
-- =========================================

-- Ajouter la nouvelle colonne UUID
ALTER TABLE recruitment.candidature
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Supprimer l'ancienne clé primaire et colonne id
ALTER TABLE recruitment.candidature
    DROP CONSTRAINT IF EXISTS candidature_pkey,
    DROP COLUMN id,
    ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE recruitment.candidature
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE recruitment.candidature
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 8: Finaliser les références dans les tables dépendantes
-- =========================================

-- Finaliser offer_required_skill.skill_id si elle existe
DO $$
    BEGIN
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'recruitment'
              AND table_name = 'offer_required_skill'
              AND column_name = 'skill_id'
        ) THEN
            -- Supprimer l'ancienne colonne et renommer la nouvelle
            ALTER TABLE recruitment.offer_required_skill
                DROP COLUMN skill_id;

            ALTER TABLE recruitment.offer_required_skill
                RENAME COLUMN new_skill_id TO skill_id;
        END IF;
    END $$;

-- Finaliser offer_required_skill.offer_id
DO $$
    BEGIN
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'recruitment'
              AND table_name = 'offer_required_skill'
              AND column_name = 'offer_id'
        ) THEN
            -- Supprimer l'ancienne colonne et renommer la nouvelle
            ALTER TABLE recruitment.offer_required_skill
                DROP COLUMN offer_id;

            ALTER TABLE recruitment.offer_required_skill
                RENAME COLUMN new_offer_id TO offer_id;
        END IF;
    END $$;

-- Finaliser candidature.resume_file_id si elle existe
DO $$
    BEGIN
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'recruitment'
              AND table_name = 'candidature'
              AND column_name = 'resume_file_id'
        ) THEN
            -- Supprimer l'ancienne colonne et renommer la nouvelle
            ALTER TABLE recruitment.candidature
                DROP COLUMN resume_file_id;

            ALTER TABLE recruitment.candidature
                RENAME COLUMN new_resume_file_id TO resume_file_id;
        END IF;
    END $$;

-- Finaliser candidature.offer_id si elle existe
DO $$
    BEGIN
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'recruitment'
              AND table_name = 'candidature'
              AND column_name = 'offer_id'
        ) THEN
            -- Supprimer l'ancienne colonne et renommer la nouvelle
            ALTER TABLE recruitment.candidature
                DROP COLUMN offer_id;

            ALTER TABLE recruitment.candidature
                RENAME COLUMN new_offer_id TO offer_id;
        END IF;
    END $$;

-- =========================================
-- ÉTAPE 9: Recréer les contraintes de clés étrangères
-- =========================================

-- Recréer les contraintes pour offer_required_skill
DO $$
    BEGIN
        -- Pour skill_id
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'recruitment'
              AND table_name = 'offer_required_skill'
              AND column_name = 'skill_id'
        ) THEN
            ALTER TABLE recruitment.offer_required_skill
                ADD CONSTRAINT offer_required_skill_skill_id_fkey
                    FOREIGN KEY (skill_id) REFERENCES academic.student_skill(id) ON DELETE CASCADE;
        END IF;

        -- Pour offer_id
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'recruitment'
              AND table_name = 'offer_required_skill'
              AND column_name = 'offer_id'
        ) THEN
            ALTER TABLE recruitment.offer_required_skill
                ADD CONSTRAINT offer_required_skill_offer_id_fkey
                    FOREIGN KEY (offer_id) REFERENCES recruitment.offer(id) ON DELETE CASCADE;
        END IF;
    END $$;

-- Recréer la contrainte pour candidature.resume_file_id si elle existe
DO $$
    BEGIN
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'recruitment'
              AND table_name = 'candidature'
              AND column_name = 'resume_file_id'
        ) THEN
            ALTER TABLE recruitment.candidature
                ADD CONSTRAINT candidature_resume_file_id_fkey
                    FOREIGN KEY (resume_file_id) REFERENCES academic.student_file(id) ON DELETE SET NULL;
        END IF;
    END $$;

-- Recréer la contrainte pour candidature.offer_id si elle existe
DO $$
    BEGIN
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'recruitment'
              AND table_name = 'candidature'
              AND column_name = 'offer_id'
        ) THEN
            ALTER TABLE recruitment.candidature
                ADD CONSTRAINT candidature_offer_id_fkey
                    FOREIGN KEY (offer_id) REFERENCES recruitment.offer(id) ON DELETE CASCADE;
        END IF;
    END $$;

-- =========================================
-- ÉTAPE 10: Créer des index pour optimiser les performances
-- =========================================

-- Index sur les colonnes de recherche fréquentes
CREATE INDEX IF NOT EXISTS idx_student_skill_id ON academic.student_skill(id);
CREATE INDEX IF NOT EXISTS idx_student_file_id ON academic.student_file(id);
CREATE INDEX IF NOT EXISTS idx_student_link_id ON academic.student_link(id);
CREATE INDEX IF NOT EXISTS idx_student_filter_param_id ON academic.student_filter_param(id);
CREATE INDEX IF NOT EXISTS idx_candidature_id ON recruitment.candidature(id);
CREATE INDEX IF NOT EXISTS idx_offer_id ON recruitment.offer(id);

-- Index sur les colonnes de clés étrangères
CREATE INDEX IF NOT EXISTS idx_candidature_resume_file_id ON recruitment.candidature(resume_file_id);
CREATE INDEX IF NOT EXISTS idx_candidature_offer_id ON recruitment.candidature(offer_id);
CREATE INDEX IF NOT EXISTS idx_offer_required_skill_offer_id ON recruitment.offer_required_skill(offer_id);
CREATE INDEX IF NOT EXISTS idx_offer_required_skill_skill_id ON recruitment.offer_required_skill(skill_id);

-- =========================================
-- ÉTAPE 11: Nettoyage des colonnes temporaires
-- =========================================

-- Supprimer les colonnes temporaires qui pourraient rester
ALTER TABLE recruitment.candidature
    DROP COLUMN IF EXISTS new_resume_file_id,
    DROP COLUMN IF EXISTS new_offer_id;

ALTER TABLE recruitment.offer_required_skill
    DROP COLUMN IF EXISTS new_offer_id,
    DROP COLUMN IF EXISTS new_skill_id;

-- =========================================
-- ÉTAPE 12: Vérifications finales (commentées)
-- =========================================

/*
-- Vérifier que toutes les tables ont bien des UUID comme clés primaires
SELECT
    table_schema,
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE column_name = 'id'
AND table_schema IN ('academic', 'recruitment')
AND table_name IN ('student_skill', 'student_file', 'student_link', 'student_filter_param', 'candidature', 'offer');

-- Vérifier les contraintes de clés primaires
SELECT
    tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.constraint_type = 'PRIMARY KEY'
AND tc.table_schema IN ('academic', 'recruitment')
AND tc.table_name IN ('student_skill', 'student_file', 'student_link', 'student_filter_param', 'candidature', 'offer');

-- Vérifier les contraintes de clés étrangères
SELECT
    tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_schema = 'recruitment'
AND (tc.table_name = 'candidature' OR tc.table_name = 'offer_required_skill')
AND (kcu.column_name LIKE '%_id' OR kcu.column_name LIKE '%_email');
*/

-- =========================================
-- V11__Add_latest_additional_information.sql
-- migration pour ajouter les informations de company
-- =========================================


-- Migration pour modifier la table company_additional_information
-- Fichier: xxxx_xx_xx_xxxxxx_modify_company_additional_information_table.sql

-- Supprimer les colonnes siret et contact_person
ALTER TABLE user_management.company_additional_information
    DROP COLUMN IF EXISTS siret,
    DROP COLUMN IF EXISTS contact_person;

-- Ajouter les nouvelles colonnes
ALTER TABLE user_management.company_additional_information
    ADD COLUMN company_corporate VARCHAR(255),
    ADD COLUMN company_rccm VARCHAR(100),
    ADD COLUMN company_niu VARCHAR(50),
    ADD COLUMN company_commercial_register VARCHAR(100),
    ADD COLUMN company_legal_status VARCHAR(100),
    ADD COLUMN company_tax_conformity_certificate VARCHAR(255),
    ADD COLUMN company_static_declaration_number VARCHAR(100),
    ADD COLUMN company_internship_duration INTEGER,
    ADD COLUMN company_has_intern_opportunity BOOLEAN DEFAULT FALSE;


-- Migration pour changer l'ID de la table offer_required_skill de INTEGER vers UUID
-- Fichier: xxxx_xx_xx_xxxxxx_change_offer_required_skill_id_to_uuid.sql

-- Étape 1: Créer une nouvelle colonne UUID temporaire
ALTER TABLE recruitment.offer_required_skill ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Étape 2: Mettre à jour toutes les lignes avec des UUIDs uniques
UPDATE recruitment.offer_required_skill SET new_id = uuid_generate_v4() WHERE new_id IS NULL;

-- Étape 3: Supprimer la contrainte de clé primaire existante
ALTER TABLE recruitment.offer_required_skill DROP CONSTRAINT IF EXISTS offer_required_skill_pkey;

-- Étape 4: Supprimer l'ancienne colonne id
ALTER TABLE recruitment.offer_required_skill DROP COLUMN id;

-- Étape 5: Renommer la nouvelle colonne
ALTER TABLE recruitment.offer_required_skill RENAME COLUMN new_id TO id;

-- Étape 6: Ajouter la contrainte NOT NULL et définir comme clé primaire
ALTER TABLE recruitment.offer_required_skill ALTER COLUMN id SET NOT NULL;
ALTER TABLE recruitment.offer_required_skill ADD PRIMARY KEY (id);

-- Étape 7: Créer un index sur la nouvelle colonne UUID (optionnel mais recommandé)
CREATE INDEX IF NOT EXISTS idx_offer_required_skill_id ON recruitment.offer_required_skill(id);

-- =========================================
-- V12__Add_latest_additional_information.sql
-- migration pour modifier le type de l'id de
-- la table feedback d'integer vers uuid
-- =========================================

-- Activer l'extension UUID si elle n'est pas déjà active
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Création d'une nouvelle colonne UUID temporaire
ALTER TABLE system.feedback ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mise à jour des lignes avec des UUIDs uniques
UPDATE system.feedback SET new_id = uuid_generate_v4() WHERE new_id IS NULL;

-- Supprimer la contrainte de clé primaire existante
ALTER TABLE system.feedback DROP CONSTRAINT IF EXISTS feedback_pkey;

-- Supprimer l'ancienne colonne id
ALTER TABLE system.feedback DROP COLUMN id;

-- Renommer la nouvelle colonne en 'id'
ALTER TABLE system.feedback RENAME COLUMN new_id TO id;

-- Ajouter la contrainte NOT NULL et définir comme clé primaire
ALTER TABLE system.feedback ALTER COLUMN id SET NOT NULL;
ALTER TABLE system.feedback ADD PRIMARY KEY (id);

-- Créer un index sur la nouvelle colonne UUID (optionnel car PRIMARY KEY crée déjà un index)
-- CREATE INDEX IF NOT EXISTS idx_feedback_id ON system.feedback(id);

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

-- =========================================
-- V14__Modfiy_forgotten_informations.sql
-- migration pour modifier les informations
-- oubliées dans la migration 13
-- =========================================

-- Suppression de student_file
DROP TABLE IF EXISTS academic.student_file;

-- Suppression de la table student_link
DROP TABLE IF EXISTS academic.student_link

-- =========================================
-- V15__Modify_usual.sql
-- Cette migration est pour modifier tous les
-- oublies fait dans les précédentes migrations
-- =========================================

-- Supprimer l'attribut address dans la table student_additional_informations
ALTER TABLE user_management.student_additional_information
    DROP COLUMN address;

-- =========================================
-- V16__Update_user_tables.sql
-- Cette migration est pour modifier la table user
-- =========================================

-- Alter table user
ALTER TABLE user_management."user"
    DROP COLUMN password,
    DROP COLUMN profile_id;

ALTER TABLE user_management."user"
    ADD COLUMN profile VARCHAR(255);