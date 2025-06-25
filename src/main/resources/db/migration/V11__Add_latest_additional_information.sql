-- =========================================
-- V11__Add_latest_additional_information.sql
-- migration pour ajouter les informations de company
-- =========================================


-- Migration pour modifier la table company_additional_information
-- Fichier: xxxx_xx_xx_xxxxxx_modify_company_additional_information_table.sql

-- Supprimer les colonnes siret et contact_person
ALTER TABLE user_management.company_additional_information
DROP COLUMN IF EXISTS siret,
DROP COLUMN IF EXISTS contact_person;

-- Ajouter les nouvelles colonnes
ALTER TABLE user_management.company_additional_information
    ADD COLUMN company_corporate VARCHAR(255),
ADD COLUMN company_rccm VARCHAR(100),
ADD COLUMN company_niu VARCHAR(50),
ADD COLUMN company_commercial_register VARCHAR(100),
ADD COLUMN company_legal_status VARCHAR(100),
ADD COLUMN company_tax_conformity_certificate VARCHAR(255),
ADD COLUMN company_static_declaration_number VARCHAR(100),
ADD COLUMN company_internship_duration INTEGER,
ADD COLUMN company_has_intern_opportunity BOOLEAN DEFAULT FALSE;


-- Migration pour changer l'ID de la table offer_required_skill de INTEGER vers UUID
-- Fichier: xxxx_xx_xx_xxxxxx_change_offer_required_skill_id_to_uuid.sql

-- Étape 1: Créer une nouvelle colonne UUID temporaire
ALTER TABLE recruitment.offer_required_skill ADD COLUMN new_id UUID DEFAULT uuid_generate_v4();

-- Étape 2: Mettre à jour toutes les lignes avec des UUIDs uniques
UPDATE recruitment.offer_required_skill SET new_id = uuid_generate_v4() WHERE new_id IS NULL;

-- Étape 3: Supprimer la contrainte de clé primaire existante
ALTER TABLE recruitment.offer_required_skill DROP CONSTRAINT IF EXISTS offer_required_skill_pkey;

-- Étape 4: Supprimer l'ancienne colonne id
ALTER TABLE recruitment.offer_required_skill DROP COLUMN id;

-- Étape 5: Renommer la nouvelle colonne
ALTER TABLE recruitment.offer_required_skill RENAME COLUMN new_id TO id;

-- Étape 6: Ajouter la contrainte NOT NULL et définir comme clé primaire
ALTER TABLE recruitment.offer_required_skill ALTER COLUMN id SET NOT NULL;
ALTER TABLE recruitment.offer_required_skill ADD PRIMARY KEY (id);

-- Étape 7: Créer un index sur la nouvelle colonne UUID (optionnel mais recommandé)
CREATE INDEX IF NOT EXISTS idx_offer_required_skill_id ON recruitment.offer_required_skill(id);