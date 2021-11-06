#==========================================================================
#
#    Show-FilesByDOW.ps1  -  Show files created on a given day of the week
#
#   This script shows all of the files in a given folder that were created
#   on a specified day of the week.  It accepts two command line parameters:
#
#		- a folder name
#		- a day of week (i.e., "Monday")
#
#	If any parameters are invalid then an error is displayed and the script
#	exits with a nonzero exit status
#
#==========================================================================

# Ensure we have two parameters:
# -----------------------------
    if ( $args.count -ne 2 )
	{
	    write-host -foregroundcolor red "`a`nThis script must have two parameters:"
		write-host -foregroundcolor red "`n  - a folder name"
		write-host -foregroundcolor red "  - a day of week (i.e., `"Monday`")"
		exit 1
	}

# Get the two command line parameters:
# -----------------------------------
    $FolderName = $args[0]
	$DayOfWeek = $args[1]
	
# Validate the folder name:
# ------------------------
    if ( -not (test-path $FolderName -pathtype container) )
    {
        write-host -foregroundcolor red "`a`n`"$Foldername`" does not exist or is not a folder"
        exit 1
    }

# Validate the day of week:
# ------------------------
    if ( ($DayOfWeek -as [System.DayOfWeek] ) -eq $null )
    {
        write-host -foregroundcolor red "`a`n`"$DayOfWeek`" is not a valid day of the week"
        exit 1
    }

# Display the files created on the given day of the week:
# ------------------------------------------------------
    write-host "`nFolder $FolderName contains the following files created on a $($DayOfWeek):"

    Get-ChildItem $FolderName -File |
        where-object { $_.CreationTime.DayOfWeek -eq $DayOfWeek } |
        format-table Name, CreationTime -auto
