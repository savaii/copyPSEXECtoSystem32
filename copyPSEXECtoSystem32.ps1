# Check if the script is running with administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # Relaunch the script with administrative privileges
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Specify the source directory where files are located on the network
$sourceDirectory = "\\server\share\path\to\Files"

# Specify the destination directory (C:\Windows\System32)
$destinationDirectory = "C:\Windows\System32"

try {
    # Check if the source directory exists
    if (Test-Path $sourceDirectory -PathType Container) {
        # Get all files in the source directory
        $files = Get-ChildItem -Path $sourceDirectory

        # Copy each file to the destination directory
        foreach ($file in $files) {
            $destinationPath = Join-Path -Path $destinationDirectory -ChildPath $file.Name
            Copy-Item -Path $file.FullName -Destination $destinationPath -Force
            Write-Host "File $($file.Name) copied to $destinationPath"
        }
    } else {
        throw "Source directory does not exist on the network."
    }
} catch {
    Write-Host "Error: $_"
}

# Pause to keep the console open
Read-Host "Press Enter to exit"
