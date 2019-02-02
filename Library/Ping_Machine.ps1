function Ping_Computers {
    param (
        [string[]] $Computers,
        [int] $maxConcurrentJobs
    )

    #Creating runspace pool and session states
    $SessionState = [system.management.automation.runspaces.initialsessionstate]::CreateDefault()
    $RunspacePool = [runspacefactory]::CreateRunspacePool(1, $maxConcurrentJobs, $SessionState, $Host)
    $RunspacePool.Open()  

    ForEach ($Computer in $Computers) {
        #Create the powershell instance and supply the scriptblock with the other parameters 
        $powershell = [powershell]::Create().AddScript($ScriptBlock).AddArgument($Path).AddArgument($computer).AddArgument($installAudit).AddArgument($uiHash)
   
        #Add the runspace into the powershell instance
        $powershell.RunspacePool = $RunspacePool
   
        #Create a temporary collection for each runspace
        $temp = "" | Select-Object PowerShell,Runspace,Computer
        $Temp.Computer = $Computer.computer
        $temp.PowerShell = $powershell
   
        #Save the handle output when calling BeginInvoke() that will be used later to end the runspace
        $temp.Runspace = $powershell.BeginInvoke()
        Write-Verbose ("Adding {0} collection" -f $temp.Computer)
        $jobs.Add($temp) | Out-Null                
    }#endregion  

}