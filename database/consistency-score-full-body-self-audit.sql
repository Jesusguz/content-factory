\set ON_ERROR_STOP on
\i database/schema.sql

INSERT INTO consistency_batches (id, character_slug, batch_name, source_metadata, lora_path, lora_present, face_score, body_score, style_score, narrative_score, global_score, isi_score, approved, gate_status, rejection_reasons, metrics)
VALUES (
  '531c98e4-ee17-4a76-a42d-ad25c5e62860'::uuid,
  'elena-voss',
  'elena_daily_full_body_self_audit',
  'docs\daily-elena-images-20260607-193004.json',
  'models/loras/elena_voss_v1.safetensors',
  true,
  82.44,
  45.54,
  87.58,
  100.0,
  74.78,
  73.04,
  false,
  'rejected',
  '["face_consistency_below_90", "body_consistency_below_90", "global_consistency_below_90", "isi_below_90"]'::jsonb,
  '{"reference_faces": 5, "reference_bodies": 5, "reference_styles": 5, "target_images": 5, "identity_stability_goal": 100}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '531c98e4-ee17-4a76-a42d-ad25c5e62860'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/playa/elena_voss_playa_001_00005_.png',
  'playa',
  86.04,
  39.55,
  80.56,
  100.0,
  73.37,
  false,
  '{"face_detected": true, "face_similarity": 0.85114, "pose_landmarks_visible": 4, "pose_visibility": 0.8608, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.14626, "style_distance": 0.21615, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '531c98e4-ee17-4a76-a42d-ad25c5e62860'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/cafeteria/elena_voss_cafeteria_001_00004_.png',
  'cafeteria',
  90.19,
  53.55,
  88.13,
  100.0,
  80.36,
  false,
  '{"face_detected": true, "face_similarity": 0.86567, "pose_landmarks_visible": 4, "pose_visibility": 0.7601, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.08038, "style_distance": 0.12633, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '531c98e4-ee17-4a76-a42d-ad25c5e62860'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/gym/elena_voss_gym_001_00004_.png',
  'fitness',
  96.35,
  38.1,
  87.72,
  100.0,
  78.13,
  false,
  '{"face_detected": true, "face_similarity": 0.88723, "pose_landmarks_visible": 4, "pose_visibility": 0.9898, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.15437, "style_distance": 0.131, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '531c98e4-ee17-4a76-a42d-ad25c5e62860'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/viajes/elena_voss_viajes_001_00004_.png',
  'viajes',
  71.01,
  71.47,
  92.62,
  100.0,
  78.74,
  false,
  '{"face_detected": true, "face_similarity": 0.79852, "pose_landmarks_visible": 4, "pose_visibility": 0.9917, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.0176, "style_distance": 0.07667, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '531c98e4-ee17-4a76-a42d-ad25c5e62860'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/lifestyle/elena_voss_lifestyle_001_00004_.png',
  'vida_diaria',
  68.62,
  25.03,
  88.87,
  100.0,
  63.29,
  false,
  '{"face_detected": true, "face_similarity": 0.79016, "pose_landmarks_visible": 4, "pose_visibility": 0.9964, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.24571, "style_distance": 0.118, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);
