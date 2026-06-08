<!doctype html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Elena Voss Content Factory</title>
    <style>
        :root {
            --bg: #f5f7f8;
            --panel: #ffffff;
            --ink: #18212b;
            --muted: #66717f;
            --line: #d8dee6;
            --ok: #0f766e;
            --warn: #b45309;
            --bad: #b91c1c;
            --blue: #1d4ed8;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            background: var(--bg);
            color: var(--ink);
            font: 14px/1.45 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        }
        .shell { display: grid; grid-template-columns: 236px minmax(0, 1fr); min-height: 100vh; }
        aside { background: #101820; color: #edf2f7; padding: 22px 18px; }
        aside h1 { margin: 0 0 22px; font-size: 18px; line-height: 1.2; letter-spacing: 0; }
        nav a { display: block; color: #cbd5e1; text-decoration: none; padding: 9px 10px; border-radius: 6px; margin-bottom: 4px; }
        nav a:hover { background: #1e2a36; color: #fff; }
        main { padding: 22px; max-width: 1500px; width: 100%; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: 18px; }
        h2 { margin: 0; font-size: 22px; letter-spacing: 0; }
        h3 { margin: 0; font-size: 15px; letter-spacing: 0; }
        .muted { color: var(--muted); }
        .grid { display: grid; gap: 12px; }
        .stats { grid-template-columns: repeat(6, minmax(120px, 1fr)); margin-bottom: 18px; }
        .stat, section {
            background: var(--panel);
            border: 1px solid var(--line);
            border-radius: 8px;
        }
        .stat { padding: 13px; }
        .stat b { display: block; font-size: 25px; line-height: 1; margin-bottom: 6px; }
        section { margin-bottom: 16px; overflow: hidden; }
        section header {
            padding: 13px 15px;
            border-bottom: 1px solid var(--line);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }
        .content { padding: 15px; }
        .two-col { display: grid; grid-template-columns: minmax(0, 1.1fr) minmax(340px, .9fr); gap: 16px; }
        .score-grid { display: grid; grid-template-columns: repeat(6, minmax(110px, 1fr)); gap: 10px; }
        .score {
            border: 1px solid var(--line);
            border-radius: 8px;
            padding: 12px;
            background: #fafbfc;
        }
        .score strong { display: block; font-size: 24px; line-height: 1; margin-bottom: 7px; }
        .bar { height: 7px; border-radius: 999px; background: #e5e7eb; overflow: hidden; margin-top: 9px; }
        .bar span { display: block; height: 100%; background: var(--bad); }
        .bar span.mid { background: var(--warn); }
        .bar span.ok { background: var(--ok); }
        .pill {
            display: inline-flex;
            align-items: center;
            border-radius: 999px;
            padding: 2px 8px;
            font-size: 12px;
            white-space: nowrap;
            background: #e8f3f1;
            color: #0f4d47;
        }
        .pill.bad { background: #fee2e2; color: var(--bad); }
        .pill.warn { background: #fef3c7; color: var(--warn); }
        .pill.blue { background: #dbeafe; color: var(--blue); }
        .action-row { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        button {
            border: 0;
            border-radius: 8px;
            background: #101820;
            color: #fff;
            padding: 11px 15px;
            font-weight: 700;
            cursor: pointer;
            letter-spacing: 0;
        }
        button:hover { background: #263442; }
        .notice {
            border: 1px solid var(--line);
            border-radius: 8px;
            padding: 10px 12px;
            background: #fbfcfd;
        }
        .grid-media { display: grid; grid-template-columns: repeat(auto-fill, minmax(128px, 1fr)); gap: 12px; }
        figure { margin: 0; border: 1px solid var(--line); border-radius: 8px; overflow: hidden; background: #f9fafb; }
        figure img { display: block; width: 100%; aspect-ratio: 2 / 3; object-fit: cover; }
        figcaption { padding: 7px 8px; font-size: 12px; color: var(--muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px 9px; border-bottom: 1px solid var(--line); text-align: left; vertical-align: top; }
        th { font-size: 12px; color: var(--muted); font-weight: 700; background: #f9fafb; }
        tr:last-child td { border-bottom: 0; }
        pre {
            margin: 0;
            white-space: pre-wrap;
            word-break: break-word;
            font: 12px/1.45 ui-monospace, SFMono-Regular, Consolas, monospace;
            background: #f8fafc;
            border: 1px solid var(--line);
            border-radius: 8px;
            padding: 10px;
            min-height: 124px;
        }
        .prompt-list { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 12px; }
        video { width: 100%; max-height: 520px; background: #000; border-radius: 8px; border: 1px solid var(--line); }
        @media (max-width: 1080px) {
            .shell { grid-template-columns: 1fr; }
            .stats, .score-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .two-col { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
@php
    $scoreValue = function ($name) use ($latestConsistency) {
        return $latestConsistency ? (float) $latestConsistency->{$name} : 0;
    };
    $barClass = function ($value, $target) {
        if ($value >= $target) return 'ok';
        if ($value >= max(60, $target - 15)) return 'mid';
        return '';
    };
@endphp
<div class="shell">
    <aside>
        <h1>Elena Voss<br><span class="muted">Identity Factory</span></h1>
        <nav>
            <a href="#consistency">Consistency Score</a>
            <a href="#generate">Generacion</a>
            <a href="#media">Dataset</a>
            <a href="#calendar">Calendario</a>
            <a href="#prompts">Prompts</a>
            <a href="#characters">Personaje</a>
        </nav>
    </aside>
    <main>
        <div class="topbar">
            <div>
                <h2>Panel operativo</h2>
                <div class="muted">La metrica principal es Identity Stability Index (ISI) >= 90 durante 100 imagenes consecutivas.</div>
            </div>
            @if ($latestConsistency && $latestConsistency->gate_status === 'approved')
                <span class="pill">APROBADO</span>
            @elseif ($latestConsistency)
                <span class="pill bad">{{ strtoupper($latestConsistency->gate_status) }}</span>
            @else
                <span class="pill warn">SIN SCORE</span>
            @endif
        </div>

        <div class="stats grid" id="metrics">
            <div class="stat"><b>{{ $stats['content_total'] }}</b><span class="muted">piezas Elena</span></div>
            <div class="stat"><b>{{ $stats['images_total'] }}</b><span class="muted">imagenes nuevas</span></div>
            <div class="stat"><b>{{ $stats['lora_dataset_total'] }}</b><span class="muted">dataset LoRA</span></div>
            <div class="stat"><b>{{ $stats['videos_total'] }}</b><span class="muted">videos Elena</span></div>
            <div class="stat"><b>{{ $stats['scheduled_total'] }}</b><span class="muted">programadas</span></div>
            <div class="stat"><b>{{ $latestConsistency ? number_format($latestConsistency->isi_score, 1) : '0.0' }}</b><span class="muted">Identity Stability Index (ISI)</span></div>
        </div>

        <section id="consistency">
            <header>
                <h3>Consistency Score</h3>
                <span class="pill {{ $loraPresent ? '' : 'bad' }}">LoRA {{ $loraPresent ? 'lista' : 'faltante' }}</span>
            </header>
            <div class="content">
                <div class="score-grid">
                    @foreach ([
                        ['Face', 'face_score', 90],
                        ['Body', 'body_score', 90],
                        ['Style', 'style_score', 85],
                        ['Narrative', 'narrative_score', 85],
                        ['Global', 'global_score', 90],
                        ['ISI', 'isi_score', 90],
                    ] as [$label, $field, $target])
                        @php $value = $scoreValue($field); @endphp
                        <div class="score">
                            <strong>{{ number_format($value, 1) }}</strong>
                            <span class="muted">{{ $label }} >= {{ $target }}</span>
                            <div class="bar"><span class="{{ $barClass($value, $target) }}" style="width: {{ min(100, max(0, $value)) }}%"></span></div>
                        </div>
                    @endforeach
                </div>
                @if ($latestConsistency && count($latestConsistency->rejection_reasons))
                    <div class="notice" style="margin-top: 12px;">
                        <strong>Bloqueos:</strong>
                        {{ implode(' | ', $latestConsistency->rejection_reasons) }}
                    </div>
                @endif
            </div>
        </section>

        <section id="generate">
            <header>
                <h3>Generacion diaria</h3>
                <span class="muted">quality gate obligatorio</span>
            </header>
            <div class="content">
                <div class="action-row">
                    <form method="post" action="{{ route('actions.generateToday') }}">
                        @csrf
                        <button type="submit">GENERAR CONTENIDO DE HOY</button>
                    </form>
                    @if (session('action_status'))
                        <span class="pill blue">{{ session('action_status') }}</span>
                    @endif
                    @if ($generateTodayResult)
                        <span class="pill {{ ($generateTodayResult['approved'] ?? false) ? '' : 'bad' }}">{{ $generateTodayResult['status'] ?? 'unknown' }}</span>
                        <span class="muted">{{ $generateTodayResult['generated_at'] ?? '' }}</span>
                    @endif
                </div>
                @if (session('action_output'))
                    <pre style="margin-top: 12px;">{{ session('action_output') }}</pre>
                @elseif ($generateTodayResult)
                    <pre style="margin-top: 12px;">{{ json_encode($generateTodayResult, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) }}</pre>
                @endif
            </div>
        </section>

        <div class="two-col">
            <section id="media">
                <header>
                    <h3>Dataset visual</h3>
                    <span class="muted">{{ $images->count() }} visibles</span>
                </header>
                <div class="content">
                    <div class="grid-media">
                        @foreach ($images as $image)
                            <figure>
                                @if ($image['kind'] === 'lora')
                                    <img src="{{ route('media.lora', $image['filename']) }}" alt="{{ $image['filename'] }}">
                                @else
                                    <img src="{{ route('media.image', [$image['category'], $image['filename']]) }}" alt="{{ $image['filename'] }}">
                                @endif
                                <figcaption>{{ $image['category'] }} · {{ $image['size_kb'] }} KB</figcaption>
                            </figure>
                        @endforeach
                    </div>
                </div>
            </section>

            <section>
                <header>
                    <h3>Video Elena</h3>
                    <span class="muted">{{ $videos->first()['size_kb'] ?? 0 }} KB</span>
                </header>
                <div class="content">
                    @if ($videos->isNotEmpty())
                        <video controls src="{{ route('media.video', $videos->first()['filename']) }}"></video>
                        <p class="muted">{{ $videos->first()['filename'] }} · {{ $videos->first()['updated_at'] }}</p>
                    @else
                        <p class="muted">BLOQUEADO HASTA ISI >= 90</p>
                    @endif
                </div>
            </section>
        </div>

        <section>
            <header>
                <h3>Imagenes auditadas</h3>
                <span class="muted">ultimo lote</span>
            </header>
            <div class="content">
                <table>
                    <thead><tr><th>Imagen</th><th>Face</th><th>Body</th><th>Style</th><th>Narrative</th><th>Global</th><th>Estado</th></tr></thead>
                    <tbody>
                    @foreach ($consistencyItems as $item)
                        <tr>
                            <td><code>{{ $item->image_path }}</code></td>
                            <td>{{ $item->face_score }}</td>
                            <td>{{ $item->body_score }}</td>
                            <td>{{ $item->style_score }}</td>
                            <td>{{ $item->narrative_score }}</td>
                            <td>{{ $item->global_score }}</td>
                            <td><span class="pill {{ $item->approved ? '' : 'bad' }}">{{ $item->approved ? 'approved' : 'rejected' }}</span></td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
            </div>
        </section>

        <section id="calendar">
            <header>
                <h3>Calendario</h3>
                <span class="muted">solo contenido aprobado</span>
            </header>
            <div class="content">
                <table>
                    <thead><tr><th>Fecha</th><th>Plataforma</th><th>Estado</th><th>Caption</th><th>Media</th></tr></thead>
                    <tbody>
                    @foreach ($publicationQueue as $item)
                        <tr>
                            <td>{{ $item->scheduled_for }}</td>
                            <td><span class="pill blue">{{ $item->platform }}</span></td>
                            <td><span class="pill">{{ $item->status }}</span></td>
                            <td>{{ Str::limit($item->caption, 130) }}</td>
                            <td><code>{{ $item->media_path }}</code></td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
            </div>
        </section>

        <section>
            <header>
                <h3>Contenido reciente</h3>
                <span class="muted">Elena Voss</span>
            </header>
            <div class="content">
                <table>
                    <thead><tr><th>Tipo</th><th>Categoria</th><th>Plataforma</th><th>Titulo</th><th>Texto</th></tr></thead>
                    <tbody>
                    @foreach ($latestContent as $item)
                        <tr>
                            <td><span class="pill warn">{{ $item->content_type }}</span></td>
                            <td>{{ $item->category }}</td>
                            <td>{{ $item->platform }}</td>
                            <td>{{ $item->title }}</td>
                            <td>{{ Str::limit($item->body, 180) }}</td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
            </div>
        </section>

        <section id="prompts">
            <header>
                <h3>Prompts</h3>
                <span class="muted">canon Elena</span>
            </header>
            <div class="content prompt-list">
                @foreach ($prompts as $prompt)
                    <div>
                        <p><strong>{{ $prompt['label'] }}</strong></p>
                        <pre>{{ $prompt['text'] }}</pre>
                    </div>
                @endforeach
            </div>
        </section>

        <section id="characters">
            <header>
                <h3>Personaje</h3>
                <span class="muted">identidad activa</span>
            </header>
            <div class="content">
                <table>
                    <thead><tr><th>Slug</th><th>Nombre</th><th>Nicho</th><th>Pilares</th><th>Actualizado</th></tr></thead>
                    <tbody>
                    @foreach ($characters as $character)
                        <tr>
                            <td>{{ $character->slug }}</td>
                            <td>{{ $character->display_name }}</td>
                            <td>{{ $character->profile['niche'] ?? 'n/a' }}</td>
                            <td>{{ implode(', ', $character->profile['pillars'] ?? []) }}</td>
                            <td>{{ $character->updated_at }}</td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
            </div>
        </section>

        <section>
            <header>
                <h3>Workflows</h3>
                <span class="muted">n8n</span>
            </header>
            <div class="content">
                <table>
                    <thead><tr><th>Nombre</th><th>Nodos</th><th>Archivo</th></tr></thead>
                    <tbody>
                    @foreach ($workflows as $workflow)
                        <tr>
                            <td>{{ $workflow['name'] }}</td>
                            <td>{{ $workflow['nodes'] }}</td>
                            <td><code>{{ $workflow['filename'] }}</code></td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
