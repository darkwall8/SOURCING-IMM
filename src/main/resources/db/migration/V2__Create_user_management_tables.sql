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