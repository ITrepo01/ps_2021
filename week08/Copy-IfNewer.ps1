#-------------------------------------------------------------
#   Copy-IfNewer  -  Copy a file to a given folder if newer
#
#   The file is copied to the target folder if it is newer or
#   if it or the target folder don't exist.
#
#   Parameters:
#       - name of the file to be copied
#       - folder to which the file will be copied if it's newer
#         than the same file in that folder
#
#-------------------------------------------------------------

# Both command line parameters must be given:
# ------------------------------------------
    if ( $args.count -ne 2 )
    {
        write-host -foregroundcolor yellow "`a`nThis script requires two parameters:"
        write-host -foregroundcolor yellow "  - the name of a file to be copied"
        write-host -foregroundcolor yellow "  - the name of a target folder to copy it to`n"
        exit 1
    }

# Get the parameters and ensure the file to be copied actually exists:
# -------------------------------------------------------------------   
    $FileName = $args[0]
    $TargetFolderName = $args[1]
    
    if ( -not (test-path $FileName -pathtype leaf ) )
    {
        write-host -foregroundcolor yellow "`a`nFile `"$FileName`" not found!`n"
        exit 1
    }
    
# Create the target folder if necessary:
# -------------------------------------
    if ( -not (test-path $TargetFolderName -pathtype container ) )
    {
        new-item $TargetFolderName -itemtype directory | out-null
        write-host "Target folder does not exist, created"
    }
    
# Construct the name of the target file so we can check its date:
# --------------------------------------------------------------
    $FileNameOnly = [IO.Path]::GetFileName( $FileName )
    $TargetFileName = [IO.Path]::Combine( $TargetFolderName, $FileNameOnly )
    
# Copy the file if it doesn't exist in the target folder:
# ------------------------------------------------------
    if ( -not (test-path $TargetFileName -pathtype leaf ) )
    {
        copy-item $FileName $TargetFileName
        write-host "File does not exist in target folder, copied"
    }
    
# Copy the file if it's newer than the one in the target folder:
# -------------------------------------------------------------
    elseif ( (Get-Item $FileName).LastWriteTime -gt
         (Get-Item $TargetFileName).LastWriteTime )
    {
        copy-item $FileName $TargetFileName
        write-host "File in target folder is out of date, copied"
    }

# Otherwise, we didn't copy the file:
# ----------------------------------
    else
    {
        write-host "File in target folder is up to date"
    }

    exit 0