<# 
.NAME
    Get-ADComputerAccoutNameByOS
.DESCRIPTION
    Active Directory içerisinde Cumputer hesaplarında işletim sistemi bilgisine göre arama yapar
.INPUTS
    OperatingSystem
.OUTPUTS
    Computer Name

#>
function Get-ADComputerAccoutNameByOS
{
[CmdletBinding(
    helpURI = "https://github.com/SametKARA/PowerShellWatcher",
    positionalBinding = $true)]

[OutputType([System.Collections.ArrayList])]

Param
(
[Parameter(Mandatory=$true,
    Position=1,
    HelpMessage="arama yapılırken bulunması istenilen işletim sisteminin yazılması gerekmektedir.")]
    [Alias("OS")]
    [string]
    $OperatingSystem
)
#Function Logic:

$Domain = Open-DomainDialog
$Searcher = [adsisearcher]""  
$Searcher.SearchRoot= [adsi]"LDAP://$Domain"
$Searcher.Filter = ("(&(objectCategory=computer)(OperatingSystem=*$OperatingSystem*))")
$Searcher.PropertiesToLoad.Add('Name') | Out-Null
$Results = $Searcher.FindAll()
$Return = New-Object System.Collections.ArrayList 
foreach ($Result in $Results) {
    [string]$Computer = $Result.Properties.name
    If (-NOT $Return.contains($Computer)) {
        [void]$Return.Add($Computer)     
    }
}
return $Return
}

<# 
.NAME
    Get-ADComputerAccoutNameByName
.DESCRIPTION
    Active Directory içerisinde Cumputer hesaplarında bilgisayarın isim bilgisine göre arama yapar
.INPUTS
    ComputerName
.OUTPUTS
    Computer Name

#>
function Get-ADComputerAccoutNameByName
{
    [CmdletBinding(
        helpURI = "https://github.com/SametKARA/PowerShellWatcher",
        positionalBinding = $true)]    

    [OutputType([System.Collections.ArrayList])]

    Param
    (
    [Parameter(Mandatory=$true,
        Position=1,
        HelpMessage="arama yapılırken bulunması istenilen bilgisayarın adının yazılması gerekmektedir.")]
        [Alias("Name")]
        [string]
        $ComputerName
    )

    #Function Logic:


    $Domain = Open-DomainDialog
    $Searcher = [adsisearcher]""  
    $Searcher.SearchRoot= [adsi]"LDAP://$Domain"
    #TODO: Aşağıdaki komutun çalışırlığını kontrol et
    $Searcher.Filter = ("(&(objectCategory=computer)(Name=*$OperatingSystem*))")
    $Searcher.PropertiesToLoad.Add('name') | Out-Null
    $Results = $Searcher.FindAll()
    $Return = New-Object System.Collections.ArrayList 
    foreach ($Result in $Results) {
        [string]$Computer = $Result.Properties.name
        If (-NOT $Return.contains($Computer)) {
            [void]$Return.Add($Computer)     
        }
    }
    return $Return
}