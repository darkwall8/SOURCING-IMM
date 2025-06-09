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