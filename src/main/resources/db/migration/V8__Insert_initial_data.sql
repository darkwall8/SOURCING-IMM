-- =========================================
-- V8__Insert_initial_data.sql
-- =========================================

-- Insertion des profils de base
INSERT INTO user_management.profile (name, description, profile_type) VALUES
                                                                          ('Développeur Full-Stack', 'Profil pour développeurs maîtrisant front-end et back-end', 'TECHNICAL'),
                                                                          ('Designer UX/UI', 'Profil pour designers d''expérience utilisateur et interface', 'CREATIVE'),
                                                                          ('Data Scientist', 'Profil pour analystes et scientifiques des données', 'RESEARCH'),
                                                                          ('Chef de Projet', 'Profil pour gestionnaires de projets', 'BUSINESS'),
                                                                          ('Marketing Digital', 'Profil pour spécialistes du marketing numérique', 'BUSINESS');

-- Insertion des rôles de base
INSERT INTO user_management.role (name, description, permissions) VALUES
                                                                      ('STUDENT', 'Étudiant cherchant des opportunités', '{"can_apply": true, "can_view_offers": true}'),
                                                                      ('COMPANY', 'Entreprise publiant des offres', '{"can_post_offers": true, "can_view_candidates": true}'),
                                                                      ('ADMIN', 'Administrateur système', '{"full_access": true}'),
                                                                      ('MODERATOR', 'Modérateur de contenu', '{"can_moderate": true, "can_validate": true}');

-- Insertion des compétences de base
INSERT INTO academic.skill (name, description, category) VALUES
-- Langages de programmation
('JavaScript', 'Langage de programmation web', 'Programming'),
('Python', 'Langage de programmation polyvalent', 'Programming'),
('Java', 'Langage de programmation orienté objet', 'Programming'),
('TypeScript', 'JavaScript avec typage statique', 'Programming'),
('PHP', 'Langage de programmation web côté serveur', 'Programming'),

-- Frameworks
('React', 'Bibliothèque JavaScript pour interfaces utilisateur', 'Frontend'),
('Vue.js', 'Framework JavaScript progressif', 'Frontend'),
('Angular', 'Framework TypeScript pour applications web', 'Frontend'),
('Node.js', 'Runtime JavaScript côté serveur', 'Backend'),
('Spring Boot', 'Framework Java pour applications', 'Backend'),

-- Bases de données
('PostgreSQL', 'Système de gestion de base de données', 'Database'),
('MySQL', 'Système de gestion de base de données', 'Database'),
('MongoDB', 'Base de données NoSQL', 'Database'),

-- Outils
('Git', 'Système de contrôle de version', 'Tools'),
('Docker', 'Plateforme de conteneurisation', 'DevOps'),
('AWS', 'Services cloud Amazon', 'Cloud'),

-- Design
('Figma', 'Outil de design d''interface', 'Design'),
('Adobe Photoshop', 'Logiciel de retouche photo', 'Design'),
('UI Design', 'Conception d''interfaces utilisateur', 'Design'),
('UX Design', 'Conception d''expérience utilisateur', 'Design');