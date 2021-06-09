#Import CSV
$ADGroupNames = Import-Csv  -Path "C:\Temp\Solarwinds_Groups1.csv"
Foreach ($ADGroupName in $ADGroupNames)
{
#Create Group
New-ADGroup -Name $ADGroupName.NewGroup -SamAccountName $ADGroupName.NewGroup -GroupScope Universal -DisplayName $ADGroupName.NewGroup -Path "OU=Solarwinds,OU=Apps,OU=Groups,OU=MSU Campus,DC=campusad,DC=msu,DC=edu" -OtherAttributes @{'extensionAttribute7'= 'SPManaged'}

#Get list of members from old AD groups, apply those users to the new groups associated with them
Add-ADGroupMember -Identity $ADGroupName.NewGroup -Members (Get-ADGroupMember -Identity $ADGroupName.CurrentGroup -Recursive)
}
