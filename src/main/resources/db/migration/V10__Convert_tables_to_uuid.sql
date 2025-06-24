-- =========================================
-- V10__Convert_tables_to_uuid.sql
-- Migration pour convertir les tables student_file, student_filter_param,
-- student_link, student_skill, candidature et offer vers UUID
-- =========================================

-- Activer l'extension UUID si pas déjà fait
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================
-- ÉTAPE 1: Identifier et supprimer TOUTES les contraintes FK qui dépendent des tables à modifier
-- =========================================

-- Contraintes qui référencent student_file.id
ALTER TABLE recruitment.candidature
DROP CONSTRAINT IF EXISTS candidature_resume_file_id_fkey;

-- Contraintes qui référencent offer.id
ALTER TABLE recruitment.candidature
DROP CONSTRAINT IF EXISTS candidature_offer_id_fkey;

ALTER TABLE recruitment.offer_required_skill
DROP CONSTRAINT IF EXISTS offer_required_skill_offer_id_fkey;

-- Contraintes qui référencent student_skill.id (si elles existent)
ALTER TABLE recruitment.offer_required_skill
DROP CONSTRAINT IF EXISTS offer_required_skill_skill_id_fkey;

-- =========================================
-- ÉTAPE 2: Convertir academic.student_skill
-- =========================================

-- Ajouter colonne temporaire pour stocker les nouveaux UUID
ALTER TABLE academic.student_skill
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mettre à jour les références dans offer_required_skill (si skill_id existe)
ALTER TABLE recruitment.offer_required_skill
    ADD COLUMN IF NOT EXISTS new_skill_id UUID;

-- Mettre à jour les références avec les nouveaux UUID
UPDATE recruitment.offer_required_skill
SET new_skill_id = ss.new_id
    FROM academic.student_skill ss
WHERE recruitment.offer_required_skill.skill_id = ss.id;

-- Supprimer l'ancienne clé primaire et colonne id de student_skill
ALTER TABLE academic.student_skill
DROP CONSTRAINT IF EXISTS student_skill_pkey,
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE academic.student_skill
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE academic.student_skill
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 3: Convertir academic.student_file
-- =========================================

-- Ajouter colonne temporaire pour stocker les nouveaux UUID
ALTER TABLE academic.student_file
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mettre à jour les références dans candidature (si resume_file_id existe)
ALTER TABLE recruitment.candidature
    ADD COLUMN IF NOT EXISTS new_resume_file_id UUID;

-- Mettre à jour les références avec les nouveaux UUID
UPDATE recruitment.candidature
SET new_resume_file_id = sf.new_id
    FROM academic.student_file sf
WHERE recruitment.candidature.resume_file_id = sf.id;

-- Supprimer l'ancienne clé primaire et colonne id de student_file
ALTER TABLE academic.student_file
DROP CONSTRAINT IF EXISTS student_file_pkey,
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE academic.student_file
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE academic.student_file
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 4: Convertir academic.student_link
-- =========================================

-- Ajouter la nouvelle colonne UUID
ALTER TABLE academic.student_link
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Supprimer l'ancienne clé primaire et colonne id
ALTER TABLE academic.student_link
DROP CONSTRAINT IF EXISTS student_link_pkey,
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE academic.student_link
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE academic.student_link
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 5: Convertir academic.student_filter_param
-- =========================================

-- Ajouter la nouvelle colonne UUID
ALTER TABLE academic.student_filter_param
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Supprimer l'ancienne clé primaire et colonne id
ALTER TABLE academic.student_filter_param
DROP CONSTRAINT IF EXISTS student_filter_param_pkey,
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE academic.student_filter_param
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE academic.student_filter_param
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 6: Convertir recruitment.offer
-- =========================================

-- Ajouter colonne temporaire pour stocker les nouveaux UUID
ALTER TABLE recruitment.offer
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mettre à jour les références dans candidature (si offer_id existe)
ALTER TABLE recruitment.candidature
    ADD COLUMN IF NOT EXISTS new_offer_id UUID;

