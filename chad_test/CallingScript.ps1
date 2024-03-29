﻿# break

# Shout out to @brwilkinson for assistance with some of this.


# # Install the Azure Resource Manager modules from PowerShell Gallery
# # Takes a while to install 28 modules
# Install-Module AzureRM -Force -Verbose
# Install-AzureRM
# 
# # Install the Azure Service Management module from PowerShell Gallery
# Install-Module Azure -Force -Verbose
# 
# # Import AzureRM modules for the given version manifest in the AzureRM module
# Import-AzureRM -Verbose
# 
# # Import Azure Service Management module
# Import-Module Azure -Verbose
# 
# # Authenticate to your Azure account
# Login-AzureRmAccount

# Adjust the 'yournamehere' part of these three strings to
# something unique for you. Leave the last two characters in each.
$templateFile = 'azuredeploy.json'
$Location  = 'East US'
$rgname    = 'irops-chad-test'
$saname    = 'iropschadstoracct'     # Lowercase required
$addnsName = 'iropschadtest'     # Lowercase required
$assetLocation = "https://raw.githubusercontent.com/cbarrientos1979/ua/master/chad_test/"
$domainName = 'iropschad.local'

# Check that the public dns $addnsName is available
if (Test-AzureRmDnsAvailability -DomainNameLabel $addnsName -Location $Location)
{ 'Available' } else { 'Taken. addnsName must be globally unique.' }

# Create the new resource group. Runs quickly.
New-AzureRmResourceGroup -Name $rgname -Location $Location

# Parameters for the template and configuration
$MyParams = @{
    newStorageAccountName = $saname
    location              = $Location
    domainName            = $domainName
    addnsName             = $addnsName
    assetLocation         = $assetLocation
   }

# Splat the parameters on New-AzureRmResourceGroupDeployment  
$SplatParams = @{
    TemplateFile            = $templateFile
    ResourceGroupName       = $rgname 
    TemplateParameterObject = $MyParams
    Name                    = 'ChadIROPSLab'
   }

# This takes ~30 minutes
# One prompt for the domain admin password
New-AzureRmResourceGroupDeployment @SplatParams -Verbose

# Find the VM IP and FQDN
$PublicAddress = (Get-AzureRmPublicIpAddress -ResourceGroupName $rgname)[0]
$IP   = $PublicAddress.IpAddress
$FQDN = $PublicAddress.DnsSettings.Fqdn

# # RDP either way
# Start-Process -FilePath mstsc.exe -ArgumentList "/v:$FQDN"
# Start-Process -FilePath mstsc.exe -ArgumentList "/v:$IP"

# Login as:  alpineskihouse\adadministrator
# Use the password you supplied at the beginning of the build.

# Explore the Active Directory domain:
#  Recycle bin enabled
#  Admin tools installed
#  Five new OU structures
#  Users and populated groups within the OU structures
#  Users root container has test users and populated test groups

# Delete the entire resource group when finished
# Remove-AzureRmResourceGroup -Name $rgname -Force -Verbose
