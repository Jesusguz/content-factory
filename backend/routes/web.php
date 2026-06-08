<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Str;
use Symfony\Component\Process\Process;

Route::get('/', function () {
    $root = base_path('..');
    $activeCharacter = 'elena-voss';

    $contentCounts = DB::table('content_items')
        ->select('content_type', DB::raw('count(*) as total'))
        ->where('character_slug', $activeCharacter)
        ->groupBy('content_type')
        ->orderBy('content_type')
        ->get();

    $latestContent = DB::table('content_items')
        ->select('content_type', 'category', 'platform', 'title', 'body', 'status', 'created_at')
        ->where('character_slug', $activeCharacter)
        ->orderByDesc('created_at')
        ->limit(10)
        ->get();

    $publicationQueue = DB::table('publication_queue')
        ->select('platform', 'media_path', 'caption', 'scheduled_for', 'status')
        ->where('character_slug', $activeCharacter)
        ->orderBy('scheduled_for')
        ->limit(12)
        ->get();

    $characters = DB::table('characters')
        ->select('slug', 'display_name', 'profile', 'updated_at')
        ->where('slug', $activeCharacter)
        ->get()
        ->map(function ($character) {
            $character->profile = json_decode($character->profile, true) ?: [];
            return $character;
        });

    $latestConsistency = DB::table('consistency_batches')
        ->where('character_slug', $activeCharacter)
        ->orderByDesc('created_at')
        ->first();

    if ($latestConsistency) {
        $latestConsistency->rejection_reasons = json_decode($latestConsistency->rejection_reasons, true) ?: [];
        $latestConsistency->metrics = json_decode($latestConsistency->metrics, true) ?: [];
    }

    $consistencyItems = collect();
    if ($latestConsistency) {
        $consistencyItems = DB::table('consistency_items')
            ->where('batch_id', $latestConsistency->id)
            ->orderBy('created_at')
            ->limit(12)
            ->get()
            ->map(function ($item) {
                $item->metrics = json_decode($item->metrics, true) ?: [];
                return $item;
            });
    }

    $generatedElenaImages = collect(File::glob($root . '/output/images/dataset/elena_voss/*/*.png'))
        ->sortByDesc(fn ($path) => File::lastModified($path))
        ->map(function ($path) {
            return [
                'kind' => 'generated',
                'category' => basename(dirname($path)),
                'filename' => basename($path),
                'size_kb' => round(File::size($path) / 1024, 1),
                'updated_at' => date('Y-m-d H:i', File::lastModified($path)),
            ];
        });

    $loraDatasetImages = collect(File::glob($root . '/dataset_lora/images/*.png'))
        ->sortBy(fn ($path) => basename($path))
        ->map(function ($path) {
            return [
                'kind' => 'lora',
                'category' => 'dataset_lora',
                'filename' => basename($path),
                'size_kb' => round(File::size($path) / 1024, 1),
                'updated_at' => date('Y-m-d H:i', File::lastModified($path)),
            ];
        });

    $images = $generatedElenaImages->concat($loraDatasetImages)->take(18)->values();

    $videos = collect(File::glob($root . '/output/videos/elena_voss*.mp4'))
        ->sortByDesc(fn ($path) => File::lastModified($path))
        ->map(function ($path) {
            return [
                'filename' => basename($path),
                'size_kb' => round(File::size($path) / 1024, 1),
                'updated_at' => date('Y-m-d H:i', File::lastModified($path)),
            ];
        })
        ->values();

    $workflows = collect(File::glob($root . '/workflows/*.json'))
        ->map(function ($path) {
            $json = json_decode(File::get($path), true) ?: [];
            return [
                'name' => $json['name'] ?? basename($path),
                'nodes' => count($json['nodes'] ?? []),
                'filename' => basename($path),
            ];
        })
        ->values();

    $prompts = collect([
        'Sistema editorial' => $root . '/prompts/elena-voss-llm-system.md',
        'Imagen positivo' => $root . '/prompts/elena-voss-image-positive.txt',
        'Imagen negativo' => $root . '/prompts/elena-voss-image-negative.txt',
    ])->map(function ($path, $label) {
        return [
            'label' => $label,
            'text' => File::exists($path) ? Str::limit(File::get($path), 420) : 'No disponible',
        ];
    })->values();

    $generateTodayPath = $root . '/docs/generate-today-result.json';
    $generateTodayResult = File::exists($generateTodayPath)
        ? json_decode(File::get($generateTodayPath), true)
        : null;

    $loraPath = $root . '/models/loras/elena_voss_v1.safetensors';
    $loraPresent = File::exists($loraPath);

    $stats = [
        'content_total' => DB::table('content_items')->where('character_slug', $activeCharacter)->count(),
        'images_total' => $generatedElenaImages->count(),
        'lora_dataset_total' => $loraDatasetImages->count(),
        'videos_total' => $videos->count(),
        'scheduled_total' => DB::table('publication_queue')->where('character_slug', $activeCharacter)->count(),
        'workflows_total' => $workflows->count(),
    ];

    return view('dashboard', compact(
        'characters',
        'consistencyItems',
        'contentCounts',
        'generateTodayResult',
        'images',
        'latestConsistency',
        'latestContent',
        'loraPresent',
        'prompts',
        'publicationQueue',
        'stats',
        'videos',
        'workflows'
    ));
});

Route::post('/actions/generate-today', function () {
    set_time_limit(0);

    $root = base_path('..');
    $script = $root . '/scripts/generate_today.ps1';
    abort_unless(File::exists($script), 500, 'generate_today.ps1 not found');

    $process = new Process([
        'pwsh',
        '-NoProfile',
        '-ExecutionPolicy',
        'Bypass',
        '-File',
        $script,
    ], $root, null, null, 3600);
    $process->run();

    return redirect('/')
        ->with('action_status', $process->isSuccessful() ? 'completed' : 'failed')
        ->with('action_output', Str::limit($process->getOutput() . $process->getErrorOutput(), 1200));
})->name('actions.generateToday');

Route::get('/media/images/{category}/{filename}', function (string $category, string $filename) {
    abort_unless(preg_match('/^[a-z_]+$/', $category), 404);
    abort_unless(preg_match('/^[a-zA-Z0-9_.-]+$/', $filename), 404);

    $path = base_path("../output/images/dataset/elena_voss/{$category}/{$filename}");
    abort_unless(File::exists($path), 404);

    return response()->file($path);
})->name('media.image');

Route::get('/media/lora/{filename}', function (string $filename) {
    abort_unless(preg_match('/^[a-zA-Z0-9_.-]+$/', $filename), 404);

    $path = base_path("../dataset_lora/images/{$filename}");
    abort_unless(File::exists($path), 404);

    return response()->file($path);
})->name('media.lora');

Route::get('/media/videos/{filename}', function (string $filename) {
    abort_unless(preg_match('/^[a-zA-Z0-9_.-]+$/', $filename), 404);

    $path = base_path("../output/videos/{$filename}");
    abort_unless(File::exists($path), 404);

    return response()->file($path);
})->name('media.video');