-- Mettre à jour les références dans offer_required_skill
ALTER TABLE recruitment.offer_required_skill
    ADD COLUMN IF NOT EXISTS new_offer_id UUID;

-- Mettre à jour les références avec les nouveaux UUID
UPDATE recruitment.candidature
SET new_offer_id = o.new_id
    FROM recruitment.offer o
WHERE recruitment.candidature.offer_id = o.id;

UPDATE recruitment.offer_required_skill
SET new_offer_id = o.new_id
    FROM recruitment.offer o
WHERE recruitment.offer_required_skill.offer_id = o.id;

-- Supprimer l'ancienne clé primaire et colonne id de offer
ALTER TABLE recruitment.offer
DROP CONSTRAINT IF EXISTS offer_pkey,
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE recruitment.offer
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE recruitment.offer
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 7: Convertir recruitment.candidature
-- =========================================

-- Ajouter la nouvelle colonne UUID
ALTER TABLE recruitment.candidature
    ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Supprimer l'ancienne clé primaire et colonne id
ALTER TABLE recruitment.candidature
DROP CONSTRAINT IF EXISTS candidature_pkey,
DROP COLUMN id,
ALTER COLUMN new_id SET NOT NULL;

-- Renommer la nouvelle colonne
ALTER TABLE recruitment.candidature
    RENAME COLUMN new_id TO id;

-- Recréer la clé primaire
ALTER TABLE recruitment.candidature
    ADD PRIMARY KEY (id);

-- =========================================
-- ÉTAPE 8: Finaliser les références dans les tables dépendantes
-- =========================================

-- Finaliser offer_required_skill.skill_id si elle existe
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'recruitment'
        AND table_name = 'offer_required_skill'
        AND column_name = 'skill_id'
    ) THEN
        -- Supprimer l'ancienne colonne et renommer la nouvelle
ALTER TABLE recruitment.offer_required_skill
DROP COLUMN skill_id;

ALTER TABLE recruitment.offer_required_skill
    RENAME COLUMN new_skill_id TO skill_id;
END IF;
END $$;

-- Finaliser offer_required_skill.offer_id
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'recruitment'
        AND table_name = 'offer_required_skill'
        AND column_name = 'offer_id'
    ) THEN
        -- Supprimer l'ancienne colonne et renommer la nouvelle
ALTER TABLE recruitment.offer_required_skill
DROP COLUMN offer_id;

ALTER TABLE recruitment.offer_required_skill
    RENAME COLUMN new_offer_id TO offer_id;
END IF;
END $$;

-- Finaliser candidature.resume_file_id si elle existe
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'recruitment'
        AND table_name = 'candidature'
        AND column_name = 'resume_file_id'
    ) THEN
        -- Supprimer l'ancienne colonne et renommer la nouvelle
ALTER TABLE recruitment.candidature
DROP COLUMN resume_file_id;

ALTER TABLE recruitment.candidature
    RENAME COLUMN new_resume_file_id TO resume_file_id;
END IF;
END $$;

-- Finaliser candidature.offer_id si elle existe
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'recruitment'
        AND table_name = 'candidature'
        AND column_name = 'offer_id'
    ) THEN
        -- Supprimer l'ancienne colonne et renommer la nouvelle
ALTER TABLE recruitment.candidature
DROP COLUMN offer_id;

ALTER TABLE recruitment.candidature
    RENAME COLUMN new_offer_id TO offer_id;
END IF;
END $$;

-- =========================================
-- ÉTAPE 9: Recréer les contraintes de clés étrangères
-- =========================================

-- Recréer les contraintes pour offer_required_skill
DO $$
BEGIN
    -- Pour skill_id
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'recruitment'
        AND table_name = 'offer_required_skill'
        AND column_name = 'skill_id'
    ) THEN
ALTER TABLE recruitment.offer_required_skill
    ADD CONSTRAINT offer_required_skill_skill_id_fkey
        FOREIGN KEY (skill_id) REFERENCES academic.student_skill(id) ON DELETE CASCADE;
