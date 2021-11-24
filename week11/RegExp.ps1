Get-Content FileInfo.txt  |  foreach {

   $Pattern = "^(?<Name>.+) +(?<Length>[0-9,]+) +(?<Date>[-0-9]+ [0-9:\.]+)$"
   if ( $_ -match $Pattern )
   {
      $Name = $Matches["Name"]
      $Len =  $Matches["Length"]
      $Date = $Matches["Date"]
   }

   $File = Get-Item $Name

   if ($File.Length -ne $Len)  {
      write-host "$Name length has changed" }

   if ($File.LastWriteTime -ne $Date)  {
      write-host "$Name date has changed" }
}
