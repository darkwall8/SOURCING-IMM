-- =========================================
-- V14__Modfiy_forgotten_informations.sql
-- migration pour modifier les informations
-- oubliées dans la migration 13
-- =========================================

-- Suppression de student_file
DROP TABLE IF EXISTS academic.student_file;

-- Suppression de la table student_link
DROP TABLE IF EXISTS academic.student_link