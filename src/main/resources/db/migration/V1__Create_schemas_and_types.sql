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