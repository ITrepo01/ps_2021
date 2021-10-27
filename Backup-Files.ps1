Write-Host "Saving the following files" `
            "to the `"Backup`" folder:"
$BUCount = 0
$BUSize  = 0

Get-ChildItem -File | where {
    $_.LastWriteTime -ge "2018-01-01" } | 
ForEach-Object {
    Write-Host " Backup\$($_.Name)"
    $BUSize += $_.Length 
    $BUCount++
    $NewFileName = "Backup\" + $_.Name + "_" + `
        $_.LastWriteTime.ToString("yyyy-MM-dd")
    Copy-Item $_ $NewFileName }

Write-Host "Saved:" $BUCount "files," $BUSize.ToString("n0") "bytes"
