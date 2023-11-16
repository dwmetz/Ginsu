<# 
.NOTES
    File Name: Ginsu.ps1
    Author: Doug Metz
    Prerequisities: 7za.exe executable 'put' via Defender console
    Version: 1.0
.SYNOPSIS
    Compresses a folder using 7zip and splits the resulting archives into 3GB or less sections.
.DESCRIPTION
    This script uses 7zip (7za.exe) to compress a specified folder and then splits the resulting archive into sections of 3GB or less. 
    It will work (and was designed for) files larger than 3GB.  Windows Defender Live Response currently only supports pulling back files 
    of 3GB or less via the console. If your collection is larger than that, you will need to repackage it using Ginsu, or use a method 
    outside of the console to retrieve the files.
#>
# Directory to be Zipped
$source = "C:\Temp\RESPONSE"
# FileName for the output (no extension)
$baseName = "RESPONSE"
# Folder path for the 7z executable
$7zipPath = "C:\temp\Microsoft\Windows Defender Advanced Threat Protection\Downloads"
# NOTE: In production this should be 'C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads'
# Only Defender can write to that folder with the 'put' operation. Using C:\temp\Microsoft... as a placeholder.
if (-not (Test-Path $7zipPath)) {
    Write-Host "7zip path does not exist"
    exit
}
# Create output directory if it doesn't exist
Write-host -fore Yellow "
 ██████╗ ██╗███╗   ██╗███████╗██╗   ██╗
██╔════╝ ██║████╗  ██║██╔════╝██║   ██║
██║  ███╗██║██╔██╗ ██║███████╗██║   ██║
██║   ██║██║██║╚██╗██║╚════██║██║   ██║
╚██████╔╝██║██║ ╚████║███████║╚██████╔╝
 ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ 
                                       
"
Write-host "    https://github.com/dwmetz/Ginsu
"
Write-host -fore Yellow "[Chopping $source]"
$outputDirectory = "C:\Temp\RESPONSE\Ginsu"
if (-not (Test-Path $outputDirectory)) {
    $null = New-Item -ItemType Directory -Force -Path $outputDirectory
}
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
# Run 7zip on the collection directory and create (zips) in Output Directory
Set-Location $7zipPath
.\7za.exe a -t7z -v3g $outputDirectory\$baseName.7z $source -x!$outputDirectory\*
Write-host -fore Green "
[Chop Complete]
"
$null = $stopwatch.Elapsed
$Minutes = $StopWatch.Elapsed.Minutes
$Seconds = $StopWatch.Elapsed.Seconds
Write-Host -Fore Blue "** Archives completed in $Minutes minutes and $Seconds seconds.**
"
Set-Location $outputDirectory
Get-ChildItem
