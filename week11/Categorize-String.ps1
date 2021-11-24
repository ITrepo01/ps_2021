#=======================================================================
#
#   Categorize-String.ps1  -  Example of using Regular Expressions
#
#   This script accepts one argument and uses regular expressions
#   to categorize it as an IP address, a URL, or an e-mail address.
#
#========================================================================


# Pattern used to recognize IP addresses:
# --------------------------------------
#                   \d                    numeric digit
#                   \d{1,3}               1 to 3 numeric digits
#                   \d{1,3}\.             1-3 digits followd by "."
#                  (\d{1,3}\.){3}         three of these
#                  (\d{1,3}\.){3}\d{1,3}  three of these followed by 1-3 more digits
#                 ^(\d{1,3}\.){3}\d{1,3}$ ...with nothing else in the string

    $regexp_IP = '^(\d{1,3}\.){3}\d{1,3}$'


# Pattern used to recognize e-mail addresses:
# ------------------------------------------
#    [\w]                                      starts with a word character
#    [\w]\.*[\w\d]                             ...followed by an optional "." and a word or digit character
#    [\w]\.*([\w\d])+                          ...the word or digit characters can be repeated
#    [\w](\.*([\w\d])+)+                       ...there can be multiple word/digit groups separated by periods
#    [\w](\.*([\w\d])+)+@                      ...followed by "@"
#    [\w](\.*([\w\d])+)+@[\w](\.*([\w\d])+)+   ...followed by the same word/digit groups separated by period
#    ^[\w](\.*([\w\d])+)+@[\w](\.*([\w\d])+)+$ ...with nothing else in the string

    $regexp_mail = '^[\w](\.*([\w\d])+)+@[\w](\.*([\w\d])+)+$'


# Pattern used to recognize URLs:
# ------------------------------
#   ^https?:                         starts with "http:" or "https:"
#	^https?://                       ...followed by "//" (note: these are not literal
#   ^https:?//[^/\.]                 ...followed by a non-"."
#   ^https:?//[^/\.]+                ...(one or more of the non-/. characters)
#   ^https:?//[^/\.]+(\.[^/\.]+)+    ...followed one or more: ( "." and more non-/. chars )

    $regexp_URL = '^https?://[^/\.]+(\.[^/\.]+)+'


# Check that an argument was given:
# --------------------------------

    if ( $args.count -lt 1 )
    {
        write-host "You must give a parameter!"
        exit 1
    }


# Determine the type of argument using regular expressions:
# --------------------------------------------------------

    switch -regex ( $args[0] )
    {
        $regexp_IP   { write-host $args[0] "is an IP address" }
        $regexp_mail { write-host $args[0] "is an e-mail address" }
        $regexp_URL  { write-host $args[0] "is a URL" }
        default      { write-host $args[0] "is not a URL, IP or e-mail address" }
    }

    exit 0