# get profile path with 
# PS C:\Users\jfish> echo $profile
# C:\Users\jfish\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

set-alias tf terraform
function sendToOctopus($1){
	scp.exe -o ciphers=aes256-ctr -i C:\Users\jfish\keys\octo.priv $1 jfish@octopus.nvl.army.mil:$1
}

function psto-host {
    param (
        [Parameter(Mandatory=$true)]
        [String]$ComputerName,
        [Parameter(Mandatory=$true)]
        [PSCredential]$Credential
    )

    New-PSSession -ComputerName $ComputerName -Credential $Credential
}

function get-revologs(){
	Get-EventLog -LogName System | ? { $_.message -like "*revoca*"} |select -property timegenerated,timewritten,message -first 5 | ft -wrap
}

function asdm-run(){
	pushd 'C:\Program Files (x86)\Cisco Systems\ASDM'
	.\run.bat
}

function lr(){
	ls | Sort-Object -Property LastWriteTime
}

function ss(){
	get-nettcpconnection | select local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | Sort-Object -Property process | ft -GroupBy process
}

function netconns {
 param([string]$processName = $Args[0] )
  get-nettcpconnection | select local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | ? {$_.process -match $processName } | Sort-Object -Property process | ft -GroupBy process
 }


function prof-edit() {
    C:\Software\npp.8.5.8.portable.x64\notepad++.exe $profile
}

function findall () {
    gci -recurse -erroraction silentlycontinue $1
}

function get-latest-logs () {
	Get-EventLog -LogName System -After $((get-date).addminutes(-30)) -before $(get-date)
}

function qref () { 
write-host "get-eventlog -list  # show all logname options on host"
}


function lsints {
	#gets interface index
	netsh interface ipv4 show int
}

function pktcap () {
	#pktmon start --etw -c [ifaceid]
	#pktmonstop
	#pktmon etl2pcap [etlfile] -out [pcapfile].pcap
}
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


function le2 {
	#doesn't work with a single line for some reaosn.
	$ec2bois = aws ec2 describe-instances --query 'Reservations[*].Instances[*]' | ConvertFrom-Json 
	$ec2bois | %  { $_ | select InstanceID, @{Name = "Tag Values"; Expression = { $_.tags.value }}, @{Name = "State"; Expression = { $_.State.Name}} , VpcId, SubnetID, PublicIpAddress, PrivateIpAddress}  | ft -AutoSize
}


function e2stopall {
	#doesn't work with a single line for some reaosn.
	$ec2bois = aws ec2 describe-instances --query 'Reservations[*].Instances[*]' | ConvertFrom-Json 
	$ec2bois | % { aws ec2 stop-instances --instance-id $_.InstanceID }
}

function e2startall {
	#doesn't work with a single line for some reaosn.
	$ec2bois = aws ec2 describe-instances --query 'Reservations[*].Instances[*]' | ConvertFrom-Json 
	$ec2bois | % { aws ec2 start-instances --instance-id $_.InstanceID }
}



<#
aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped" --query "Reservations[*].Instances[*].InstanceId" --output text
aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped" --query "Reservations[*].Instances[*].InstanceId" --output text | aws ec2 start-instances --instance-ids


#>

function lvpc {
	#doesn't work with a single line for some reaosn.
	$vpcs = aws ec2 describe-vpcs --query 'Vpcs[*]' | ConvertFrom-Json 
	$vpcs | %  { $_ | select VpcId, @{Name = "Canonical Name"; Expression = { $_.tags.value }}, CidrBlock, @{Name = "v6-CidrBlock"; Expression = { $_.Ipv6CidrBlockAssociationSet.Ipv6CidrBlock}}}  | ft -AutoSize
}
<#
VPC DATA STRUCTURE
{
    "Vpcs": [
        {
            "CidrBlock": "10.0.0.0/20",
            "DhcpOptionsId": "dopt-0efe5ac2bf5f8dbed",
            "State": "available",
            "VpcId": "vpc-0fc1a25144526a8fd",
            "OwnerId": "567480080318",
            "InstanceTenancy": "default",
            "Ipv6CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-0a33a53f0dcee3c0f",
                    "Ipv6CidrBlockState": {
                        "State": "associated"
                    },
                    "NetworkBorderGroup": "us-east-1",
                    "Ipv6Pool": "Amazon"
                }
            ],
            "CidrBlockAssociationSet": [
                {
                    "AssociationId": "vpc-cidr-assoc-092f705c27b95b54b",
                    "CidrBlock": "10.0.0.0/20",
                    "CidrBlockState": {
                        "State": "associated"
                    }
                }
            ],
            "IsDefault": false,
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "FishVPC02"
                }
            ]
        }
    ]
}
#> 



