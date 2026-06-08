\set ON_ERROR_STOP on
\i database/schema.sql

INSERT INTO consistency_batches (id, character_slug, batch_name, source_metadata, lora_path, lora_present, face_score, body_score, style_score, narrative_score, global_score, isi_score, approved, gate_status, rejection_reasons, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'elena_lora_dataset_refined_audit',
  'dataset_lora\metadata.json',
  'models/loras/elena_voss_v1.safetensors',
  true,
  39.25,
  10.54,
  44.74,
  100.0,
  40.57,
  41.35,
  false,
  'rejected',
  '["face_consistency_below_90", "body_consistency_below_90", "style_consistency_below_85", "global_consistency_below_90", "isi_below_90"]'::jsonb,
  '{"reference_faces": 30, "reference_bodies": 10, "reference_styles": 30, "target_images": 30, "identity_stability_goal": 100}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_001.png',
  'cafeteria',
  44.95,
  31.7,
  51.58,
  100.0,
  50.23,
  false,
  '{"face_detected": true, "face_similarity": 0.70733, "pose_landmarks_visible": 6, "pose_visibility": 0.8798, "body_completeness": 0.75, "legs_measured": false, "body_distance": 0.22379, "style_distance": 0.11035, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_002.png',
  'cafeteria',
  67.86,
  21.98,
  61.93,
  100.0,
  58.03,
  false,
  '{"face_detected": true, "face_similarity": 0.78752, "pose_landmarks_visible": 4, "pose_visibility": 0.799, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.2739, "style_distance": 0.07986, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_003.png',
  'cafeteria',
  2.93,
  45.61,
  52.64,
  100.0,
  37.75,
  false,
  '{"face_detected": true, "face_similarity": 0.56026, "pose_landmarks_visible": 4, "pose_visibility": 0.8522, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.11523, "style_distance": 0.10695, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_004.png',
  'cafeteria',
  44.43,
  0.0,
  40.82,
  100.0,
  38.9,
  false,
  '{"face_detected": true, "face_similarity": 0.70549, "pose_landmarks_visible": 2, "pose_visibility": 0.9826609492301941, "body_distance": null, "style_distance": 0.14934, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_005.png',
  'cafeteria',
  36.25,
  0.0,
  30.67,
  100.0,
  34.1,
  false,
  '{"face_detected": true, "face_similarity": 0.67687, "pose_landmarks_visible": 2, "pose_visibility": 0.9979829788208008, "body_distance": null, "style_distance": 0.19698, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_006.png',
  'cafeteria',
  39.51,
  0.0,
  39.04,
  100.0,
  36.66,
  false,
  '{"face_detected": true, "face_similarity": 0.68828, "pose_landmarks_visible": 2, "pose_visibility": 0.9970706105232239, "body_distance": null, "style_distance": 0.15678, "narrative": {"category": "cafeteria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_007.png',
  'fitness',
  34.92,
  0.0,
  55.45,
  100.0,
  37.29,
  false,
  '{"face_detected": true, "face_similarity": 0.67221, "pose_landmarks_visible": 2, "pose_visibility": 0.997633308172226, "body_distance": null, "style_distance": 0.09829, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_008.png',
  'fitness',
  22.43,
  0.0,
  21.91,
  100.0,
  27.26,
  false,
  '{"face_detected": true, "face_similarity": 0.6285, "pose_landmarks_visible": 2, "pose_visibility": 0.9904290437698364, "body_distance": null, "style_distance": 0.25302, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_009.png',
  'fitness',
  37.01,
  0.0,
  21.89,
  100.0,
  33.09,
  false,
  '{"face_detected": true, "face_similarity": 0.67955, "pose_landmarks_visible": 2, "pose_visibility": 0.9932792484760284, "body_distance": null, "style_distance": 0.25319, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_010.png',
  'fitness',
  55.48,
  0.0,
  51.22,
  100.0,
  44.88,
  false,
  '{"face_detected": true, "face_similarity": 0.74418, "pose_landmarks_visible": 2, "pose_visibility": 0.9930639266967773, "body_distance": null, "style_distance": 0.1115, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_011.png',
  'fitness',
  25.78,
  31.63,
  54.01,
  100.0,
  42.9,
  false,
  '{"face_detected": true, "face_similarity": 0.64021, "pose_landmarks_visible": 4, "pose_visibility": 0.9582, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.19485, "style_distance": 0.10267, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_012.png',
  'fitness',
  51.98,
  0.0,
  60.22,
  100.0,
  44.83,
  false,
  '{"face_detected": true, "face_similarity": 0.73192, "pose_landmarks_visible": 2, "pose_visibility": 0.8212658762931824, "body_distance": null, "style_distance": 0.08454, "narrative": {"category": "fitness", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_013.png',
  'vida_diaria',
  41.19,
  38.27,
  43.63,
  100.0,
  49.5,
  false,
  '{"face_detected": true, "face_similarity": 0.69417, "pose_landmarks_visible": 5, "pose_visibility": 0.7623, "body_completeness": 0.625, "legs_measured": false, "body_distance": 0.16863, "style_distance": 0.13825, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_014.png',
  'vida_diaria',
  0.0,
  44.85,
  31.07,
  100.0,
  33.12,
  false,
  '{"face_detected": true, "face_similarity": 0.51367, "pose_landmarks_visible": 6, "pose_visibility": 0.7995, "body_completeness": 0.75, "legs_measured": false, "body_distance": 0.14835, "style_distance": 0.19481, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_015.png',
  'vida_diaria',
  30.61,
  36.09,
  56.46,
  100.0,
  46.54,
  false,
  '{"face_detected": true, "face_similarity": 0.65713, "pose_landmarks_visible": 4, "pose_visibility": 0.7749, "body_completeness": 0.5, "legs_measured": false, "body_distance": 0.16616, "style_distance": 0.09527, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_016.png',
  'vida_diaria',
  46.38,
  10.15,
  57.23,
  100.0,
  45.18,
  false,
  '{"face_detected": true, "face_similarity": 0.71234, "pose_landmarks_visible": 6, "pose_visibility": 0.8529, "body_completeness": 0.75, "legs_measured": false, "body_distance": 0.47135, "style_distance": 0.09301, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_017.png',
  'vida_diaria',
  87.89,
  0.0,
  19.16,
  100.0,
  53.03,
  false,
  '{"face_detected": true, "face_similarity": 0.85763, "pose_landmarks_visible": 2, "pose_visibility": 0.9960210621356964, "body_distance": null, "style_distance": 0.27537, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_018.png',
  'vida_diaria',
  22.02,
  0.0,
  28.24,
  100.0,
  28.04,
  false,
  '{"face_detected": true, "face_similarity": 0.62707, "pose_landmarks_visible": 3, "pose_visibility": 0.8994803229967753, "body_distance": null, "style_distance": 0.21076, "narrative": {"category": "vida_diaria", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_019.png',
  'playa',
  7.98,
  0.0,
  61.58,
  100.0,
  27.43,
  false,
  '{"face_detected": true, "face_similarity": 0.57794, "pose_landmarks_visible": 2, "pose_visibility": 0.9976723790168762, "body_distance": null, "style_distance": 0.08081, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_020.png',
  'playa',
  46.72,
  0.0,
  38.03,
  100.0,
  39.39,
  false,
  '{"face_detected": true, "face_similarity": 0.71353, "pose_landmarks_visible": 2, "pose_visibility": 0.9988204538822174, "body_distance": null, "style_distance": 0.16115, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_021.png',
  'playa',
  39.59,
  44.11,
  42.85,
  100.0,
  50.5,
  false,
  '{"face_detected": true, "face_similarity": 0.68857, "pose_landmarks_visible": 5, "pose_visibility": 0.8838, "body_completeness": 0.625, "legs_measured": false, "body_distance": 0.13774, "style_distance": 0.14123, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_022.png',
  'playa',
  71.56,
  0.0,
  54.19,
  100.0,
  51.75,
  false,
  '{"face_detected": true, "face_similarity": 0.80048, "pose_landmarks_visible": 2, "pose_visibility": 0.9922577738761902, "body_distance": null, "style_distance": 0.10211, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_023.png',
  'playa',
  52.82,
  0.0,
  34.27,
  100.0,
  41.27,
  false,
  '{"face_detected": true, "face_similarity": 0.73486, "pose_landmarks_visible": 2, "pose_visibility": 0.9976162612438202, "body_distance": null, "style_distance": 0.17848, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_024.png',
  'playa',
  76.48,
  0.0,
  47.51,
  100.0,
  52.72,
  false,
  '{"face_detected": true, "face_similarity": 0.81767, "pose_landmarks_visible": 2, "pose_visibility": 0.985368400812149, "body_distance": null, "style_distance": 0.12404, "narrative": {"category": "playa", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_025.png',
  'viajes',
  21.57,
  0.0,
  48.59,
  100.0,
  30.92,
  false,
  '{"face_detected": true, "face_similarity": 0.6255, "pose_landmarks_visible": 2, "pose_visibility": 0.9988143444061279, "body_distance": null, "style_distance": 0.12028, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_026.png',
  'viajes',
  38.48,
  0.0,
  53.78,
  100.0,
  38.46,
  false,
  '{"face_detected": true, "face_similarity": 0.68469, "pose_landmarks_visible": 3, "pose_visibility": 0.8339251279830933, "body_distance": null, "style_distance": 0.10337, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_027.png',
  'viajes',
  39.64,
  11.78,
  57.2,
  100.0,
  42.97,
  false,
  '{"face_detected": true, "face_similarity": 0.68875, "pose_landmarks_visible": 6, "pose_visibility": 0.8197, "body_completeness": 0.75, "legs_measured": false, "body_distance": 0.43905, "style_distance": 0.0931, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_028.png',
  'viajes',
  11.78,
  0.0,
  49.15,
  100.0,
  27.08,
  false,
  '{"face_detected": true, "face_similarity": 0.59122, "pose_landmarks_visible": 3, "pose_visibility": 0.8247349262237549, "body_distance": null, "style_distance": 0.11838, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_029.png',
  'viajes',
  24.58,
  0.0,
  48.68,
  100.0,
  32.13,
  false,
  '{"face_detected": true, "face_similarity": 0.63602, "pose_landmarks_visible": 2, "pose_visibility": 0.9951716661453247, "body_distance": null, "style_distance": 0.12, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);

INSERT INTO consistency_items (batch_id, character_slug, image_path, category, face_score, body_score, style_score, narrative_score, global_score, approved, metrics)
VALUES (
  '3f66115c-426b-4912-b152-b3affe38d1b6'::uuid,
  'elena-voss',
  'dataset_lora/images/elena_voss_030.png',
  'viajes',
  54.67,
  0.0,
  29.17,
  100.0,
  41.24,
  false,
  '{"face_detected": true, "face_similarity": 0.74135, "pose_landmarks_visible": 2, "pose_visibility": 0.9425992369651794, "body_distance": null, "style_distance": 0.20536, "narrative": {"category": "viajes", "missing_identity_terms": [], "has_trigger": true}}'::jsonb
);
