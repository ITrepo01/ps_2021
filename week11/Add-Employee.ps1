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
    
# Get the required info:
# ---------------------
    write-host -nonewline "Employee name (in 'surname, given name' format): "
    $Name = Read-Host
    if ( $Name -eq "" ) { exit 0 }
    
    write-host -nonewline "Employee ID number: "
    $ID = Read-Host
    if ( $ID -eq "" ) { exit 0 }
    
    write-host -nonewline "Employee's Division: "
    $Div = Read-Host
    if ( $Div -eq "" ) { exit 0 }
    
    write-host -nonewline "Employee's date of birth: "
    $DateOfBirth = Read-Host
    if ( $DateOfBirth -eq "" ) { exit 0 }
    
# Create a new object to hold the employee info and add the entered info to it:
# -----------------------------------------------------------------------------
    $NewEmp = new-object object
    $NewEmp | Add-Member NoteProperty Name $Name
    $NewEmp | Add-Member NoteProperty ID $ID
    $NewEmp | Add-Member NoteProperty Division $Div
    $NewEmp | Add-Member NoteProperty BirthDate $DateOfBirth

# Read the old employee file and add the new employee to it:
# ---------------------------------------------------------
    $FileContents = Import-CSV Employees.CSV
    $FileContents += $NewEmp

# Write the updated collection of employees to the file using "safe update" strategy:
# ----------------------------------------------------------------------------------
    $FileContents | sort Name | Export-CSV -NoTypeInfo Employees.New
    Move-Item -force Employees.Csv Employees.Bak
    Move-Item Employees.New Employees.Csv
    
    write-host
    write-host -foregroundcolor cyan "Employee $Name has been added to the file"
    