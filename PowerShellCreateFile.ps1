$filePath = "$([Environment]::GetFolderPath('Desktop'))\example.txt"
$content = "This is an example string."

Set-Content -Path $filePath -Value $content

Write-Host "File created at $filePath with the content:`n$content"
