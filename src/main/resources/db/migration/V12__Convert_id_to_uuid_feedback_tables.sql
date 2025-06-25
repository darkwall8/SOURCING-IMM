-- =========================================
-- V12__Add_latest_additional_information.sql
-- migration pour modifier le type de l'id de
-- la table feedback d'integer vers uuid
-- =========================================

-- Activer l'extension UUID si elle n'est pas déjà active
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Création d'une nouvelle colonne UUID temporaire
ALTER TABLE system.feedback ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Mise à jour des lignes avec des UUIDs uniques
UPDATE system.feedback SET new_id = uuid_generate_v4() WHERE new_id IS NULL;

-- Supprimer la contrainte de clé primaire existante
ALTER TABLE system.feedback DROP CONSTRAINT IF EXISTS feedback_pkey;

-- Supprimer l'ancienne colonne id
ALTER TABLE system.feedback DROP COLUMN id;

-- Renommer la nouvelle colonne en 'id'
ALTER TABLE system.feedback RENAME COLUMN new_id TO id;

-- Ajouter la contrainte NOT NULL et définir comme clé primaire
ALTER TABLE system.feedback ALTER COLUMN id SET NOT NULL;
ALTER TABLE system.feedback ADD PRIMARY KEY (id);

-- Créer un index sur la nouvelle colonne UUID (optionnel car PRIMARY KEY crée déjà un index)
-- CREATE INDEX IF NOT EXISTS idx_feedback_id ON system.feedback(id);