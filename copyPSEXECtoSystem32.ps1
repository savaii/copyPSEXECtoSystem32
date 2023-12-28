# Check if the script is running with administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # Relaunch the script with administrative privileges
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Specify the source directory where PSExec is located on the network
$sourceDirectory = "\\server\share\path\to\PSExec"

# Specify the destination directory (C:\Windows\System32)
$destinationDirectory = "C:\Windows\System32"

# Specify the PSExec executable name
$psexecExecutable = "PsExec.exe"

# Build the full source and destination paths
$sourcePath = Join-Path -Path $sourceDirectory -ChildPath $psexecExecutable
$destinationPath = Join-Path -Path $destinationDirectory -ChildPath $psexecExecutable

try {
    # Check if the source file exists
    if (Test-Path $sourcePath) {
        # Copy the file to the destination
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force
        Write-Host "PSExec copied to $destinationPath"
    } else {
        throw "PSExec not found in the specified source directory on the network."
    }
} catch {
    Write-Host "Error: $_"
}

# Pause to keep the console open
Read-Host "Press Enter to exit"
