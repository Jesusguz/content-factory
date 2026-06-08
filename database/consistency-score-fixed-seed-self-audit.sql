\set ON_ERROR_STOP on
\i database/schema.sql

INSERT INTO consistency_batches (id, character_slug, batch_name, source_metadata, lora_path, lora_present, face_score, body_score, style_score, narrative_score, global_score, isi_score, approved, gate_status, rejection_reasons, metrics)
VALUES (
  'db40caa3-5139-45ca-adb6-bea92af36a12'::uuid,
  'elena-voss',
  'elena_daily_fixed_seed_self_audit',
  'docs\daily-elena-images-20260607-192522.json',
  'models/loras/elena_voss_v1.safetensors',
  true,
  83.2,
  39.94,
  45.82,
  100.0,
  67.13,
  71.42,
  false,
  'rejected',
  '["face_consistency_below_90", "body_consistency_below_90", "style_consistency_below_85", "global_consistency_below_90", "isi_below_90"]'::jsonb,
  '{"reference_faces": 5, "reference_bodies": 5, "reference_styles": 5, "target_images": 5, "identity_stability_goal": 100}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'db40caa3-5139-45ca-adb6-bea92af36a12'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/playa/elena_voss_playa_001_00004_.png',
  'playa',
  78.22,
  41.57,
  22.88,
  100.0,
  62.19,
  false,
  '{"face_detected": true, "face_similarity": 0.82376, "pose_landmarks_visible": 4, "pose_visibility": 0.8608, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.13543, "style_distance": 0.24579, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'db40caa3-5139-45ca-adb6-bea92af36a12'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/cafeteria/elena_voss_cafeteria_001_00003_.png',
  'cafeteria',
  73.95,
  28.72,
  44.36,
  100.0,
  59.85,
  false,
  '{"face_detected": true, "face_similarity": 0.80883, "pose_landmarks_visible": 4, "pose_visibility": 0.966, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.21579, "style_distance": 0.13548, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'db40caa3-5139-45ca-adb6-bea92af36a12'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/gym/elena_voss_gym_001_00003_.png',
  'fitness',
  86.37,
  40.98,
  49.76,
  100.0,
  69.31,
  false,
  '{"face_detected": true, "face_similarity": 0.85231, "pose_landmarks_visible": 4, "pose_visibility": 0.9918, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.1385, "style_distance": 0.11631, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'db40caa3-5139-45ca-adb6-bea92af36a12'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/viajes/elena_voss_viajes_001_00003_.png',
  'viajes',
  95.34,
  56.25,
  63.31,
  100.0,
  79.51,
  false,
  '{"face_detected": true, "face_similarity": 0.88368, "pose_landmarks_visible": 4, "pose_visibility": 0.9843, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.06966, "style_distance": 0.07619, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'db40caa3-5139-45ca-adb6-bea92af36a12'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/lifestyle/elena_voss_lifestyle_001_00003_.png',
  'vida_diaria',
  82.12,
  32.18,
  48.79,
  100.0,
  64.82,
  false,
  '{"face_detected": true, "face_similarity": 0.83742, "pose_landmarks_visible": 4, "pose_visibility": 0.9918, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.19104, "style_distance": 0.1196, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);
