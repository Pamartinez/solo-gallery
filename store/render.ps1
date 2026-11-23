# Renders the Play Store PNGs with headless Edge. Run from anywhere: ./store/render.ps1
$ErrorActionPreference = "Stop"
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$dir = $PSScriptRoot
$base = "file:///" + ($dir -replace '\\', '/')

$shots = @(
  @{ out = "photos/01-only-photos.png";  app = "photos"; h = "Only your photos";       p = "A fast gallery with no videos in the way";            img = "mock-photos.svg" }
  @{ out = "photos/02-groups.png";       app = "photos"; h = "Group your albums";      p = "Gather albums into groups and sort them your way";    img = "mock-photos.svg" }
  @{ out = "photos/03-settings.png";     app = "photos"; h = "Make it yours";          p = "Floating top bar, drag to reorder, per-album sort";   img = "mock-photos-settings.svg" }
  @{ out = "photos/04-private.png";      app = "photos"; h = "Private by design";      p = "Your photos never leave your phone";                  privacy = "1" }
  @{ out = "videos/01-only-videos.png";  app = "videos"; h = "Only your videos";       p = "A gallery made just for the videos on your phone";    img = "mock-videos.svg" }
  @{ out = "videos/02-groups.png";       app = "videos"; h = "Group your albums";      p = "Gather albums into groups and sort them your way";    img = "mock-videos.svg" }
  @{ out = "videos/03-settings.png";     app = "videos"; h = "Make it yours";          p = "Background previews, floating top bar, custom order"; img = "mock-videos-settings.svg" }
  @{ out = "videos/04-private.png";      app = "videos"; h = "Private by design";      p = "Your videos never leave your phone";                  privacy = "1" }
)
$features = @(
  @{ out = "photos/feature-graphic.png"; app = "photos"; h = "Solo Photos"; p = "Just your photos. Private and offline." }
  @{ out = "videos/feature-graphic.png"; app = "videos"; h = "Solo Videos"; p = "Just your videos. Private and offline." }
)

function Invoke-Render($page, $item, $w, $h) {
  $query = ($item.GetEnumerator() | Where-Object Key -ne "out" | ForEach-Object { "$($_.Key)=$([uri]::EscapeDataString($_.Value))" }) -join "&"
  $outPath = Join-Path $dir ("out/" + $item.out)
  New-Item -ItemType Directory -Force (Split-Path $outPath) | Out-Null
  # A fresh profile per run stops Edge from handing off to an already-running instance and hanging.
  $profile = Join-Path $env:TEMP ("solo-render-" + [guid]::NewGuid())
  $args = @("--headless=new", "--disable-gpu", "--hide-scrollbars", "--force-device-scale-factor=1",
    "--allow-file-access-from-files", "--user-data-dir=`"$profile`"", "--window-size=$w,$h",
    "--virtual-time-budget=3000", "--screenshot=`"$outPath`"", "`"$base/$page`?$query`"")
  $proc = Start-Process $edge -ArgumentList $args -PassThru -WindowStyle Hidden
  if (-not $proc.WaitForExit(40000)) { $proc.Kill($true); Write-Warning "timed out: $($item.out)" }
  Remove-Item $profile -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host "rendered $($item.out)"
}

$shots | ForEach-Object { Invoke-Render "shot.html" $_ 1080 1920 }
$features | ForEach-Object { Invoke-Render "feature.html" $_ 1024 500 }
