#------------------------------------------------------------------------
#
#   Add-Employee.ps1  -  Add a new employee to the Employees.csv file
#
#       This script prompts the user for the information needed to add
#       a new employee and then adds that employee to the Employees.csv
#       file using a "safe update" strategy.
#
#------------------------------------------------------------------------

# Show explanatory message:
# ------------------------
    write-host
    write-host -foregroundcolor cyan "Add a new employee to the Employees.csv file"
    write-host
    write-host "At any prompt you may press ENTER without typing anything to cancel the update"
    write-host
    
# Read the old employee file:
# --------------------------
    $FileContents = Import-CSV Employees.CSV

# Get collections of the user name and IDs to be used for validation:
# ------------------------------------------------------------------
    $ExistingUsernames = $FileContents | foreach { $_.Name }
    $ExistingUserIDs = $FileContents | foreach { $_.ID }
    
# Get the user name and ensure it is unique:
# -----------------------------------------
    while ( $True )
    {
        write-host -nonewline "`nEmployee name (in 'surname, given name' format): "
        $Name = Read-Host
        if ( $Name -eq "" ) { exit 0 }
        if ( $ExistingUserNames -notcontains $Name ) { break }
        write-host -foregroundcolor yellow "`a   '$Name' is already on file, please choose a different name"
    }

# Get the ID number and ensure it is both numeric and unique:
# ----------------------------------------------------------    
    while( $True )
    {
        write-host -nonewline "`nEmployee ID number: "
        $ID = Read-Host
        if ( $ID -eq "" ) { exit 0 }
        if ( ($ID -as [int]) -eq $null )
        {
            write-host -foregroundcolor yellow  "`a   '$ID' is not numeric, please use a numeric ID number"
            continue
        }
        if ( $ExistingUserIDs -contains $ID )
        {
            write-host -foregroundcolor yellow  "`a   '$ID' is already on file, please choose a different ID number"
            continue
        }
        break
    }

# Get the division (no validation needed for this):
# ------------------------------------------------
    write-host -nonewline "`nEmployee's Division: "
    $Div = Read-Host
    if ( $Div -eq "" ) { exit 0 }

# Get the date of birth and ensure it's valid and in the proper format:
# --------------------------------------------------------------------
    while( $True )
    {
        write-host -nonewline "`nEmployee's date of birth: "
        $DateOfBirth = Read-Host
        if ( $DateOfBirth -eq "" ) { exit 0 }
        if ( ($DateOfBirth -as [datetime]) -ne $null ) { break }
        write-host -foregroundcolor yellow "`a   '$DateOfBirth' is not a valid, please enter a valid date"
    }
    $DateOfBirth = ([datetime]$DateOfBirth).ToString( "yyyy-MM-dd" )
    
# Confirm addition of new employee:
# --------------------------------
    write-host
    write-host -foregroundcolor cyan "New employee $Name will be added to the Employees.csv file"
    write-host "         ID: $ID"
    write-host "   Division: $Div"
    write-host " Birth date: $DateOfBirth"
    
    while( $true )
    {
        write-host -nonewline "`nDo you really want to add this employee? "
        $Reply = (Read-Host).ToLower()
        if ($Reply -eq "") { exit 0 }
        if ( "yes".StartsWith($Reply) ) { break }
        if ( "no".StartsWith($Reply) ) { exit 0 }
        write-host -foregroundcolor yellow "   Please respond with 'Yes' or 'No'"
    }
    
# Create a new object to hold the employee info and add the entered info to it:
# -----------------------------------------------------------------------------
    $NewEmp = new-object object
    $NewEmp | Add-Member NoteProperty Name $Name
    $NewEmp | Add-Member NoteProperty ID $ID
    $NewEmp | Add-Member NoteProperty Division $Div
    $NewEmp | Add-Member NoteProperty BirthDate $DateOfBirth

# Add the new employee to those already read from the file:
# --------------------------------------------------------
    $FileContents += $NewEmp

# Write the updated collection of employees to the file using "safe update" strategy:
# ----------------------------------------------------------------------------------
    $FileContents | sort Name | Export-CSV -NoTypeInfo Employees.New
    Move-Item -force Employees.Csv Employees.Bak
    Move-Item Employees.New Employees.Csv
    
    write-host
    write-host -foregroundcolor cyan "Employee $Name has been added to the file"
    