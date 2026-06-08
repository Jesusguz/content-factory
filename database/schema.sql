CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS characters (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug text NOT NULL UNIQUE,
    display_name text NOT NULL,
    profile jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS content_generation_runs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    character_slug text NOT NULL REFERENCES characters(slug),
    source_model text NOT NULL,
    prompt_set text NOT NULL,
    requested_counts jsonb NOT NULL DEFAULT '{}'::jsonb,
    actual_counts jsonb NOT NULL DEFAULT '{}'::jsonb,
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS content_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    run_id uuid REFERENCES content_generation_runs(id) ON DELETE SET NULL,
    character_slug text NOT NULL REFERENCES characters(slug),
    content_type text NOT NULL CHECK (
        content_type IN ('tiktok_idea', 'caption', 'hook', 'story')
    ),
    category text NOT NULL,
    platform text NOT NULL,
    title text,
    body text NOT NULL,
    source_model text NOT NULL,
    prompt text,
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    status text NOT NULL DEFAULT 'draft',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS publication_queue (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    content_item_id uuid REFERENCES content_items(id) ON DELETE SET NULL,
    character_slug text NOT NULL REFERENCES characters(slug),
    platform text NOT NULL,
    media_path text,
    caption text,
    scheduled_for timestamptz NOT NULL,
    status text NOT NULL DEFAULT 'scheduled',
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_content_items_character_type
    ON content_items(character_slug, content_type);

CREATE INDEX IF NOT EXISTS idx_content_items_category
    ON content_items(category);

CREATE INDEX IF NOT EXISTS idx_content_items_created_at
    ON content_items(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_publication_queue_scheduled_for
    ON publication_queue(scheduled_for);

CREATE INDEX IF NOT EXISTS idx_publication_queue_status
    ON publication_queue(status);

CREATE TABLE IF NOT EXISTS consistency_batches (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    character_slug text NOT NULL REFERENCES characters(slug),
    batch_name text NOT NULL,
    source_metadata text NOT NULL,
    lora_path text NOT NULL,
    lora_present boolean NOT NULL DEFAULT false,
    face_score numeric(5,2) NOT NULL DEFAULT 0,
    body_score numeric(5,2) NOT NULL DEFAULT 0,
    style_score numeric(5,2) NOT NULL DEFAULT 0,
    narrative_score numeric(5,2) NOT NULL DEFAULT 0,
    global_score numeric(5,2) NOT NULL DEFAULT 0,
    isi_score numeric(5,2) NOT NULL DEFAULT 0,
    approved boolean NOT NULL DEFAULT false,
    gate_status text NOT NULL DEFAULT 'blocked' CHECK (gate_status IN ('approved', 'rejected', 'blocked')),
    rejection_reasons jsonb NOT NULL DEFAULT '[]'::jsonb,
    metrics jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS consistency_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id uuid NOT NULL REFERENCES consistency_batches(id) ON DELETE CASCADE,
    character_slug text NOT NULL REFERENCES characters(slug),
    image_path text NOT NULL,
    category text,
    face_score numeric(5,2) NOT NULL DEFAULT 0,
    body_score numeric(5,2) NOT NULL DEFAULT 0,
    style_score numeric(5,2) NOT NULL DEFAULT 0,
    narrative_score numeric(5,2) NOT NULL DEFAULT 0,
    global_score numeric(5,2) NOT NULL DEFAULT 0,
    approved boolean NOT NULL DEFAULT false,
    metrics jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_consistency_batches_character_created_at
    ON consistency_batches(character_slug, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_consistency_batches_gate_status
    ON consistency_batches(gate_status);

CREATE INDEX IF NOT EXISTS idx_consistency_items_batch
    ON consistency_items(batch_id);

INSERT INTO characters (slug, display_name, profile)
VALUES (
    'valentina-sol',
    'Valentina Sol',
    '{
      "niche": "lifestyle latino premium",
      "tone": "cercano, luminoso, inteligente, calmado",
      "pillars": ["playa", "cafeteria", "gym", "viajes", "lifestyle"],
      "visual_identity": {
        "skin": "warm olive",
        "hair": "dark brown wavy",
        "eyes": "soft hazel",
        "style": "clean coastal lifestyle"
      }
    }'::jsonb
)
ON CONFLICT (slug) DO UPDATE
SET
    display_name = EXCLUDED.display_name,
    profile = EXCLUDED.profile,
    updated_at = now();

INSERT INTO characters (slug, display_name, profile)
VALUES (
    'elena-voss',
    'Elena Voss',
    '{
      "niche": "remote lifestyle, cafes, travel, light fitness, photography",
      "tone": "cercano, honesto, sensorial, cotidiano, con confianza tranquila",
      "pillars": ["playa", "cafeteria", "fitness", "viajes", "vida_diaria"],
      "quality_gate": {
        "face_min": 90,
        "body_min": 90,
        "style_min": 85,
        "narrative_min": 85,
        "global_min": 90,
        "isi_min": 90
      },
      "visual_identity": {
        "skin": "warm light olive",
        "hair": "dark chestnut brown wavy",
        "eyes": "hazel green-brown",
        "build": "slim athletic natural",
        "style": "realistic editorial lifestyle"
      }
    }'::jsonb
)
ON CONFLICT (slug) DO UPDATE
SET
    display_name = EXCLUDED.display_name,
    profile = EXCLUDED.profile,
    updated_at = now();
