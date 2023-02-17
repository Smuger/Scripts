# Warning. This will restart your server.

$domainName = "<YOUR-DOMAIN>"
$adminAccount = "<YOUR-DOMAIN>\<ADMIN-USER-IN-DOMAIN>"

$safeModeAdministratorPassword = ConvertTo-SecureString "<LOCAL-PASSWORD>" -AsPlainText -Force

$password = ConvertTo-SecureString "<ADMIN-USER-PASSWORD>" -AsPlainText -Force

$existingADController = [System.Net.Dns]::GetHostaddresses($domainName).ipaddresstostring[0]

# Create credential object
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminAccount, $password

# Download AD library
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Set existing controller as DNS source (Just being able to resolve the domain is not enough.)
Set-DnsClientServerAddress –InterfaceAlias "Ethernet 2" -ServerAddresses $existingADController

# Add server to the domain
add-computer –domainname $domainName -Credential $cred

# Promote server to Domain Controller
Install-ADDSDomainController -DomainName $domainName -Credential $cred -SafeModeAdministratorPassword $safeModeAdministratorPassword -Force
