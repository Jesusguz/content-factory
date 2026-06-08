\set ON_ERROR_STOP on
\i database/schema.sql

INSERT INTO consistency_batches (id, character_slug, batch_name, source_metadata, lora_path, lora_present, face_score, body_score, style_score, narrative_score, global_score, isi_score, approved, gate_status, rejection_reasons, metrics)
VALUES (
  'f2ae1dc4-73b2-4ab2-8172-57874a6d91d6'::uuid,
  'elena-voss',
  'elena_daily_final_self_audit',
  'docs\daily-elena-images-20260607-193745.json',
  'models/loras/elena_voss_v1.safetensors',
  true,
  41.93,
  31.59,
  85.62,
  100.0,
  54.09,
  49.92,
  false,
  'rejected',
  '["face_consistency_below_90", "body_consistency_below_90", "global_consistency_below_90", "isi_below_90"]'::jsonb,
  '{"reference_faces": 5, "reference_bodies": 5, "reference_styles": 5, "target_images": 5, "identity_stability_goal": 100}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'f2ae1dc4-73b2-4ab2-8172-57874a6d91d6'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/playa/elena_voss_playa_001_00007_.png',
  'playa',
  25.32,
  42.0,
  79.12,
  100.0,
  49.6,
  false,
  '{"face_detected": true, "face_similarity": 0.63863, "pose_landmarks_visible": 8, "pose_visibility": 0.9454, "body_completeness": 1.0, "legs_measured": true, "body_distance": 0.39427, "style_distance": 0.23417, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'f2ae1dc4-73b2-4ab2-8172-57874a6d91d6'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/cafeteria/elena_voss_cafeteria_001_00006_.png',
  'cafeteria',
  48.9,
  19.71,
  83.96,
  100.0,
  53.07,
  false,
  '{"face_detected": true, "face_similarity": 0.72116, "pose_landmarks_visible": 4, "pose_visibility": 0.9782, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.67756, "style_distance": 0.17479, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'f2ae1dc4-73b2-4ab2-8172-57874a6d91d6'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/gym/elena_voss_gym_001_00006_.png',
  'fitness',
  71.65,
  22.84,
  87.01,
  100.0,
  63.56,
  false,
  '{"face_detected": true, "face_similarity": 0.80079, "pose_landmarks_visible": 4, "pose_visibility": 0.9901, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.61046, "style_distance": 0.13919, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'f2ae1dc4-73b2-4ab2-8172-57874a6d91d6'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/viajes/elena_voss_viajes_001_00006_.png',
  'viajes',
  21.37,
  39.25,
  89.91,
  100.0,
  48.81,
  false,
  '{"face_detected": true, "face_similarity": 0.62479, "pose_landmarks_visible": 8, "pose_visibility": 0.8983, "body_completeness": 1.0, "legs_measured": true, "body_distance": 0.42512, "style_distance": 0.10634, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  'f2ae1dc4-73b2-4ab2-8172-57874a6d91d6'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/lifestyle/elena_voss_lifestyle_001_00006_.png',
  'vida_diaria',
  42.39,
  34.14,
  88.11,
  100.0,
  55.41,
  false,
  '{"face_detected": true, "face_similarity": 0.69837, "pose_landmarks_visible": 8, "pose_visibility": 0.966, "body_completeness": 1.0, "legs_measured": true, "body_distance": 0.48848, "style_distance": 0.12661, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);
