# Warning. This will restart your server.

$domainName = "<YOUR-DOMAIN>"
$adminAccount = "<YOUR-DOMAIN>\<ADMIN-USER-IN-DOMAIN>"

$safeModeAdministratorPassword = ConvertTo-SecureString "<LOCAL-PASSWORD>" -AsPlainText -Force
$password = ConvertTo-SecureString "<ADMIN-USER-PASSWORD>" -AsPlainText -Force

# Create credential object
$cred = New-Object System.Management.Automation.PSCredential ($adminAccount, $password)

# Download AD library
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Set existing controller as DNS source (Just being able to resolve the domain is not enough.)
Set-DnsClientServerAddress –InterfaceAlias "Ethernet 2" -ServerAddresses ("<YOUR-EXISTING-CONTROLLER-IP>", "<YOUR-EXISTING-CONTROLLER-IP-2>")

# Promote server to Domain Controller
Install-ADDSDomainController -DomainName $domainName -Credential $cred -SafeModeAdministratorPassword $safeModeAdministratorPassword -Force
