$Target = @("de.srp.blackberry.com","de.bbsecure.com","de.turnb.bbsecure.com")
$Port = 3101
 
$result=@()
 
foreach ($t in $Target)
 
{
$a=Test-NetConnection -ComputerName $t -Port $Port -WarningAction SilentlyContinue
 
$result+=New-Object -TypeName PSObject -Property ([ordered]@{
'Target'=$a.ComputerName;
'RemoteAddress'=$a.RemoteAddress;
'Port'=$a.RemotePort;
'Status'=$a.tcpTestSucceeded
 
})
 
}
 
Write-Output $result

$Target = @("gdentgw.good.com","gdrelay.good.com","gdweb.good.com","gdmdc.good.com")
$Port = 443
 
$result=@()
 
foreach ($t in $Target)
 
{
$a=Test-NetConnection -ComputerName $t -Port $Port -WarningAction SilentlyContinue
 
$result+=New-Object -TypeName PSObject -Property ([ordered]@{
'Target'=$a.ComputerName;
'RemoteAddress'=$a.RemoteAddress;
'Port'=$a.RemotePort;
'Status'=$a.tcpTestSucceeded
 
})
 
}
 
Write-Output $result