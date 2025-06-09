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