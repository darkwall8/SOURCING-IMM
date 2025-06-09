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