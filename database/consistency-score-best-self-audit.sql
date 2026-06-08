\set ON_ERROR_STOP on
\i database/schema.sql

INSERT INTO consistency_batches (id, character_slug, batch_name, source_metadata, lora_path, lora_present, face_score, body_score, style_score, narrative_score, global_score, isi_score, approved, gate_status, rejection_reasons, metrics)
VALUES (
  '178800d9-85f1-4847-a90a-d5b1b43318be'::uuid,
  'elena-voss',
  'elena_daily_best_self_audit',
  'docs\daily-elena-images-20260607-194019.json',
  'models/loras/elena_voss_v1.safetensors',
  true,
  60.96,
  66.59,
  87.44,
  100.0,
  72.48,
  70.74,
  false,
  'rejected',
  '["face_consistency_below_90", "body_consistency_below_90", "global_consistency_below_90", "isi_below_90"]'::jsonb,
  '{"reference_faces": 5, "reference_bodies": 5, "reference_styles": 5, "target_images": 5, "identity_stability_goal": 100}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '178800d9-85f1-4847-a90a-d5b1b43318be'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/playa/elena_voss_playa_001_00008_.png',
  'playa',
  9.29,
  58.83,
  80.17,
  100.0,
  48.39,
  false,
  '{"face_detected": true, "face_similarity": 0.58252, "pose_landmarks_visible": 4, "pose_visibility": 0.822, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.18048, "style_distance": 0.221, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '178800d9-85f1-4847-a90a-d5b1b43318be'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/cafeteria/elena_voss_cafeteria_001_00007_.png',
  'cafeteria',
  68.15,
  70.29,
  88.71,
  100.0,
  76.65,
  false,
  '{"face_detected": true, "face_similarity": 0.78854, "pose_landmarks_visible": 4, "pose_visibility": 0.8221, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.09957, "style_distance": 0.1198, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '178800d9-85f1-4847-a90a-d5b1b43318be'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/gym/elena_voss_gym_001_00007_.png',
  'fitness',
  85.79,
  64.61,
  87.87,
  100.0,
  81.88,
  false,
  '{"face_detected": true, "face_similarity": 0.85028, "pose_landmarks_visible": 4, "pose_visibility": 0.9892, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.13786, "style_distance": 0.12928, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '178800d9-85f1-4847-a90a-d5b1b43318be'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/viajes/elena_voss_viajes_001_00007_.png',
  'viajes',
  69.04,
  81.64,
  91.86,
  100.0,
  80.89,
  false,
  '{"face_detected": true, "face_similarity": 0.79165, "pose_landmarks_visible": 5, "pose_visibility": 0.8725, "body_completeness": 0.625, "legs_measured": false, "body_distance": 0.04747, "style_distance": 0.08485, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '178800d9-85f1-4847-a90a-d5b1b43318be'::uuid,
  'elena-voss',
  'images/generated/dataset/elena_voss/lifestyle/elena_voss_lifestyle_001_00007_.png',
  'vida_diaria',
  72.53,
  57.58,
  88.58,
  100.0,
  74.57,
  false,
  '{"face_detected": true, "face_similarity": 0.80385, "pose_landmarks_visible": 4, "pose_visibility": 0.9975, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.19018, "style_distance": 0.12129, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);