function lsubnets {
	#doesn't work with a single line for some reaosn.
	$subnets = aws ec2 describe-subnets --query 'Subnets[*]' | ConvertFrom-Json 
	$subnets | %  { $_ | select SubnetId, @{Name = "Canonical Name"; Expression = { $_.tags.value }}, AvailabilityZone, AvailabilityZoneId, CidrBlock, @{Name = "v6-CidrBlock"; Expression = { $_.Ipv6CidrBlockAssociationSet.Ipv6CidrBlock}}}  | ft -AutoSize
} 

<# subnet data STRUCTURE
{
    "Subnets": [
        {
            "AvailabilityZone": "us-east-1b",
            "AvailabilityZoneId": "use1-az6",
            "AvailableIpAddressCount": 250,
            "CidrBlock": "10.0.0.0/24",
            "DefaultForAz": false,
            "MapPublicIpOnLaunch": true,
            "MapCustomerOwnedIpOnLaunch": false,
            "State": "available",
            "SubnetId": "subnet-07cfb3d026b060256",
            "VpcId": "vpc-0fc1a25144526a8fd",
            "OwnerId": "567480080318",
            "AssignIpv6AddressOnCreation": true,
            "Ipv6CidrBlockAssociationSet": [
                {
                    "AssociationId": "subnet-cidr-assoc-04443e748489faf39",
                    "Ipv6CidrBlock": "2600:1f18:20e7:9e01::/64",
                    "Ipv6CidrBlockState": {
                        "State": "associated"
                    }
                },
                {
                    "AssociationId": "subnet-cidr-assoc-038707c1cc67c7496",
                    "Ipv6CidrBlock": "2600:1f18:20e7:9e00::/56",
                    "Ipv6CidrBlockState": {
                        "State": "disassociated"
                    }
                },
                {
                    "AssociationId": "subnet-cidr-assoc-0f98d4aee975c8d4b",
                    "Ipv6CidrBlock": "2600:1f18:20e7:9e00::/56",
                    "Ipv6CidrBlockState": {
                        "State": "disassociated"
                    }
                }
            ],
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "Pub0"
                }
            ],
            "SubnetArn": "arn:aws:ec2:us-east-1:567480080318:subnet/subnet-07cfb3d026b060256",
            "EnableDns64": false,
            "Ipv6Native": false,
            "PrivateDnsNameOptionsOnLaunch": {
                "HostnameType": "ip-name",
                "EnableResourceNameDnsARecord": false,
                "EnableResourceNameDnsAAAARecord": false
            }
        }
#>		

<#
aws ec2 describe-network-acls
VpcId
tags.value
            "Associations": [
                {
                    "NetworkAclAssociationId": "aclassoc-0b6a3118b27e9be16",
                    "NetworkAclId": "acl-0c4f66dc602404f6e",
                    "SubnetId": "subnet-04238dbd11b7701bd"
            "Entries": [
                {
                    "CidrBlock": "0.0.0.0/0",
                    "Egress": true,
                    "Protocol": "-1",
                    "RuleAction": "allow",
                    "RuleNumber": 100
					
					
describe-security-groups
{
    "SecurityGroups": [
	{
            "Description": "default VPC security group",
            "GroupName": "default",
            "IpPermissions": [
                {
                    "IpProtocol": "-1",
                    "IpRanges": [],
                    "Ipv6Ranges": [],
                    "PrefixListIds": [],
                    "UserIdGroupPairs": [
                        {
                            "GroupId": "sg-0ab4c092221bc9510",
                            "UserId": "567480080318"
                        }
                    ]
                }
            ],
            "OwnerId": "567480080318",
            "GroupId": "sg-0ab4c092221bc9510",
            "IpPermissionsEgress": [
                {
                    "IpProtocol": "-1",
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": [],
                    "UserIdGroupPairs": []
                }
            ],
            "VpcId": "vpc-0fc1a25144526a8fd"
        }
		
{
    "RouteTables": [
        {
            "Associations": [
                {
                    "Main": true,
                    "RouteTableAssociationId": "rtbassoc-0423ee481839d5c2e",
                    "RouteTableId": "rtb-0ac24904863dfd6a0",
                    "AssociationState": {
                        "State": "associated"
                    }
                }
            ],
            "PropagatingVgws": [],
            "RouteTableId": "rtb-0ac24904863dfd6a0",
            "Routes": [
                {
                    "DestinationCidrBlock": "10.0.0.0/20",
                    "Origin": "CreateRoute",
                    "State": "active",
                    "VpcPeeringConnectionId": "pcx-04b5b6538b79efc98"
                },
                {
                    "DestinationCidrBlock": "172.31.0.0/16",
                    "GatewayId": "local",
                    "Origin": "CreateRouteTable",
                    "State": "active"
                },
                {
                    "DestinationCidrBlock": "0.0.0.0/0",
                    "GatewayId": "igw-00c71f67d303dd535",
                    "Origin": "CreateRoute",
                    "State": "active"
                }
            ],
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "Dflt_Main"
                }
            ],
            "VpcId": "vpc-02120e0add7e3a4ad",
            "OwnerId": "567480080318"
        },

#>