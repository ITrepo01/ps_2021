#=======================================================================
#
#   Calculate.ps1  -  Perform a calculation using command-line arguments
#
#   This script accpets three command line arguments:
#      - a number
#      - a "+", "/", "-" or "*" operator
#      - a second number
#
#   It performs the requested operation and displays the result.
#
#=======================================================================

# Get the script arguments and validate them:
# ------------------------------------------
    if ( $args.count -lt 3 )
    {
        write-host "This script requires three command line arguments:"
        write-host "   - a number"
        write-host '   - a "+", "/", "-" or "*" operator'
        write-host "   - a second number"
        exit 1
    }

    $No1 = $args[0] -as [double]
    $Operator = $args[1]
    $No2 = $args[2] -as [double]
    
    if ( $No1 -eq $Null )
    {
        write-host "`"$($args[0])`" is not numeric!"
        exit 1
    }
    
    if ( $No2 -eq $Null )
    {
        write-host "`"$($args[2])`" is not numeric!"
        exit 1
    }
    
# Perform the requested calculation and display the result:
# --------------------------------------------------------
    if     ( $Operator -eq "+" ) { $Result = $No1 + $No2 }
    elseif ( $Operator -eq "-" ) { $Result = $No1 - $No2 }
    elseif ( $Operator -eq "*" ) { $Result = $No1 * $No2 }
    elseif ( $Operator -eq "/" ) { $Result = $No1 / $No2 }
    else
    {
        write-host "`"$Operator`" is not a valid operator, please use `"+`", `"-`", `"*`" or `"/`""
        exit 1
    }
    
    write-host $No1 $Operator $No2 "=" $Result