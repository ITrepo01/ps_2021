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
    $FileName = [io.path]::GetFileNameWithoutExtension($_.name)
    $FileType = [io.path]::GetExtension($_.name)
    $NewFileName = "Backup\$FileName" + "_" + $_.LastWriteTime.ToString("yyyy-MM-dd") + $FileType
    Copy-Item $_ $NewFileName }

Write-Host "Saved:" $BUCount "files," $BUSize.ToString("n0") "bytes"
