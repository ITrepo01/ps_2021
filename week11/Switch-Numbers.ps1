#--------------------------------------------------------------------
#
#   Switch-Numbers.ps1  -  Show that multiple -Wildcard matches are possible:
#
#--------------------------------------------------------------------

# Get a 1-digit number from the command line:
# ------------------------------------------

	if ( $args.count -lt 1 )
	{
	    write-host -foregroundcolor red "`nYou must give a 1-digit number as a command argument`n"
        exit 1
	}
    
    $Number = $args[0]
    if ( $Number -notlike "[0-9]" )
    {
	    write-host -foregroundcolor red "`n'$Number' is not a 1-digit number`n"
        exit 1
    }

	
# List some stuff about the number:
# --------------------------------

    write-host "`n$Number is:"
	
     switch  -wildcard  ( $Number )
     {
        "[02468]" { write-host "  an even number" }
        "[13579]" { write-host "  an odd number" }
        "[2357]"  { write-host "  a prime number" }
        "[248]"   { write-host "  a power of 2" }
        "[39]"    { write-host "  a power of 3" }
        "0"       { write-host "  zero" }
     }

    write-host