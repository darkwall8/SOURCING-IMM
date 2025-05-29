-- =====================================================
-- SCHÉMA DE BASE DE DONNÉES POUR SYSTÈME ÉDUCATIF
-- Compatible avec jOOQ + PostgreSQL + uuid_pk DOMAIN
-- =====================================================

-- Création des extensions et domaines PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE DOMAIN uuid_pk AS UUID CHECK (VALUE IS NOT NULL);
CREATE DOMAIN email_type AS VARCHAR(255) CHECK (POSITION('@' IN VALUE) > 1);
CREATE DOMAIN name_type AS VARCHAR(255);
CREATE DOMAIN cycle AS VARCHAR(100);
CREATE DOMAIN matricule AS VARCHAR(100);

-- Création des schémas
CREATE SCHEMA IF NOT EXISTS students;
CREATE SCHEMA IF NOT EXISTS enterprises;
CREATE SCHEMA IF NOT EXISTS administrator;

-- =====================================================
-- SCHÉMA STUDENTS
-- =====================================================

CREATE TABLE students.Student (
                                  id uuid_pk PRIMARY KEY,
                                  name name_type NOT NULL,
                                  profile VARCHAR(255),
                                  school_level VARCHAR(255),
                                  surname name_type,
                                  Email email_type UNIQUE,
                                  Password VARCHAR(255),
                                  CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students.Skill (
                                id uuid_pk PRIMARY KEY,
                                name name_type NOT NULL UNIQUE
);

CREATE TABLE students.File (
                               id uuid_pk PRIMARY KEY,
                               name name_type NOT NULL,
                               file_path VARCHAR(500),
                               file_size BIGINT,
                               mime_type VARCHAR(100),
                               uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students.Link (
                               id uuid_pk PRIMARY KEY,
                               name name_type NOT NULL,
                               url VARCHAR(500) NOT NULL,
                               description TEXT
);

CREATE TABLE students.FilterParam (
                                      id uuid_pk PRIMARY KEY,
                                      name name_type NOT NULL UNIQUE,
                                      param_type VARCHAR(50),
                                      param_value TEXT
);

CREATE TABLE students.Student_Skill (
                                        id uuid_pk PRIMARY KEY,
                                        user_id uuid_pk NOT NULL REFERENCES students.Student(id) ON DELETE CASCADE,
                                        skill_id uuid_pk NOT NULL REFERENCES students.Skill(id) ON DELETE CASCADE
);

CREATE TABLE students.Student_File (
                                       id uuid_pk PRIMARY KEY,
                                       user_id uuid_pk NOT NULL REFERENCES students.Student(id) ON DELETE CASCADE,
                                       file_id uuid_pk NOT NULL REFERENCES students.File(id) ON DELETE CASCADE
);

CREATE TABLE students.Student_Link (
                                       id uuid_pk PRIMARY KEY,
                                       user_id uuid_pk NOT NULL REFERENCES students.Student(id) ON DELETE CASCADE,
                                       link_id uuid_pk NOT NULL REFERENCES students.Link(id) ON DELETE CASCADE
);

CREATE TABLE students.Student_FilterParam (
                                              id uuid_pk PRIMARY KEY,
                                              user_id uuid_pk NOT NULL REFERENCES students.Student(id) ON DELETE CASCADE,
                                              filterParam_id uuid_pk NOT NULL REFERENCES students.FilterParam(id) ON DELETE CASCADE
);

-- =====================================================
-- SCHÉMA ENTERPRISES
-- =====================================================

CREATE TABLE enterprises.Enterprise (
                                        id uuid_pk PRIMARY KEY,
                                        name name_type NOT NULL,
                                        description TEXT,
                                        logo VARCHAR(500),
                                        juridical_status VARCHAR(100),
                                        number VARCHAR(50),
                                        Email email_type UNIQUE,
                                        Password VARCHAR(255),
                                        hiring_status BOOLEAN DEFAULT FALSE,
                                        Location VARCHAR(255),
                                        CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE enterprises.HiringParam (
                                         id uuid_pk PRIMARY KEY,
                                         enterprise_id uuid_pk NOT NULL REFERENCES enterprises.Enterprise(id) ON DELETE CASCADE,
                                         hiringParam_id uuid_pk NOT NULL,
                                         param_name name_type,
                                         param_value TEXT
);

CREATE TABLE enterprises.OfferCall (
                                       id uuid_pk PRIMARY KEY,
                                       enterprise_id uuid_pk NOT NULL REFERENCES enterprises.Enterprise(id) ON DELETE CASCADE,
                                       postName name_type NOT NULL,
                                       postDescription TEXT,
                                       requirements TEXT,
                                       period VARCHAR(100),
                                       location VARCHAR(255),
                                       salary_range VARCHAR(100),
                                       contract_type VARCHAR(50),
                                       endDate TIMESTAMP,
                                       createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       isActive BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- SCHÉMA ADMINISTRATOR
-- =====================================================

CREATE TABLE administrator.Admin (
                                     id uuid_pk PRIMARY KEY,
                                     name name_type NOT NULL,
                                     profile VARCHAR(255),
                                     Email email_type UNIQUE NOT NULL,
                                     Password VARCHAR(255) NOT NULL,
                                     role VARCHAR(50) DEFAULT 'ADMIN',
                                     CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     LastLogin TIMESTAMP NULL
);

-- =====================================================
-- INDEXES POUR OPTIMISATION
-- =====================================================

CREATE INDEX idx_student_email ON students.Student(Email);
CREATE INDEX idx_student_name ON students.Student(name);
CREATE INDEX idx_enterprise_email ON enterprises.Enterprise(Email);
CREATE INDEX idx_enterprise_name ON enterprises.Enterprise(name);
CREATE INDEX idx_admin_email ON administrator.Admin(Email);

CREATE INDEX idx_student_skill_user ON students.Student_Skill(user_id);
CREATE INDEX idx_student_file_user ON students.Student_File(user_id);
CREATE INDEX idx_student_link_user ON students.Student_Link(user_id);
CREATE INDEX idx_student_filter_user ON students.Student_FilterParam(user_id);
CREATE INDEX idx_hiring_param_enterprise ON enterprises.HiringParam(enterprise_id);