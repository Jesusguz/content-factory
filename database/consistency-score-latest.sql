\set ON_ERROR_STOP on
\i database/schema.sql

INSERT INTO consistency_batches (id, character_slug, batch_name, source_metadata, lora_path, lora_present, face_score, body_score, style_score, narrative_score, global_score, isi_score, approved, gate_status, rejection_reasons, metrics)
VALUES (
  '32584d51-1ac0-4abb-b7bb-8b27845ec273'::uuid,
  'elena-voss',
  'daily_elena_20260607-194019',
  'docs\daily-elena-images-20260607-194019.json',
  'models/loras/elena_voss_v1.safetensors',
  true,
  10.04,
  61.65,
  84.42,
  100.0,
  50.17,
  46.1,
  false,
  'rejected',
  '["face_consistency_below_90", "body_consistency_below_90", "style_consistency_below_85", "global_consistency_below_90", "isi_below_90"]'::jsonb,
  '{"reference_faces": 30, "reference_bodies": 10, "reference_styles": 30, "target_images": 5, "identity_stability_goal": 100}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '32584d51-1ac0-4abb-b7bb-8b27845ec273'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/playa/elena_voss_playa_001_00008_.png',
  'playa',
  0.0,
  50.01,
  74.0,
  100.0,
  41.1,
  false,
  '{"face_detected": true, "face_similarity": 0.54189, "pose_landmarks_visible": 4, "pose_visibility": 0.822, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.25431, "style_distance": 0.30104, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '32584d51-1ac0-4abb-b7bb-8b27845ec273'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/cafeteria/elena_voss_cafeteria_001_00007_.png',
  'cafeteria',
  0.0,
  65.77,
  92.19,
  100.0,
  48.56,
  false,
  '{"face_detected": true, "face_similarity": 0.52078, "pose_landmarks_visible": 4, "pose_visibility": 0.8221, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.12979, "style_distance": 0.08127, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '32584d51-1ac0-4abb-b7bb-8b27845ec273'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/gym/elena_voss_gym_001_00007_.png',
  'fitness',
  45.6,
  53.1,
  89.17,
  100.0,
  62.55,
  false,
  '{"face_detected": true, "face_similarity": 0.70961, "pose_landmarks_visible": 4, "pose_visibility": 0.9892, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.22703, "style_distance": 0.11458, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '32584d51-1ac0-4abb-b7bb-8b27845ec273'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/viajes/elena_voss_viajes_001_00007_.png',
  'viajes',
  0.0,
  72.05,
  86.0,
  100.0,
  49.52,
  false,
  '{"face_detected": true, "face_similarity": 0.48326, "pose_landmarks_visible": 5, "pose_visibility": 0.8725, "body_completeness": 0.625, "legs_measured": false, "body_distance": 0.10427, "style_distance": 0.15082, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '32584d51-1ac0-4abb-b7bb-8b27845ec273'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/lifestyle/elena_voss_lifestyle_001_00007_.png',
  'vida_diaria',
  4.61,
  67.3,
  80.72,
  100.0,
  49.14,
  false,
  '{"face_detected": true, "face_similarity": 0.56614, "pose_landmarks_visible": 4, "pose_visibility": 0.9975, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.11932, "style_distance": 0.21423, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);
