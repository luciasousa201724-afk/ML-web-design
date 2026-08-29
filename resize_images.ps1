Add-Type -AssemblyName System.Drawing
$srcPath = "c:\Users\Dell\Desktop\site-psicologa-rebeka\dist\assets\img\favicon2.png"

if (Test-Path $srcPath) {
    Write-Host "Source image found. Starting resize..."
    $img = [System.Drawing.Image]::FromFile($srcPath)

    $sizes = @(
        @{ Path = "c:\Users\Dell\Desktop\site-psicologa-rebeka\dist\assets\img\favicon-16x16.png"; Width = 16; Height = 16 },
        @{ Path = "c:\Users\Dell\Desktop\site-psicologa-rebeka\dist\assets\img\favicon-32x32.png"; Width = 32; Height = 32 },
        @{ Path = "c:\Users\Dell\Desktop\site-psicologa-rebeka\dist\assets\img\apple-touch-icon.png"; Width = 180; Height = 180 }
    )

    foreach ($size in $sizes) {
        $bmp = New-Object System.Drawing.Bitmap($size.Width, $size.Height)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.DrawImage($img, 0, 0, $size.Width, $size.Height)
        $g.Dispose()
        
        # If target file exists, delete it first to avoid locks
        if (Test-Path $size.Path) {
            Remove-Item $size.Path -Force
        }
        
        $bmp.Save($size.Path, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        Write-Host "Created $($size.Path) ($($size.Width)x$($size.Height))"
    }
    $img.Dispose()
    Write-Host "Resizing completed successfully!"
} else {
    Write-Error "Source image favicon2.png not found at $srcPath"
}