END IF;

    -- Pour offer_id
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'recruitment'
        AND table_name = 'offer_required_skill'
        AND column_name = 'offer_id'
    ) THEN
ALTER TABLE recruitment.offer_required_skill
    ADD CONSTRAINT offer_required_skill_offer_id_fkey
        FOREIGN KEY (offer_id) REFERENCES recruitment.offer(id) ON DELETE CASCADE;
END IF;
END $$;

-- Recréer la contrainte pour candidature.resume_file_id si elle existe
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'recruitment'
        AND table_name = 'candidature'
        AND column_name = 'resume_file_id'
    ) THEN
ALTER TABLE recruitment.candidature
    ADD CONSTRAINT candidature_resume_file_id_fkey
        FOREIGN KEY (resume_file_id) REFERENCES academic.student_file(id) ON DELETE SET NULL;
END IF;
END $$;

-- Recréer la contrainte pour candidature.offer_id si elle existe
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'recruitment'
        AND table_name = 'candidature'
        AND column_name = 'offer_id'
    ) THEN
ALTER TABLE recruitment.candidature
    ADD CONSTRAINT candidature_offer_id_fkey
        FOREIGN KEY (offer_id) REFERENCES recruitment.offer(id) ON DELETE CASCADE;
END IF;
END $$;

-- =========================================
-- ÉTAPE 10: Créer des index pour optimiser les performances
-- =========================================

-- Index sur les colonnes de recherche fréquentes
CREATE INDEX IF NOT EXISTS idx_student_skill_id ON academic.student_skill(id);
CREATE INDEX IF NOT EXISTS idx_student_file_id ON academic.student_file(id);
CREATE INDEX IF NOT EXISTS idx_student_link_id ON academic.student_link(id);
CREATE INDEX IF NOT EXISTS idx_student_filter_param_id ON academic.student_filter_param(id);
CREATE INDEX IF NOT EXISTS idx_candidature_id ON recruitment.candidature(id);
CREATE INDEX IF NOT EXISTS idx_offer_id ON recruitment.offer(id);

-- Index sur les colonnes de clés étrangères
CREATE INDEX IF NOT EXISTS idx_candidature_resume_file_id ON recruitment.candidature(resume_file_id);
CREATE INDEX IF NOT EXISTS idx_candidature_offer_id ON recruitment.candidature(offer_id);
CREATE INDEX IF NOT EXISTS idx_offer_required_skill_offer_id ON recruitment.offer_required_skill(offer_id);
CREATE INDEX IF NOT EXISTS idx_offer_required_skill_skill_id ON recruitment.offer_required_skill(skill_id);

-- =========================================
-- ÉTAPE 11: Nettoyage des colonnes temporaires
-- =========================================

-- Supprimer les colonnes temporaires qui pourraient rester
ALTER TABLE recruitment.candidature
DROP COLUMN IF EXISTS new_resume_file_id,
DROP COLUMN IF EXISTS new_offer_id;

ALTER TABLE recruitment.offer_required_skill
DROP COLUMN IF EXISTS new_offer_id,
DROP COLUMN IF EXISTS new_skill_id;

-- =========================================
-- ÉTAPE 12: Vérifications finales (commentées)
-- =========================================

/*
-- Vérifier que toutes les tables ont bien des UUID comme clés primaires
SELECT
    table_schema,
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE column_name = 'id'
AND table_schema IN ('academic', 'recruitment')
AND table_name IN ('student_skill', 'student_file', 'student_link', 'student_filter_param', 'candidature', 'offer');

-- Vérifier les contraintes de clés primaires
SELECT
    tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.constraint_type = 'PRIMARY KEY'
AND tc.table_schema IN ('academic', 'recruitment')
AND tc.table_name IN ('student_skill', 'student_file', 'student_link', 'student_filter_param', 'candidature', 'offer');

-- Vérifier les contraintes de clés étrangères
SELECT
    tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_schema = 'recruitment'
AND (tc.table_name = 'candidature' OR tc.table_name = 'offer_required_skill')
AND (kcu.column_name LIKE '%_id' OR kcu.column_name LIKE '%_email');
*/