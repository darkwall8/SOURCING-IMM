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