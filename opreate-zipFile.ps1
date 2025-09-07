# compress or uncompress zip file
$sourceFolder = "$env:userprofile\desltop\test"
$zipFile = "$env:userprofile\desltop\test\test.zip"


# only work for powershell v5.1 and above
# compress to zip file
Compress-Archive -Path "$sourceFolder" -DestinationPath "$zipFile" # compress include root folder
Compress-Archive -Path "$sourceFolder\*" -DestinationPath "$zipFile" # compress exclude root folder
Compress-Archive -Path "$sourceFolder\*.*" -DestinationPath "$zipFile" # compress only file

Compress-Archive -Path "$sourceFolder\MyFile.docx", "$sourceFolder\*.jpg" -DestinationPath "$zipFile" # mulitiple files
Compress-Archive -LiteralPath "$sourceFolder\MyFile.docx", "$sourceFolder\MyImg.jpg" -DestinationPath "$zipFile" # no use *

Compress-Archive -Path "$sourceFolder" -DestinationPath "$zipFile" -Force  # override zip file

Compress-Archive -Path "$sourceFolder" -DestinationPath "$zipFile" -CompressionLevel Fastest   # config compress level
# Fastest - fastest ways, genereate bigger zip file
# NoCompression - no compress
# Optimal - default

Compress-Archive -Path "$sourceFolder\*.txt" -Update -DestinationPath "$zipFile" # update and compress txt file

# uncompress zip file, auto create folder if not exist
Expand-Archive -Path "$zipFile" -DestinationPath "$sourceFolder" # -LiteralPath, -Force


# -----------------------------------------------------------------------------------------

# compatible with under powershell v5
# compress file
Add-Type -AssemblyName System.IO.Compression
$CompressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
$BaseDirectory = $false  # false for exclude root folder, true for include. optional
[System.IO.Compression.ZipFile]::CreateFromDirectory("$sourceFolder", "$zipFile", $CompressionLevel, $BaseDirectory)

# extraction
Add-Type -AssemblyName System.IO.Compression
[System.IO.Compression.ZipFile]::ExtractToDirectory("$zipFile", "$sourceFolder")