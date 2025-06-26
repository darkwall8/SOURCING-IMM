-- =========================================
-- V15__Modify_usual.sql
-- Cette migration est pour modifier tous les
-- oublies fait dans les précédentes migrations
-- =========================================

-- Supprimer l'attribut address dans la table student_additional_informations
ALTER TABLE user_management.student_additional_information
DROP COLUMN address;