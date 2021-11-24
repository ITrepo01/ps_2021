#=================================================================================
#
#   PSPromptHere.ps1  -  Add "PowerShell Prompt Here" to Explorer Context Menu
#
#      This script adds entries to the Registry so that a "PowerShell Prompt Here"
#      item is displayed for drives or folders on the Windows Explorer right-click
#      context menu 
#
#      This script requires administrative privileges because it modifies the
#      system-wide Registry tree.  You can change "HKLM:" to "HKCU:" so that it
#      only modifies the Registry tree for the current user, which does not need
#      admin privileges.
#
#=================================================================================

# This is the command to run PowerShell and set the default folder to the one passed:
# ----------------------------------------------------------------------------------
    $PSCommand = "`"C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe`" -Noexit -Command `"& { Set-Location '%L'; [IO.Directory]::SetCurrentDirectory('%L') }`""


# Configure the context menu for folders:
# --------------------------------------

    if ( -not (test-path "HKLM:\Software\Classes\Folder\Shell\PSPromptHere") )
    {
        new-item "HKLM:\Software\Classes\Folder\Shell\PSPromptHere" | Out-Null
        new-item "HKLM:\Software\Classes\Folder\Shell\PSPromptHere\Command" | Out-Null
    }
    new-itemproperty "HKLM:\Software\Classes\Folder\Shell\PSPromptHere" `
                     -name '(Default)'  -value  "PowerShell Prompt Here" | Out-Null
    new-itemproperty "HKLM:\Software\Classes\Folder\Shell\PSPromptHere\Command" `
                     -name '(Default)'  -value  $PSCommand | Out-Null


# Configure the context menu for drives:
# -------------------------------------

    if ( -not (test-path "HKLM:\Software\Classes\Drive\Shell\PSPromptHere") )
    {
        new-item "HKLM:\Software\Classes\Drive\Shell\PSPromptHere" | Out-Null
        new-item "HKLM:\Software\Classes\Drive\Shell\PSPromptHere\Command" | Out-Null
    }

    new-itemproperty "HKLM:\Software\Classes\Drive\Shell\PSPromptHere" `
                     -name '(Default)'  -value  "PowerShell Prompt Here" | Out-Null

    new-itemproperty "HKLM:\Software\Classes\Drive\Shell\PSPromptHere\Command" `
                     -name '(Default)'  -value  $PSCommand | Out-Null

    exit 0
