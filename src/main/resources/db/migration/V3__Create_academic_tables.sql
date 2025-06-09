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
