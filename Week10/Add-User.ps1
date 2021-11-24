#-----------------------------------------------------------------
#  Add-User.ps1  -  Add a new user to the user file
#
#    This script prompts for user information, verifies it, and
#    adds a new user to the "Users.csv" file.
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#  AccountExists - return $true if the given account exists in the
#                  user file
#-----------------------------------------------------------------
Function AccountExists( $AccountName, $Users )
{
    foreach ( $User in $Users )
    {
        if ( $User.AccountName -eq $AccountName ) { return $true }
    }
    return $false
}

#-----------------------------------------------------------------
#  EmployeeIDExists - return $true if the given employee exists
#                     in the user file
#-----------------------------------------------------------------
Function EmployeeIDExists( $EmployeeID, $Users )
{
    foreach ( $User in $Users )
    {
        if ( $User.EmployeeID -eq $EmployeeID ) { return $true }
    }
    return $false
}

#-----------------------------------------------------------------
#  Main - script execution starts here.
#-----------------------------------------------------------------

# Read the existing data from the users file:
# ------------------------------------------
    $Users = Import-CSV Users.csv
    
# Prompt for the new username:
# ---------------------------
    write-host -nonewline "`nFirst and last name of new user: "
    $NewUsername = read-host
    
# Prompt for the new account name and verify that it is unique:
# ------------------------------------------------------------
    while( $true )
    {
        write-host -nonewline "`nAccount name: "
        $NewAccountName = read-host
        if ( -not ( AccountExists $NewAccountName $Users ) ) { break }
        write-host -foregroundcolor yellow "That account name already exists, please choose another"
    }
    
# Prompt for the new employee ID and verify that it is unique and in the correct format:
# -------------------------------------------------------------------------------------
    while( $true )
    {
        write-host -nonewline "`nEmployee ID: "
        $NewEmployeeID = read-host
        if ( $NewEmployeeID -notlike "M[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" )
        {
            write-host -foregroundcolor yellow "Please enter the ID in Mnnnnnnnn format"
            continue
        }
        if ( EmployeeIDExists $NewEmployeeID $Users )
        {
            write-host -foregroundcolor yellow "That ID already exists, please choose another"
            continue
        }
        break
    }

# Prompt for the new user's phone number and verify that it is 10 numeric digits:
# ------------------------------------------------------------------------------
    while( $true )
    {
        write-host -nonewline "`nPhone number: "
        $NewPhoneNo = read-host
        if ( $NewPhoneNo -like "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" ) { break }
        write-host -foregroundcolor yellow "Please enter 10 digits only for the phone number"
    }

# Prompt for the new user's PC name and verify that it is "PC" or "WS" followed by 4 digits:
# -----------------------------------------------------------------------------------------
    while( $true )
    {
        write-host -nonewline "`nPC Name: "
        $NewPC = read-host
        if ( ($NewPC -like "PC[0-9][0-9][0-9][0-9]") -or
             ($NewPC -like "WS[0-9][0-9][0-9][0-9]") ) { break }
        write-host -foregroundcolor yellow "Please enter a name of `"PCnnnn`" or `"WSnnnn`""
    }

# Display the information and confirm:
# -----------------------------------
    write-host "`nThe following user information will be added to Users.csv:"
    write-host "     User Name: $NewUsername"
    write-host "  Account Name: $NewAccountName"
    write-host "   Employee ID: $NewEmployeeID"
    write-host "      Phone No: $NewPhoneNo"
    write-host "       PC Name: $NewPC"
    
    while ( $true )
    {
        write-host -nonewline "`nDo you really want to add this user? "
        $Response = (read-host).ToLower()
        if ( $Response -ne "" )
        {
            if ( "no".StartsWith($Response) ) { exit 1 }
            if ( "yes".StartsWith($Response) ) { break }
        }
        write-host -foregroundcolor yellow "Please respond with YES or NO"
    }

# Create the new user object and add it to the users collection:
# -------------------------------------------------------------
    $NewUser = new-object Object
    $NewUser | Add-Member NoteProperty UserName    $NewUserName
    $NewUser | Add-Member NoteProperty AccountName $NewAccountName
    $NewUser | Add-Member NoteProperty EmployeeID  $NewEmployeeID
    $NewUser | Add-Member NoteProperty PhoneNo     $NewPhoneNo
    $NewUser | Add-Member NoteProperty PC          $NewPC

    $Users += $NewUser
     
 # Write the updated users collection to the Users.csv file using a safe update strategy:
 # -------------------------------------------------------------------------------------
    $Users | Sort-Object AccountName | Export-CSV Users.tmp -notype
    Move-Item Users.csv Users.bak -force
    Move-Item Users.tmp Users.csv -force
    
 # The update is done:
 # ------------------
    write-host -foregroundcolor green "`nUser `"$NewUserName`" has been added to Users.csv`n"