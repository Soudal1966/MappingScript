Start-Transcript -Path $(Join-Path $env:temp "DriveMapping.log")

$driveMappingConfig=@()


######################################################################
#                section script configuration                        #
######################################################################

<#
   Add your internal Active Directory Domain name and custom network drives below
#>

$dnsDomainName= "soudal.be"


$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "X"
    UNCPath= "\\soudal.be\fs\sdlbe"
    Description="SDLBE"
}


$driveMappingConfig+=  [PSCUSTOMOBJECT]@{
    DriveLetter = "P"
    UNCPath= "\\soudal.be\fs\public"
    Description="Public"
}

$driveMappingConfig+=  [PSCUSTOMOBJECT]@{
    DriveLetter = "Q"
    UNCPath= "\\soudal.be\fs\general"
    Description="General"
}

$Groupname = "SDL_int_pretest"

##if((Get-AzureADGroup -SearchString $Groupname | Get-AzureADGroupMember | Select-Object Userprincipalname) -match $env:USERNAME)
##{
$driveMappingConfig+=  [PSCUSTOMOBJECT]@{
    DriveLetter = "R"
    UNCPath= "\\soudal.be\fs"
    Description="CORP"
##}
}

######################################################################
#               end section script configuration                     #
######################################################################

$connected=$false
$retries=0
$maxRetries=3

Write-Output "Starting script..."
do {
    
    if (Resolve-DnsName $dnsDomainName -ErrorAction SilentlyContinue){
    
        $connected=$true

    } else{
 
        $retries++
        
        Write-Warning "Cannot resolve: $dnsDomainName, assuming no connection to fileserver"
 
        Start-Sleep -Seconds 3
 
        if ($retries -eq $maxRetries){
            
            Throw "Exceeded maximum numbers of retries ($maxRetries) to resolve dns name ($dnsDomainName)"
        }
    }
 
}while( -not ($Connected))

#Map drives
    $driveMappingConfig.GetEnumerator() | ForEach-Object {

        Write-Output "Mapping network drive $($PSItem.UNCPath)"

        New-PSDrive -PSProvider FileSystem -Name $PSItem.DriveLetter -Root $PSItem.UNCPath -Description $PSItem.Description -Persist -Scope global

        (New-Object -ComObject Shell.Application).NameSpace("$($PSItem.DriveLEtter):").Self.Name=$PSItem.Description
}

Stop-Transcript

