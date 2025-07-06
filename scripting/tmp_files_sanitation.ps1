#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Monitors disk space and cleans up old temp files if space is low.
.DESCRIPTION
    This script checks the percentage of free space on the C: drive.
    If it is below the defined threshold, it deletes files in the user's
    temp directory that haven't been modified in the last 7 days.
#>

# --- Configuration ---
$driveLetter = "C"
$thresholdPercentage = 15
$cleanupPath = "$env:USERPROFILE\AppData\Local\Temp"
$cleanupDays = 7

# --- Logic ---
Write-Host "Starting disk space check for drive $driveLetter..." -ForegroundColor Cyan

# Get volume information as an object
$volume = Get-Volume -DriveLetter $driveLetter

# Calculate the percentage of free space
$percentFree = [math]::Round(($volume.SizeRemaining / $volume.Size) * 100, 2)

# Check if the free space is below the threshold
if ($percentFree -lt $thresholdPercentage) {
    Write-Host "WARNING: Drive $driveLetter is low on space ($percentFree% free)." -ForegroundColor Yellow
    Write-Host "Threshold is $thresholdPercentage%. Starting cleanup of files older than $cleanupDays days in '$cleanupPath'."

    # Get files older than the specified number of days
    $oldFiles = Get-ChildItem -Path $cleanupPath -Recurse -Force | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$cleanupDays) }

    if ($oldFiles) {
        # Clean up the files and log the action
        $totalSize = ($oldFiles | Measure-Object -Property Length -Sum).Sum
        $sizeInMB = [math]::Round($totalSize / 1MB, 2)

        Write-Host "Found $($oldFiles.Count) old files, totaling $sizeInMB MB. Deleting..." -ForegroundColor Yellow

        # The -WhatIf switch simulates the deletion. Remove it to perform the actual deletion.
        $oldFiles | Remove-Item -Force -Recurse -WhatIf

        Write-Host "Cleanup simulation complete. Re-run without '-WhatIf' on the Remove-Item command to perform the action." -ForegroundColor Green
        # Add-Content -Path "C:\Logs\cleanup.log" -Value "($(Get-Date)) - Low disk space triggered. Cleaned up $sizeInMB MB of temp files."
    } else {
        Write-Host "Low disk space detected, but no old files found to clean up in '$cleanupPath'." -ForegroundColor Red
    }

} else {
    Write-Host "OK: Drive $driveLetter space is healthy ($percentFree% free)." -ForegroundColor Green
}
