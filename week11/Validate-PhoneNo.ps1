#=======================================================================
#
#   Validate-PhoneNo.ps1  -  Example of using Regular Expressions
#
#   This script uses regular expressions to validate a phone number.
#
#   Phone numbers are accepted in the following formats:
#
#      5551234
#      555-1234
#      8005551234
#      800 555-1234
#      (800) 5551234
#      (800) 555-1234
#      18005551234
#      1(800)555-1234
#      1-800-555-1234
#
#========================================================================


#========================================================================
#
#    Is-ValidPhoneNo  -  Check phone number, return $true if it is valid
#
#========================================================================

function Is-ValidPhoneNo
{
    param ( [string]$PhoneNo )

# Pattern used to recognize :
# --------------------------------------
#     1?                                              optional "1" digit (country code)
#     1? *                                            ...followed by 0 or more spaces
#     1? *(\d{3})?                                    ...followed by optional "ddd"
#     1? *(\d{3}|\(\d{3}\))?                               ... or "(ddd)" / "( ddd )" / etc
#     1? *(\d{3}|\( *\d{3} *\)|- *\d{3} *-)?               ... or "-ddd-" / "- ddd -" / etc
#     1? *(\d{3}|\( *\d{3} *\)|- *\d{3} *-)? *        ...followed 0 or more spaces
#     1? *(\d{3}|\( *\d{3} *\)|- *\d{3} *-)? *\d{3}       ...followed by "ddd"
#     1? *(\d{3}|\(ne *\d{3} *\)|- *\d{3} *-)? *\d{3}( *- *)?     ...followed by optional "-" / " - " / etc.
#     1? *(\d{3}|\( *\d{3} *\)|- *\d{3} *-)? *\d{3}( *- *)?\d{4}     ...followed by "dddd"


#     1? *(\d{3}|\(\d{3}\)|-\d{3}-)? *\d{3}-?          ...followed by an optional "-"
#     1? *(\d{3}|\(\d{3}\)|- *\d{3} *-)? *\d{3}-?{\d4}     ...followed by dddd
#     ^1? *(\d{3}|\(\d{3}\)|-\d{3}-)? *\d{3}-?{\d4}$   start/end anchors
#

    return $PhoneNo -match '^1? *(\d{3}|\( *\d{3} *\)|- *\d{3} *-)? *\d{3}( *- *)?\d{4}'
}



#========================================================================
#
#    Main Program - Execution starts here
#
#========================================================================

# Check that an argument was given:
# --------------------------------
    if ( $args.count -lt 1 )
    {
        write-host "You must give a phone number!"
        exit 1
    }

# Call the function to validate the phone number:
# ----------------------------------------------
    if ( Is-ValidPhoneNo $args[0] )
    {
        write-host $args[0] "is a valid phone number"
    }
    else
    {
        write-host $args[0] "is NOT a valid phone number"
    }

    exit 0