\set ON_ERROR_STOP on
\i database/schema.sql

INSERT INTO content_generation_runs (id, character_slug, source_model, prompt_set, requested_counts, actual_counts, metadata)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'qwen3:8b',
  'fase7_initial_editorial_batch',
  '{"tiktok_idea": 20, "caption": 20, "hook": 20, "story": 20}'::jsonb,
  '{"tiktok_idea": 20, "caption": 20, "hook": 20, "story": 20}'::jsonb,
  '{"phase": 7, "generator": "scripts/generate_editorial_content.py", "created_at": "2026-05-31T23:29:26.275993+00:00"}'::jsonb
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'playa',
  'TikTok',
  'Como preparar una ensalada de frutas para el desayuno en la playa',
  'Una receta simple y refrescante que puedes hacer en casa y llevar contigo a la playa. Ideal para disfrutar del sol con energía.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 1, "raw": {"category": "playa", "title": "Como preparar una ensalada de frutas para el desayuno en la playa", "description": "Una receta simple y refrescante que puedes hacer en casa y llevar contigo a la playa. Ideal para disfrutar del sol con energ\u00eda.", "visual_scene": "Valentina prepara una ensalada de frutas en una bandeja, con una botella de agua y una toalla al lado.", "cta": "\u00bfQuieres probar esta receta? \u00a1Sigue mi cuenta para m\u00e1s ideas de alimentaci\u00f3n saludable!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'cafeteria',
  'TikTok',
  'El mejor café de la ciudad para empezar el día',
  'Descubre un lugar tranquilo donde el café es lo más importante. Ideal para leer, trabajar o simplemente relajarte.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 2, "raw": {"category": "cafeteria", "title": "El mejor caf\u00e9 de la ciudad para empezar el d\u00eda", "description": "Descubre un lugar tranquilo donde el caf\u00e9 es lo m\u00e1s importante. Ideal para leer, trabajar o simplemente relajarte.", "visual_scene": "Valentina toma un caf\u00e9 en una cafeter\u00eda con vista a la calle, con una libreta y un bol\u00edgrafo al lado.", "cta": "\u00bfTe gustar\u00eda conocer este lugar? \u00a1M\u00e1ndame un mensaje y te cuento m\u00e1s!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'gym',
  'TikTok',
  'Rutina de 20 minutos para tonificar el core',
  'Una rutina sencilla y efectiva que puedes hacer en casa. Ideal para mejorar tu postura y sentirte más fuerte.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 3, "raw": {"category": "gym", "title": "Rutina de 20 minutos para tonificar el core", "description": "Una rutina sencilla y efectiva que puedes hacer en casa. Ideal para mejorar tu postura y sentirte m\u00e1s fuerte.", "visual_scene": "Valentina hace ejercicios de core en el suelo, con una toalla y una botella de agua al lado.", "cta": "\u00bfQuieres probar esta rutina? \u00a1Sigue mi cuenta para m\u00e1s consejos de fitness!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'viajes',
  'TikTok',
  'Descubre el encanto de un viaje de fin de semana en bicicleta',
  'Un viaje sostenible y relajante que te llevará a descubrir lugares nuevos. Ideal para desconectar y disfrutar del paisaje.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 4, "raw": {"category": "viajes", "title": "Descubre el encanto de un viaje de fin de semana en bicicleta", "description": "Un viaje sostenible y relajante que te llevar\u00e1 a descubrir lugares nuevos. Ideal para desconectar y disfrutar del paisaje.", "visual_scene": "Valentina pedalea por una ruta costera, con el sol al caer y una mochila al hombro.", "cta": "\u00bfTe gustar\u00eda hacer un viaje como este? \u00a1M\u00e1ndame un mensaje y te cuento m\u00e1s!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'lifestyle',
  'TikTok',
  'Cómo organizar tu espacio para sentirte más tranquila',
  'Un consejo práctico para ordenar tu espacio y crear un ambiente de calma. Ideal para mejorar tu bienestar diario.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 5, "raw": {"category": "lifestyle", "title": "C\u00f3mo organizar tu espacio para sentirte m\u00e1s tranquila", "description": "Un consejo pr\u00e1ctico para ordenar tu espacio y crear un ambiente de calma. Ideal para mejorar tu bienestar diario.", "visual_scene": "Valentina organiza una mesa de trabajo con libros, plantas y una taza de t\u00e9.", "cta": "\u00bfQuieres aprender a organizar tu espacio? \u00a1Sigue mi cuenta para m\u00e1s ideas!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'playa',
  'TikTok',
  'Cómo hacer un baño de sol sin dañar tu piel',
  'Un consejo práctico para disfrutar del sol de forma segura. Ideal para protegerte y no quemarte.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 6, "raw": {"category": "playa", "title": "C\u00f3mo hacer un ba\u00f1o de sol sin da\u00f1ar tu piel", "description": "Un consejo pr\u00e1ctico para disfrutar del sol de forma segura. Ideal para protegerte y no quemarte.", "visual_scene": "Valentina se sienta en la arena con una sombrilla y una botella de agua al lado.", "cta": "\u00bfQuieres aprender a protegerte del sol? \u00a1Sigue mi cuenta para m\u00e1s consejos!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'cafeteria',
  'TikTok',
  'El mejor lugar para tomar un café con amigos',
  'Un espacio acogedor donde puedes pasar tiempo con amigos o familia. Ideal para disfrutar de un café y una conversación.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 7, "raw": {"category": "cafeteria", "title": "El mejor lugar para tomar un caf\u00e9 con amigos", "description": "Un espacio acogedor donde puedes pasar tiempo con amigos o familia. Ideal para disfrutar de un caf\u00e9 y una conversaci\u00f3n.", "visual_scene": "Valentina toma un caf\u00e9 con una amiga en una cafeter\u00eda con mesas de madera y plantas.", "cta": "\u00bfTe gustar\u00eda conocer este lugar? \u00a1M\u00e1ndame un mensaje y te cuento m\u00e1s!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'gym',
  'TikTok',
  'Ejercicios para mejorar tu postura en casa',
  'Un conjunto de ejercicios sencillos que puedes hacer en casa. Ideal para mejorar tu postura y sentirte más cómoda.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 8, "raw": {"category": "gym", "title": "Ejercicios para mejorar tu postura en casa", "description": "Un conjunto de ejercicios sencillos que puedes hacer en casa. Ideal para mejorar tu postura y sentirte m\u00e1s c\u00f3moda.", "visual_scene": "Valentina hace ejercicios de postura en el suelo, con una toalla y una botella de agua al lado.", "cta": "\u00bfQuieres probar estos ejercicios? \u00a1Sigue mi cuenta para m\u00e1s consejos!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'viajes',
  'TikTok',
  'Cómo planificar un viaje de fin de semana con poco presupuesto',
  'Un consejo práctico para viajar sin gastar mucho. Ideal para disfrutar de un viaje económico y divertido.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 9, "raw": {"category": "viajes", "title": "C\u00f3mo planificar un viaje de fin de semana con poco presupuesto", "description": "Un consejo pr\u00e1ctico para viajar sin gastar mucho. Ideal para disfrutar de un viaje econ\u00f3mico y divertido.", "visual_scene": "Valentina mira un mapa y una gu\u00eda de viaje en su mesita de noche.", "cta": "\u00bfQuieres aprender a planificar un viaje econ\u00f3mico? \u00a1M\u00e1ndame un mensaje y te cuento m\u00e1s!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'lifestyle',
  'TikTok',
  'Cómo mejorar tu productividad con rutinas sencillas',
  'Un consejo práctico para organizar tu día y sentirte más productiva. Ideal para mejorar tu bienestar diario.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 10, "raw": {"category": "lifestyle", "title": "C\u00f3mo mejorar tu productividad con rutinas sencillas", "description": "Un consejo pr\u00e1ctico para organizar tu d\u00eda y sentirte m\u00e1s productiva. Ideal para mejorar tu bienestar diario.", "visual_scene": "Valentina escribe en una libreta con un bol\u00edgrafo y una taza de caf\u00e9 al lado.", "cta": "\u00bfQuieres aprender a mejorar tu productividad? \u00a1Sigue mi cuenta para m\u00e1s ideas!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'playa',
  'TikTok',
  'Cómo hacer un picnic perfecto en la playa',
  'Un consejo práctico para preparar un picnic sencillo y delicioso. Ideal para disfrutar del sol y la naturaleza.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 11, "raw": {"category": "playa", "title": "C\u00f3mo hacer un picnic perfecto en la playa", "description": "Un consejo pr\u00e1ctico para preparar un picnic sencillo y delicioso. Ideal para disfrutar del sol y la naturaleza.", "visual_scene": "Valentina pone una manta y comida en la arena con una botella de agua al lado.", "cta": "\u00bfQuieres probar esta receta? \u00a1Sigue mi cuenta para m\u00e1s ideas de alimentaci\u00f3n saludable!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'cafeteria',
  'TikTok',
  'El mejor café de la ciudad para leer un libro',
  'Un lugar tranquilo donde puedes leer un libro o un artículo. Ideal para disfrutar del café y la lectura.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 12, "raw": {"category": "cafeteria", "title": "El mejor caf\u00e9 de la ciudad para leer un libro", "description": "Un lugar tranquilo donde puedes leer un libro o un art\u00edculo. Ideal para disfrutar del caf\u00e9 y la lectura.", "visual_scene": "Valentina lee un libro en una cafeter\u00eda con una taza de caf\u00e9 al lado.", "cta": "\u00bfTe gustar\u00eda conocer este lugar? \u00a1M\u00e1ndame un mensaje y te cuento m\u00e1s!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'gym',
  'TikTok',
  'Ejercicios para tonificar las piernas en casa',
  'Un conjunto de ejercicios sencillos que puedes hacer en casa. Ideal para mejorar tu físico y sentirte más fuerte.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 13, "raw": {"category": "gym", "title": "Ejercicios para tonificar las piernas en casa", "description": "Un conjunto de ejercicios sencillos que puedes hacer en casa. Ideal para mejorar tu f\u00edsico y sentirte m\u00e1s fuerte.", "visual_scene": "Valentina hace ejercicios de piernas en el suelo, con una toalla y una botella de agua al lado.", "cta": "\u00bfQuieres probar estos ejercicios? \u00a1Sigue mi cuenta para m\u00e1s consejos!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'viajes',
  'TikTok',
  'Cómo viajar en tren a una ciudad cercana',
  'Un consejo práctico para planificar un viaje en tren. Ideal para disfrutar de un viaje sostenible y divertido.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 14, "raw": {"category": "viajes", "title": "C\u00f3mo viajar en tren a una ciudad cercana", "description": "Un consejo pr\u00e1ctico para planificar un viaje en tren. Ideal para disfrutar de un viaje sostenible y divertido.", "visual_scene": "Valentina mira el reloj y la ruta del tren en su tel\u00e9fono.", "cta": "\u00bfQuieres aprender a viajar en tren? \u00a1M\u00e1ndame un mensaje y te cuento m\u00e1s!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'lifestyle',
  'TikTok',
  'Cómo cuidar tu mente con rutinas sencillas',
  'Un consejo práctico para mejorar tu bienestar mental. Ideal para sentirte más tranquila y feliz.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 15, "raw": {"category": "lifestyle", "title": "C\u00f3mo cuidar tu mente con rutinas sencillas", "description": "Un consejo pr\u00e1ctico para mejorar tu bienestar mental. Ideal para sentirte m\u00e1s tranquila y feliz.", "visual_scene": "Valentina escribe en una libreta con un bol\u00edgrafo y una taza de t\u00e9 al lado.", "cta": "\u00bfQuieres aprender a cuidar tu mente? \u00a1Sigue mi cuenta para m\u00e1s ideas!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'playa',
  'TikTok',
  'Cómo preparar un cóctel de piña y hielo para el verano',
  'Una receta simple y refrescante que puedes hacer en casa y llevar contigo a la playa. Ideal para disfrutar del sol con energía.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 16, "raw": {"category": "playa", "title": "C\u00f3mo preparar un c\u00f3ctel de pi\u00f1a y hielo para el verano", "description": "Una receta simple y refrescante que puedes hacer en casa y llevar contigo a la playa. Ideal para disfrutar del sol con energ\u00eda.", "visual_scene": "Valentina prepara un c\u00f3ctel de pi\u00f1a y hielo en una taza, con una botella de agua al lado.", "cta": "\u00bfQuieres probar esta receta? \u00a1Sigue mi cuenta para m\u00e1s ideas de alimentaci\u00f3n saludable!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'cafeteria',
  'TikTok',
  'El mejor lugar para tomar un café y trabajar',
  'Un espacio acogedor donde puedes trabajar o estudiar. Ideal para disfrutar del café y la concentración.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 17, "raw": {"category": "cafeteria", "title": "El mejor lugar para tomar un caf\u00e9 y trabajar", "description": "Un espacio acogedor donde puedes trabajar o estudiar. Ideal para disfrutar del caf\u00e9 y la concentraci\u00f3n.", "visual_scene": "Valentina escribe en una libreta con un bol\u00edgrafo y una taza de caf\u00e9 al lado.", "cta": "\u00bfTe gustar\u00eda conocer este lugar? \u00a1M\u00e1ndame un mensaje y te cuento m\u00e1s!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'gym',
  'TikTok',
  'Ejercicios para mejorar tu flexibilidad en casa',
  'Un conjunto de ejercicios sencillos que puedes hacer en casa. Ideal para mejorar tu flexibilidad y sentirte más cómoda.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 18, "raw": {"category": "gym", "title": "Ejercicios para mejorar tu flexibilidad en casa", "description": "Un conjunto de ejercicios sencillos que puedes hacer en casa. Ideal para mejorar tu flexibilidad y sentirte m\u00e1s c\u00f3moda.", "visual_scene": "Valentina hace ejercicios de flexibilidad en el suelo, con una toalla y una botella de agua al lado.", "cta": "\u00bfQuieres probar estos ejercicios? \u00a1Sigue mi cuenta para m\u00e1s consejos!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'viajes',
  'TikTok',
  'Cómo planificar un viaje de fin de semana en coche',
  'Un consejo práctico para planificar un viaje en coche. Ideal para disfrutar de un viaje sostenible y divertido.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 19, "raw": {"category": "viajes", "title": "C\u00f3mo planificar un viaje de fin de semana en coche", "description": "Un consejo pr\u00e1ctico para planificar un viaje en coche. Ideal para disfrutar de un viaje sostenible y divertido.", "visual_scene": "Valentina mira el mapa y la ruta del coche en su tel\u00e9fono.", "cta": "\u00bfQuieres aprender a planificar un viaje en coche? \u00a1M\u00e1ndame un mensaje y te cuento m\u00e1s!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'tiktok_idea',
  'lifestyle',
  'TikTok',
  'Cómo mejorar tu autoestima con rutinas sencillas',
  'Un consejo práctico para mejorar tu autoestima. Ideal para sentirte más feliz y segura.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera ideas de video TikTok para Valentina Sol. Cada item debe tener: title, category, description, visual_scene, cta. Usa categorias repartidas entre playa, cafeteria, gym, viajes y lifestyle.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 20, "raw": {"category": "lifestyle", "title": "C\u00f3mo mejorar tu autoestima con rutinas sencillas", "description": "Un consejo pr\u00e1ctico para mejorar tu autoestima. Ideal para sentirte m\u00e1s feliz y segura.", "visual_scene": "Valentina escribe en una libreta con un bol\u00edgrafo y una taza de t\u00e9 al lado.", "cta": "\u00bfQuieres aprender a mejorar tu autoestima? \u00a1Sigue mi cuenta para m\u00e1s ideas!"}, "prompt_type": "tiktok_idea"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'playa',
  'Instagram/TikTok',
  'relajado',
  'La brisa de la mañana y el sonido del mar son lo mejor para empezar el día. Me quedo un rato mirando el horizonte, buscando inspiración.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 1, "raw": {"category": "playa", "caption": "La brisa de la ma\u00f1ana y el sonido del mar son lo mejor para empezar el d\u00eda. Me quedo un rato mirando el horizonte, buscando inspiraci\u00f3n.", "hashtags": "#vidaenlaplaya #conexionconla naturaleza #momentosdecalma", "mood": "relajado"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'cafeteria',
  'Instagram/TikTok',
  'calmado',
  'Una taza de café recién hecho y una mesa al aire libre. Los detalles pequeños son los que hacen la diferencia.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 2, "raw": {"category": "cafeteria", "caption": "Una taza de caf\u00e9 reci\u00e9n hecho y una mesa al aire libre. Los detalles peque\u00f1os son los que hacen la diferencia.", "hashtags": "#cafeteriadeldia #lifestylelatino #diasconflavor", "mood": "calmado"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'gym',
  'Instagram/TikTok',
  'motivador',
  'No es sobre ser perfecta, es sobre hacer lo que te hace sentir bien. Hoy me enfocé en movilidad y respiración.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 3, "raw": {"category": "gym", "caption": "No es sobre ser perfecta, es sobre hacer lo que te hace sentir bien. Hoy me enfoc\u00e9 en movilidad y respiraci\u00f3n.", "hashtags": "#gymamable #vidaactiva #cuerpoymente", "mood": "motivador"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'viajes',
  'Instagram/TikTok',
  'aspiracional',
  'Un viaje corto, una ciudad nueva y una mente abierta. La vida es más interesante cuando exploras con curiosidad.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 4, "raw": {" nadir": "viajes", "caption": "Un viaje corto, una ciudad nueva y una mente abierta. La vida es m\u00e1s interesante cuando exploras con curiosidad.", "hashtags": "#viajescortos #ciudadnueva #experiencias", "mood": "aspiracional"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'lifestyle',
  'Instagram/TikTok',
  'reflexivo',
  'Hoy me enfocé en lo que realmente importa: momentos simples, conexiones reales y un poco de paz.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 5, "raw": {"category": "lifestyle", "caption": "Hoy me enfoc\u00e9 en lo que realmente importa: momentos simples, conexiones reales y un poco de paz.", "hashtags": "#lifestyleconsciente #vidaenbalance #momentosreales", "mood": "reflexivo"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'playa',
  'Instagram/TikTok',
  'relajado',
  'El mar es un lugar de descanso y conexión. Hoy me quedé mirando las olas, recordando que la vida también tiene ritmo.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 6, "raw": {"category": "playa", "caption": "El mar es un lugar de descanso y conexi\u00f3n. Hoy me qued\u00e9 mirando las olas, recordando que la vida tambi\u00e9n tiene ritmo.", "hashtags": "#playasenlatinoamerica #conexionconlamar #momentosdecalma", "mood": "relajado"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'cafeteria',
  'Instagram/TikTok',
  'calmado',
  'Una mañana tranquila, una taza de café y un espacio que te hace sentir como en casa. Los pequeños detalles son los que marcan la diferencia.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 7, "raw": {"category": "cafeteria", "caption": "Una ma\u00f1ana tranquila, una taza de caf\u00e9 y un espacio que te hace sentir como en casa. Los peque\u00f1os detalles son los que marcan la diferencia.", "hashtags": "#caf\u00e9yconexi\u00f3n #diasconflavor #lifestylelatino", "mood": "calmado"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'gym',
  'Instagram/TikTok',
  'motivador',
  'El ejercicio no tiene que ser intenso. A veces, es solo sobre mantener la rutina y sentirse bien contigo mismo.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 8, "raw": {"category": "gym", "caption": "El ejercicio no tiene que ser intenso. A veces, es solo sobre mantener la rutina y sentirse bien contigo mismo.", "hashtags": "#gymamable #vidaactiva #cuerpoymente", "mood": "motivador"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'viajes',
  'Instagram/TikTok',
  'aspiracional',
  'Un viaje corto, una ciudad nueva y una mente abierta. La vida es más interesante cuando exploras con curiosidad.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 9, "raw": {"category": "viajes", "caption": "Un viaje corto, una ciudad nueva y una mente abierta. La vida es m\u00e1s interesante cuando exploras con curiosidad.", "hashtags": "#viajescortos #ciudadnueva #experiencias", "mood": "aspiracional"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'lifestyle',
  'Instagram/TikTok',
  'reflexivo',
  'Hoy me enfocé en lo que realmente importa: momentos simples, conexiones reales y un poco de paz.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 10, "raw": {"category": "lifestyle", "caption": "Hoy me enfoc\u00e9 en lo que realmente importa: momentos simples, conexiones reales y un poco de paz.", "hashtags": "#lifestyleconsciente #vidaenbalance #momentosreales", "mood": "reflexivo"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'playa',
  'Instagram/TikTok',
  'relajado',
  'La brisa de la mañana y el sonido del mar son lo mejor para empezar el día. Me quedo un rato mirando el horizonte, buscando inspiración.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 11, "raw": {"category": "playa", "caption": "La brisa de la ma\u00f1ana y el sonido del mar son lo mejor para empezar el d\u00eda. Me quedo un rato mirando el horizonte, buscando inspiraci\u00f3n.", "hashtags": "#vidaenlaplaya #conexionconla naturaleza #momentosdecalma", "mood": "relajado"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'cafeteria',
  'Instagram/TikTok',
  'calmado',
  'Una taza de café recién hecho y una mesa al aire libre. Los detalles pequeños son los que hacen la diferencia.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 12, "raw": {"category": "cafeteria", "caption": "Una taza de caf\u00e9 reci\u00e9n hecho y una mesa al aire libre. Los detalles peque\u00f1os son los que hacen la diferencia.", "hashtags": "#cafeteriadeldia #lifestylelatino #diasconflavor", "mood": "calmado"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'gym',
  'Instagram/TikTok',
  'motivador',
  'No es sobre ser perfecta, es sobre hacer lo que te hace sentir bien. Hoy me enfocé en movilidad y respiración.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 13, "raw": {"category": "gym", "caption": "No es sobre ser perfecta, es sobre hacer lo que te hace sentir bien. Hoy me enfoc\u00e9 en movilidad y respiraci\u00f3n.", "hashtags": "#gymamable #vidaactiva #cuerpoymente", "mood": "motivador"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'viajes',
  'Instagram/TikTok',
  'aspiracional',
  'Un viaje corto, una ciudad nueva y una mente abierta. La vida es más interesante cuando exploras con curiosidad.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 14, "raw": {"category": "viajes", "caption": "Un viaje corto, una ciudad nueva y una mente abierta. La vida es m\u00e1s interesante cuando exploras con curiosidad.", "hashtags": "#viajescortos #ciudadnueva #experiencias", "mood": "aspiracional"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'lifestyle',
  'Instagram/TikTok',
  'reflexivo',
  'Hoy me enfocé en lo que realmente importa: momentos simples, conexiones reales y un poco de paz.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 15, "raw": {"category": "lifestyle", "caption": "Hoy me enfoc\u00e9 en lo que realmente importa: momentos simples, conexiones reales y un poco de paz.", "hashtags": "#lifestyleconsciente #vidaenbalance #momentosreales", "mood": "reflexivo"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'playa',
  'Instagram/TikTok',
  'relajado',
  'El mar es un lugar de descanso y conexión. Hoy me quedé mirando las olas, recordando que la vida también tiene ritmo.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 16, "raw": {"category": "playa", "caption": "El mar es un lugar de descanso y conexi\u00f3n. Hoy me qued\u00e9 mirando las olas, recordando que la vida tambi\u00e9n tiene ritmo.", "hashtags": "#playasenlatinoamerica #conexionconlamar #momentosdecalma", "mood": "relajado"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'cafeteria',
  'Instagram/TikTok',
  'calmado',
  'Una mañana tranquila, una taza de café y un espacio que te hace sentir como en casa. Los pequeños detalles son los que marcan la diferencia.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 17, "raw": {"category": "cafeteria", "caption": "Una ma\u00f1ana tranquila, una taza de caf\u00e9 y un espacio que te hace sentir como en casa. Los peque\u00f1os detalles son los que marcan la diferencia.", "hashtags": "#caf\u00e9yconexi\u00f3n #diasconflavor #lifestylelatino", "mood": "calmado"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'gym',
  'Instagram/TikTok',
  'motivador',
  'El ejercicio no tiene que ser intenso. A veces, es solo sobre mantener la rutina y sentirse bien contigo mismo.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 18, "raw": {"category": "gym", "caption": "El ejercicio no tiene que ser intenso. A veces, es solo sobre mantener la rutina y sentirse bien contigo mismo.", "hashtags": "#gymamable #vidaactiva #cuerpoymente", "mood": "motivador"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'viajes',
  'Instagram/TikTok',
  'aspiracional',
  'Un viaje corto, una ciudad nueva y una mente abierta. La vida es más interesante cuando exploras con curiosidad.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 19, "raw": {"category": "viajes", "caption": "Un viaje corto, una ciudad nueva y una mente abierta. La vida es m\u00e1s interesante cuando exploras con curiosidad.", "hashtags": "#viajescortos #ciudadnueva #experiencias", "mood": "aspiracional"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'caption',
  'lifestyle',
  'Instagram/TikTok',
  'reflexivo',
  'Hoy me enfocé en lo que realmente importa: momentos simples, conexiones reales y un poco de paz.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera captions listos para publicar. Cada item debe tener: category, caption, hashtags, mood. Captions en espanol latino, naturales, sin promesas falsas.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 20, "raw": {"category": "lifestyle", "caption": "Hoy me enfoc\u00e9 en lo que realmente importa: momentos simples, conexiones reales y un poco de paz.", "hashtags": "#lifestyleconsciente #vidaenbalance #momentosreales", "mood": "reflexivo"}, "prompt_type": "caption"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'playa',
  'TikTok',
  'Descubre cómo la playa se convierte en tu espacio de paz',
  '¿Sabías que el mar puede curarte el alma?',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 1, "raw": {"category": "playa", "hook": "\u00bfSab\u00edas que el mar puede curarte el alma?", "angle": "Descubre c\u00f3mo la playa se convierte en tu espacio de paz", "format": "TikTok con escena de relajaci\u00f3n en la playa"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'cafeteria',
  'TikTok',
  'La magia de un café que te transporta a otro lugar',
  'Este café me hace sentir como si estuviera en un viaje',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 2, "raw": {"category": "cafeteria", "hook": "Este caf\u00e9 me hace sentir como si estuviera en un viaje", "angle": "La magia de un caf\u00e9 que te transporta a otro lugar", "format": "TikTok con escena de toma de caf\u00e9 en un ambiente acogedor"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'gym',
  'TikTok',
  'Cómo el gym puede ser parte de tu rutina de forma natural',
  'Ejercicio sin esfuerzo, pero con resultados',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 3, "raw": {"category": "gym", "hook": "Ejercicio sin esfuerzo, pero con resultados", "angle": "C\u00f3mo el gym puede ser parte de tu rutina de forma natural", "format": "TikTok con escena de entrenamiento suave"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'viajes',
  'TikTok',
  'La belleza de descubrir lugares sin mapas',
  'Un viaje que no necesitaba un plan',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 4, "raw": {"category": "viajes", "hook": "Un viaje que no necesitaba un plan", "angle": "La belleza de descubrir lugares sin mapas", "format": "TikTok con escena de exploraci\u00f3n en un destino inesperado"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'lifestyle',
  'TikTok',
  'Cómo construir un estilo de vida sostenible y feliz',
  'La vida que me gustaría vivir',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 5, "raw": {"category": "lifestyle", "hook": "La vida que me gustar\u00eda vivir", "angle": "C\u00f3mo construir un estilo de vida sostenible y feliz", "format": "TikTok con escena de rutina diaria con toques de estilo"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'playa',
  'TikTok',
  'Cómo integrar la playa en tu rutina matutina',
  'El sonido del mar es el mejor despertador',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 6, "raw": {"category": "playa", "hook": "El sonido del mar es el mejor despertador", "angle": "C\u00f3mo integrar la playa en tu rutina matutina", "format": "TikTok con escena de levantarse al amanecer en la playa"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'cafeteria',
  'TikTok',
  'Cómo un lugar puede evocar recuerdos y emociones',
  'Un café que huele a nostalgia',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 7, "raw": {"category": "cafeteria", "hook": "Un caf\u00e9 que huele a nostalgia", "angle": "C\u00f3mo un lugar puede evocar recuerdos y emociones", "format": "TikTok con escena de toma de caf\u00e9 en un ambiente con historia"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'gym',
  'TikTok',
  'Cómo hacer ejercicio sin sacrificar tu vida social',
  'Ejercicio que no te quita el tiempo',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 8, "raw": {"3": "gym", "hook": "Ejercicio que no te quita el tiempo", "angle": "C\u00f3mo hacer ejercicio sin sacrificar tu vida social", "format": "TikTok con escena de entrenamiento entre compromisos"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'viajes',
  'TikTok',
  'La sorpresa de descubrir lugares inesperados',
  'Un destino que no estaba en mi lista',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 9, "raw": {"category": "viajes", "hook": "Un destino que no estaba en mi lista", "angle": "La sorpresa de descubrir lugares inesperados", "format": "TikTok con escena de exploraci\u00f3n sin plan"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'lifestyle',
  'TikTok',
  'Cómo equilibrar ambas cosas en tu vida',
  'Vivir con propósito sin renunciar al placer',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 10, "raw": {"category": "lifestyle", "hook": "Vivir con prop\u00f3sito sin renunciar al placer", "angle": "C\u00f3mo equilibrar ambas cosas en tu vida", "format": "TikTok con escena de balance entre trabajo y ocio"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'playa',
  'TikTok',
  'Cómo la playa puede ser tu espacio de introspección',
  'El mar como reflejo de tu estado interior',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 11, "raw": {"category": "playa", "hook": "El mar como reflejo de tu estado interior", "angle": "C\u00f3mo la playa puede ser tu espacio de introspecci\u00f3n", "format": "TikTok con escena de reflexi\u00f3n junto al mar"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'cafeteria',
  'TikTok',
  'Cómo un lugar puede satisfacer más que el estómago',
  'Un café que no solo satisface el hambre',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 12, "raw": {"category": "cafeteria", "hook": "Un caf\u00e9 que no solo satisface el hambre", "angle": "C\u00f3mo un lugar puede satisfacer m\u00e1s que el est\u00f3mago", "format": "TikTok con escena de toma de caf\u00e9 con detalles sensoriales"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'gym',
  'TikTok',
  'Cómo el gimnasio puede ser parte de tu bienestar emocional',
  'Ejercicio que te hace sentir mejor sin esfuerzo',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 13, "raw": {"category": "gym", "hook": "Ejercicio que te hace sentir mejor sin esfuerzo", "angle": "C\u00f3mo el gimnasio puede ser parte de tu bienestar emocional", "format": "TikTok con escena de entrenamiento con enfoque emocional"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'viajes',
  'TikTok',
  'Cómo descubrir lugares sin dejar tu casa',
  'Un viaje que no requiere maletas',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 14, "raw": {"category": "viajes", "hook": "Un viaje que no requiere maletas", "angle": "C\u00f3mo descubrir lugares sin dejar tu casa", "format": "TikTok con escena de viaje virtual en casa"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'lifestyle',
  'TikTok',
  'Cómo crear tu propio estilo de vida sin imitar a otros',
  'La vida que quieres vivir, no la que te dicen que debes',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 15, "raw": {"category": "lifestyle", "hook": "La vida que quieres vivir, no la que te dicen que debes", "angle": "C\u00f3mo crear tu propio estilo de vida sin imitar a otros", "format": "TikTok con escena de elecci\u00f3n personal en estilo de vida"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'playa',
  'TikTok',
  'Cómo la playa puede ser tu lugar de curación',
  'El mar como una terapia natural',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 16, "raw": {"category": "playa", "hook": "El mar como una terapia natural", "angle": "C\u00f3mo la playa puede ser tu lugar de curaci\u00f3n", "format": "TikTok con escena de relajaci\u00f3n en la playa"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'cafeteria',
  'TikTok',
  'Cómo un lugar puede ser tu fuente de energía natural',
  'Un café que te da energía sin cafeína',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 17, "raw": {"category": "cafeteria", "hook": "Un caf\u00e9 que te da energ\u00eda sin cafe\u00edna", "angle": "C\u00f3mo un lugar puede ser tu fuente de energ\u00eda natural", "format": "TikTok con escena de toma de caf\u00e9 con energ\u00eda natural"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'gym',
  'TikTok',
  'Cómo hacer ejercicio sin sentirte obligado',
  'Ejercicio que se adapta a tu ritmo',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 18, "raw": {"category": "gym", "hook": "Ejercicio que se adapta a tu ritmo", "angle": "C\u00f3mo hacer ejercicio sin sentirte obligado", "format": "TikTok con escena de entrenamiento flexible"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'viajes',
  'TikTok',
  'Cómo disfrutar de viajes sin moverte de casa',
  'Un viaje que no requiere viajar',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 19, "raw": {"category": "viajes", "hook": "Un viaje que no requiere viajar", "angle": "C\u00f3mo disfrutar de viajes sin moverte de casa", "format": "TikTok con escena de viaje virtual"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'hook',
  'lifestyle',
  'TikTok',
  'Cómo encontrar equilibrio entre ambas cosas',
  'Vivir con autenticidad y sin renunciar al lujo',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera hooks de primera linea para TikTok. Cada item debe tener: category, hook, angle, format. Deben abrir curiosidad sin clickbait agresivo.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 20, "raw": {"category": "lifestyle", "hook": "Vivir con autenticidad y sin renunciar al lujo", "angle": "C\u00f3mo encontrar equilibrio entre ambas cosas", "format": "TikTok con escena de estilo de vida con toques de lujo"}, "prompt_type": "hook"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'playa',
  'Instagram Stories',
  'Paseo al atardecer',
  'A veces la mejor manera de relajarse es caminar por la playa con el sol en la espalda. La brisa, el sonido de las olas y la sensación de arena bajo los pies son una receta perfecta para el alma.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 1, "raw": {"category": "playa", "title": "Paseo al atardecer", "story": "A veces la mejor manera de relajarse es caminar por la playa con el sol en la espalda. La brisa, el sonido de las olas y la sensaci\u00f3n de arena bajo los pies son una receta perfecta para el alma.", "frames": ["Camino hacia la orilla con la brisa fresca.", "Miro al horizonte mientras el sol se pone.", "Me siento en la arena con una toalla y un libro."], "cta": "\u00bfTe gustar\u00eda disfrutar un atardecer como este?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'cafeteria',
  'Instagram Stories',
  'Café en el jardín',
  'Las cafeterías son lugares donde el tiempo se detiene. Puedes disfrutar un café hecho con amor mientras observas a la gente pasar y a las flores moverse con la brisa.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 2, "raw": {"category": "cafeteria", "title": "Caf\u00e9 en el jard\u00edn", "story": "Las cafeter\u00edas son lugares donde el tiempo se detiene. Puedes disfrutar un caf\u00e9 hecho con amor mientras observas a la gente pasar y a las flores moverse con la brisa.", "frames": ["Paso por una cafeter\u00eda con jard\u00edn.", "Pido un caf\u00e9 y me siento en una mesa.", "Observo el entorno con una sonrisa."], "cta": "\u00bfYa probaste un caf\u00e9 en un jard\u00edn?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'gym',
  'Instagram Stories',
  'Rutina de ejercicios',
  'El gimnasio no tiene que ser abrumador. Con una rutina sencilla y un ambiente amable, puedes lograr tus metas sin presión. La clave es disfrutar el proceso.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 3, "raw": {"": "", "title": "Rutina de ejercicios", "story": "El gimnasio no tiene que ser abrumador. Con una rutina sencilla y un ambiente amable, puedes lograr tus metas sin presi\u00f3n. La clave es disfrutar el proceso.", "frames": ["Me levanto con energ\u00eda y preparo el equipamiento.", "Hago estiramientos y ejercicios suaves.", "Me siento orgullosa de mi progreso."], "cta": "\u00bfQuieres una rutina que te motive?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'viajes',
  'Instagram Stories',
  'Viaje corto',
  'A veces lo mejor es un viaje corto que te aleje del ruido de la ciudad. Un destino cercano puede ser suficiente para recargar tu energía y encontrar inspiración.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 4, "raw": {"category": "viajes", "title": "Viaje corto", "story": "A veces lo mejor es un viaje corto que te aleje del ruido de la ciudad. Un destino cercano puede ser suficiente para recargar tu energ\u00eda y encontrar inspiraci\u00f3n.", "frames": ["Preparo mi maleta con solo lo esencial.", "Llego a un destino tranquilo y me siento en un balc\u00f3n.", "Disfruto el paisaje sin prisas."], "cta": "\u00bfTienes un destino en mente?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'lifestyle',
  'Instagram Stories',
  'Rutina diaria',
  'La vida no es sobre ser perfecto, sino sobre encontrar equilibrio. Una rutina sencilla puede ayudarte a sentirte más presente y enfocado en lo que realmente importa.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 5, "raw": {"category": "lifestyle", "title": "Rutina diaria", "story": "La vida no es sobre ser perfecto, sino sobre encontrar equilibrio. Una rutina sencilla puede ayudarte a sentirte m\u00e1s presente y enfocado en lo que realmente importa.", "frames": ["Despierto con una luz suave y una taza de caf\u00e9.", "Hago una lista de lo que quiero lograr.", "Me siento satisfecha con lo que hago."], "cta": "\u00bfQu\u00e9 te gustar\u00eda mejorar en tu rutina?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'playa',
  'Instagram Stories',
  'Meditación en la playa',
  'La playa es un lugar ideal para la meditación. La combinación de la brisa, el sonido de las olas y la vista del mar te ayudan a conectar con tu interior.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 6, "raw": {"category": "playa", "title": "Meditaci\u00f3n en la playa", "story": "La playa es un lugar ideal para la meditaci\u00f3n. La combinaci\u00f3n de la brisa, el sonido de las olas y la vista del mar te ayudan a conectar con tu interior.", "frames": ["Me siento en la arena con la brisa fresca.", "Cierro los ojos y respiro profundamente.", "Me siento m\u00e1s tranquila y presente."], "cta": "\u00bfQuieres meditar en la playa?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'cafeteria',
  'Instagram Stories',
  'Postre de la tarde',
  'El postre es la mejor manera de terminar el día con sabor. En una cafetería con ambiente cálido, puedes disfrutar un dulce hecho con amor y una taza de café.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 7, "raw": {"category": "cafeteria", "title": "Postre de la tarde", "story": "El postre es la mejor manera de terminar el d\u00eda con sabor. En una cafeter\u00eda con ambiente c\u00e1lido, puedes disfrutar un dulce hecho con amor y una taza de caf\u00e9.", "frames": ["Paso por una cafeter\u00eda con un postre delicioso.", "Pido un postre y me siento en una mesa.", "Disfruto el momento con una sonrisa."], "cta": "\u00bfQu\u00e9 postre te gustar\u00eda probar?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'gym',
  'Instagram Stories',
  'Ejercicios en casa',
  'No siempre tienes que ir al gimnasio. Con una rutina sencilla en casa, puedes mantener tu cuerpo activo y sentirte bien. La clave es la constancia.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 8, "raw": {"category": "gym", "title": "Ejercicios en casa", "story": "No siempre tienes que ir al gimnasio. Con una rutina sencilla en casa, puedes mantener tu cuerpo activo y sentirte bien. La clave es la constancia.", "frames": ["Me levanto y preparo el espacio para ejercitar.", "Hago estiramientos y ejercicios simples.", "Me siento orgullosa de lo que hago."], "cta": "\u00bfQuieres una rutina en casa?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'viajes',
  'Instagram Stories',
  'Destino cercano',
  'Un viaje no tiene que ser muy largo para ser memorable. Un destino cercano puede ser suficiente para disfrutar de un momento de tranquilidad y conexión.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 9, "raw": {"category": "viajes", "title": "Destino cercano", "story": "Un viaje no tiene que ser muy largo para ser memorable. Un destino cercano puede ser suficiente para disfrutar de un momento de tranquilidad y conexi\u00f3n.", "frames": ["Preparo mi maleta con lo esencial.", "Llego a un lugar tranquilo y me siento en un balc\u00f3n.", "Disfruto la vista sin prisas."], "cta": "\u00bfYa tienes un destino en mente?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'lifestyle',
  'Instagram Stories',
  'Autocuidado simple',
  'El autocuidado no tiene que ser complicado. Una rutina sencilla puede ayudarte a sentirte más presente, tranquilo y feliz. La clave es disfrutar el proceso.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 10, "raw": {"category": "lifestyle", "title": "Autocuidado simple", "story": "El autocuidado no tiene que ser complicado. Una rutina sencilla puede ayudarte a sentirte m\u00e1s presente, tranquilo y feliz. La clave es disfrutar el proceso.", "frames": ["Me levanto con una luz suave y una taza de caf\u00e9.", "Hago una lista de lo que quiero lograr.", "Me siento satisfecha con lo que hago."], "cta": "\u00bfQu\u00e9 te gustar\u00eda mejorar en tu rutina?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'playa',
  'Instagram Stories',
  'Caminata al amanecer',
  'Caminar al amanecer es una forma perfecta de comenzar el día. La brisa fresca, el sonido de las olas y la vista del sol naciente son una receta para el alma.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 11, "raw": {"category": "playa", "title": "Caminata al amanecer", "story": "Caminar al amanecer es una forma perfecta de comenzar el d\u00eda. La brisa fresca, el sonido de las olas y la vista del sol naciente son una receta para el alma.", "frames": ["Me levanto antes del amanecer.", "Camino por la playa con la brisa fresca.", "Disfruto la vista del sol naciente."], "cta": "\u00bfTe gustar\u00eda comenzar el d\u00eda as\u00ed?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'cafeteria',
  'Instagram Stories',
  'Café en el jardín',
  'Las cafeterías son lugares donde el tiempo se detiene. Puedes disfrutar un café hecho con amor mientras observas a la gente pasar y a las flores moverse con la brisa.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 12, "raw": {"category": "cafeteria", "title": "Caf\u00e9 en el jard\u00edn", "story": "Las cafeter\u00edas son lugares donde el tiempo se detiene. Puedes disfrutar un caf\u00e9 hecho con amor mientras observas a la gente pasar y a las flores moverse con la brisa.", "frames": ["Paso por una cafeter\u00eda con jard\u00edn.", "Pido un caf\u00e9 y me siento en una mesa.", "Observo el entorno con una sonrisa."], "cta": "\u00bfYa probaste un caf\u00e9 en un jard\u00edn?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'gym',
  'Instagram Stories',
  'Rutina de ejercicios',
  'El gimnasio no tiene que ser abrumador. Con una rutina sencilla y un ambiente amable, puedes lograr tus metas sin presión. La clave es disfrutar el proceso.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 13, "raw": {"category": "gym", "title": "Rutina de ejercicios", "story": "El gimnasio no tiene que ser abrumador. Con una rutina sencilla y un ambiente amable, puedes lograr tus metas sin presi\u00f3n. La clave es disfrutar el proceso.", "frames": ["Me levanto con energ\u00eda y preparo el equipamiento.", "Hago estiramientos y ejercicios suaves.", "Me siento orgullosa de mi progreso."], "cta": "\u00bfQuieres una rutina que te motive?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'viajes',
  'Instagram Stories',
  'Destino tranquilo',
  'A veces lo mejor es un viaje que te aleje del ruido de la ciudad. Un destino tranquilo puede ser suficiente para recargar tu energía y encontrar inspiración.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 14, "raw": {"category": "viajes", "title": "Destino tranquilo", "story": "A veces lo mejor es un viaje que te aleje del ruido de la ciudad. Un destino tranquilo puede ser suficiente para recargar tu energ\u00eda y encontrar inspiraci\u00f3n.", "frames": ["Preparo mi maleta con solo lo esencial.", "Llego a un destino tranquilo y me siento en un balc\u00f3n.", "Disfruto el paisaje sin prisas."], "cta": "\u00bfTienes un destino en mente?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'lifestyle',
  'Instagram Stories',
  'Rutina diaria',
  'La vida no es sobre ser perfecto, sino sobre encontrar equilibrio. Una rutina sencilla puede ayudarte a sentirte más presente y enfocado en lo que realmente importa.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 15, "raw": {"category": "lifestyle", "title": "Rutina diaria", "story": "La vida no es sobre ser perfecto, sino sobre encontrar equilibrio. Una rutina sencilla puede ayudarte a sentirte m\u00e1s presente y enfocado en lo que realmente importa.", "frames": ["Despierto con una luz suave y una taza de caf\u00e9.", "Hago una lista de lo que quiero lograr.", "Me siento satisfecha con lo que hago."], "cta": "\u00bfQu\u00e9 te gustar\u00eda mejorar en tu rutina?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'playa',
  'Instagram Stories',
  'Meditación en la playa',
  'La playa es un lugar ideal para la meditación. La combinación de la brisa, el sonido de las olas y la vista del mar te ayudan a conectar con tu interior.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 16, "raw": {"category": "playa", "title": "Meditaci\u00f3n en la playa", "story": "La playa es un lugar ideal para la meditaci\u00f3n. La combinaci\u00f3n de la brisa, el sonido de las olas y la vista del mar te ayudan a conectar con tu interior.", "frames": ["Me siento en la arena con la brisa fresca.", "Cierro los ojos y respiro profundamente.", "Me siento m\u00e1s tranquila y presente."], "cta": "\u00bfQuieres meditar en la playa?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'cafeteria',
  'Instagram Stories',
  'Postre de la tarde',
  'El postre es la mejor manera de terminar el día con sabor. En una cafetería con ambiente cálido, puedes disfrutar un dulce hecho con amor y una taza de café.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 17, "raw": {"category": "cafeteria", "title": "Postre de la tarde", "story": "El postre es la mejor manera de terminar el d\u00eda con sabor. En una cafeter\u00eda con ambiente c\u00e1lido, puedes disfrutar un dulce hecho con amor y una taza de caf\u00e9.", "frames": ["Paso por una cafeter\u00eda con un postre delicioso.", "Pido un postre y me siento en una mesa.", "Disfruto el momento con una sonrisa."], "cta": "\u00bfQu\u00e9 postre te gustar\u00eda probar?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'gym',
  'Instagram Stories',
  'Ejercicios en casa',
  'No siempre tienes que ir al gimnasio. Con una rutina sencilla en casa, puedes mantener tu cuerpo activo y sentirte bien. La clave es la constancia.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 18, "raw": {"category": "gym", "title": "Ejercicios en casa", "story": "No siempre tienes que ir al gimnasio. Con una rutina sencilla en casa, puedes mantener tu cuerpo activo y sentirte bien. La clave es la constancia.", "frames": ["Me levanto y preparo el espacio para ejercitar.", "Hago estiramientos y ejercicios simples.", "Me siento orgullosa de lo que hago."], "cta": "\u00bfQuieres una rutina en casa?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'viajes',
  'Instagram Stories',
  'Destino cercano',
  'Un viaje no tiene que ser muy largo para ser memorable. Un destino cercano puede ser suficiente para disfrutar de un momento de tranquilidad y conexión.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 19, "raw": {"category": "viajes", "title": "Destino cercano", "story": "Un viaje no tiene que ser muy largo para ser memorable. Un destino cercano puede ser suficiente para disfrutar de un momento de tranquilidad y conexi\u00f3n.", "frames": ["Preparo mi maleta con lo esencial.", "Llego a un lugar tranquilo y me siento en un balc\u00f3n.", "Disfruto la vista sin prisas."], "cta": "\u00bfYa tienes un destino en mente?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);

INSERT INTO content_items (run_id, character_slug, content_type, category, platform, title, body, source_model, prompt, metadata, status)
VALUES (
  '67db7070-542e-4373-a65e-dba7fba128fd'::uuid,
  'valentina-sol',
  'story',
  'lifestyle',
  'Instagram Stories',
  'Autocuidado simple',
  'El autocuidado no tiene que ser complicado. Una rutina sencilla puede ayudarte a sentirte más presente, tranquilo y feliz. La clave es disfrutar el proceso.',
  'qwen3:8b',
  'Devuelve exclusivamente JSON valido con esta forma:
{
  "items": [
    {
      "category": "playa|cafeteria|gym|viajes|lifestyle"
    }
  ]
}

Cantidad exacta: 20 items.
Personaje: Valentina Sol.
Categorias permitidas: playa, cafeteria, gym, viajes, lifestyle.
Instruccion: Genera historias cortas para stories. Cada item debe tener: title, category, story, frames, cta. Frames debe ser un arreglo de 3 textos breves.

Reglas:
- No uses emojis.
- No menciones que eres IA salvo que sea parte natural del concepto.
- No uses marcas registradas.
- No uses texto sexual, medico o financiero.
- Escribe en espanol latino neutro.
- El contenido debe poder usarse por una influencer virtual de lifestyle.
- Devuelve solo JSON. No expliques nada.',
  '{"ordinal": 20, "raw": {"category": "lifestyle", "title": "Autocuidado simple", "story": "El autocuidado no tiene que ser complicado. Una rutina sencilla puede ayudarte a sentirte m\u00e1s presente, tranquilo y feliz. La clave es disfrutar el proceso.", "frames": ["Me levanto con una luz suave y una taza de caf\u00e9.", "Hago una lista de lo que quiero lograr.", "Me siento satisfecha con lo que hago."], "cta": "\u00bfQu\u00e9 te gustar\u00eda mejorar en tu rutina?"}, "prompt_type": "story"}'::jsonb,
  'draft'
);
