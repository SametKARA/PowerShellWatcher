<#
.Synopsis
   Write-Log writes a message to a specified log file with the current time stamp.
.DESCRIPTION
   The Write-Log function is designed to add logging capability to other scripts.
   In addition to writing output and/or verbose you can write to a log file for
   later debugging.
.NOTES
   Created by: Jason Wasser @wasserja
   Modified by: Samet Kara @SametKARA
   Modified: 02/02/2019 21:24:15 AM  

   Changelog:
    * Code simplification and clarification - thanks to @juneb_get_help
    * Added documentation.
    * Renamed LogPath parameter to Path to keep it standard - thanks to @JeffHicks
    * Revised the Force switch to work as it should - thanks to @JeffHicks
    * FileName and Path variables are seperated
    * Datetime format added to FileName
	* TimeZone information added to FormattedDate - @SametKARA

   To Do:
    * Add error handling if trying to create a log file in a inaccessible location.
    * Add ability to write $Message to $Verbose or $Error pipelines to eliminate
      duplicates.
.PARAMETER Message
   Message is the content that you wish to add to the log file. 
.PARAMETER Path
   The path to the log file to which you would like to write. By default the function will 
   create the path if it does not exist. 
.PARAMETER FileName
   The name of the log file to which you would like to write. By default the function will 
   create the file if it does not exist. 
.PARAMETER Level
   Specify the criticality of the log information being written to the log (i.e. Error, Warning, Informational)
.PARAMETER NoClobber
   Use NoClobber if you do not wish to overwrite an existing file.
.EXAMPLE
   Write-Log -Message 'Log message' 
   Writes the message to c:\Logs\PowerShellLog_yyyy-MM-dd.log.
.EXAMPLE
   Write-Log -Message 'Restarting Server.' -Path c:\Logs\ -FileName Scriptoutput.log
   Writes the content to the specified log file and creates the path and file specified. 
.EXAMPLE
   Write-Log -Message 'Folder does not exist.' -Path c:\Logs\ -FileName Script.log -Level Error
   Writes the message to the specified log file as an error message, and writes the message to the error pipeline.
.LINK
   https://gallery.technet.microsoft.com/scriptcenter/Write-Log-PowerShell-999c32d0
#>
function Write-Log
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [Alias('LogPath')]
        [string]$Path='C:\Logs\',

        [Parameter(Mandatory=$false, 
            HelpMessage="dosya adında % sembolü kullanılırsa % sembolleri arasında bulunan alan datetime şeklinde yeniden formatlanacaktır.")]
        [Alias('LogFileName')] 
        [string]$FileName='PowerShellLog_%yyyy-MM-dd%.log',
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Warn","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )

    Begin
    {
        # Set VerbosePreference to Continue so that verbose messages are displayed.
        $VerbosePreference = 'Continue'
    }
    Process
    {  
        # Dosyanın adında % sembolü var mı kontrol edilir.
        if ($FileName -contains "%")
        {
            $ParsedFileName = $FileName -split "%"
            $FileName = $ParsedFileName[0] + (Get-Date -Format $ParsedFileName[1]) + $ParsedFileName[2]
        }

        if(-NOT $Path.EndsWith("\"))
        {
            $Path += "\"
        }

        $FilePath =  $Path + $FileName

        if($FilePath.EndsWith("\"))
        {
            $FilePath.Remove($FilePath.Length - 2)
        }

        # If the file already exists and NoClobber was specified, do not write to the log.
        if ((Test-Path $FilePath) -AND $NoClobber) {
            Write-Error "Log file $FilePath already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
            }

        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path.
        elseif (!(Test-Path $FilePath)) {
            Write-Verbose "Creating $FilePath."
            New-Item $FilePath -Force -ItemType File
            }

        else {
            # Nothing to see here yet.
            }

        # Format Date for our Log File
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss z"

        # Write message to error, warning, or verbose pipeline and specify $LevelText
        switch ($Level) {
            'Error' {
                Write-Error $Message
                $LevelText = 'ERROR:'
                }
            'Warn' {
                Write-Warning $Message
                $LevelText = 'WARNING:'
                }
            'Info' {
                Write-Verbose $Message
                $LevelText = 'INFO:'
                }
            }

        # Write log entry to $Path
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $FilePath -Append
    }
    End
    {
    }
}