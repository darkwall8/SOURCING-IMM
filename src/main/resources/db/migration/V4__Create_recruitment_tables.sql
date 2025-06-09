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