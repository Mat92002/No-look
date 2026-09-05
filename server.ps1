param([int]$Port = 4173)

$root = [IO.Path]::GetFullPath($PSScriptRoot)
$listener = [Net.HttpListener]::new()
$listener.Prefixes.Add("http://127.0.0.1:$Port/")
$listener.Start()
Write-Host "NO LOOK disponible sur http://localhost:$Port"

$contentTypes = @{
  '.css' = 'text/css; charset=utf-8'
  '.glb' = 'model/gltf-binary'
  '.html' = 'text/html; charset=utf-8'
  '.js' = 'text/javascript; charset=utf-8'
  '.json' = 'application/json; charset=utf-8'
  '.png' = 'image/png'
}

try {
  while ($listener.IsListening) {
    $context = $listener.GetContext()
    try {
      $relativePath = [Uri]::UnescapeDataString($context.Request.Url.AbsolutePath.TrimStart('/'))
      if ([string]::IsNullOrWhiteSpace($relativePath)) { $relativePath = 'index.html' }
      $filePath = [IO.Path]::GetFullPath((Join-Path $root $relativePath))
      if (-not $filePath.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        throw [IO.FileNotFoundException]::new()
      }
      $extension = [IO.Path]::GetExtension($filePath).ToLowerInvariant()
      $context.Response.StatusCode = 200
      $context.Response.ContentType = if ($contentTypes.ContainsKey($extension)) { $contentTypes[$extension] } else { 'application/octet-stream' }
      $context.Response.Headers.Add('Cache-Control', 'no-store')
      $bytes = [IO.File]::ReadAllBytes($filePath)
      $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } catch {
      $context.Response.StatusCode = 404
      $bytes = [Text.Encoding]::UTF8.GetBytes('Fichier introuvable')
      $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } finally {
      $context.Response.Close()
    }
  }
} finally {
  $listener.Close()
}
