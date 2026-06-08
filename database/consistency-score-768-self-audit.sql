\set ON_ERROR_STOP on
\i database/schema.sql

INSERT INTO consistency_batches (id, character_slug, batch_name, source_metadata, lora_path, lora_present, face_score, body_score, style_score, narrative_score, global_score, isi_score, approved, gate_status, rejection_reasons, metrics)
VALUES (
  '71f660db-f882-4c63-aac2-643ebcb0cb0c'::uuid,
  'elena-voss',
  'elena_daily_768_self_audit',
  'docs\daily-elena-images-20260607-193319.json',
  'models/loras/elena_voss_v1.safetensors',
  true,
  54.13,
  9.91,
  87.2,
  100.0,
  52.7,
  47.83,
  false,
  'rejected',
  '["face_consistency_below_90", "body_consistency_below_90", "global_consistency_below_90", "isi_below_90"]'::jsonb,
  '{"reference_faces": 5, "reference_bodies": 4, "reference_styles": 5, "target_images": 5, "identity_stability_goal": 100}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '71f660db-f882-4c63-aac2-643ebcb0cb0c'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/playa/elena_voss_playa_001_00006_.png',
  'playa',
  66.89,
  0.0,
  84.8,
  100.0,
  54.48,
  false,
  '{"face_detected": true, "face_similarity": 0.78411, "pose_landmarks_visible": 2, "pose_visibility": 0.9934284389019012, "body_distance": null, "style_distance": 0.16482, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '71f660db-f882-4c63-aac2-643ebcb0cb0c'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/cafeteria/elena_voss_cafeteria_001_00005_.png',
  'cafeteria',
  77.33,
  15.79,
  87.25,
  100.0,
  63.76,
  false,
  '{"face_detected": true, "face_similarity": 0.82067, "pose_landmarks_visible": 6, "pose_visibility": 0.9287, "body_completeness": 0.75, "legs_measured": false, "body_distance": 0.37536, "style_distance": 0.13636, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '71f660db-f882-4c63-aac2-643ebcb0cb0c'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/gym/elena_voss_gym_001_00005_.png',
  'fitness',
  29.51,
  14.53,
  86.51,
  100.0,
  44.14,
  false,
  '{"face_detected": true, "face_similarity": 0.65328, "pose_landmarks_visible": 5, "pose_visibility": 0.9583, "body_completeness": 0.625, "legs_measured": false, "body_distance": 0.37923, "style_distance": 0.14494, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '71f660db-f882-4c63-aac2-643ebcb0cb0c'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/viajes/elena_voss_viajes_001_00005_.png',
  'viajes',
  56.2,
  17.54,
  91.09,
  100.0,
  56.41,
  false,
  '{"face_detected": true, "face_similarity": 0.7467, "pose_landmarks_visible": 6, "pose_visibility": 0.8503, "body_completeness": 0.75, "legs_measured": false, "body_distance": 0.35245, "style_distance": 0.0933, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '71f660db-f882-4c63-aac2-643ebcb0cb0c'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/lifestyle/elena_voss_lifestyle_001_00005_.png',
  'vida_diaria',
  40.74,
  1.67,
  86.34,
  100.0,
  44.75,
  false,
  '{"face_detected": true, "face_similarity": 0.69258, "pose_landmarks_visible": 8, "pose_visibility": 0.9101, "body_completeness": 1.0, "legs_measured": true, "body_distance": 0.88919, "style_distance": 0.1469, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);
