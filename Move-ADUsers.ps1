$OU1 = "Dept"
$OU2 = "New_Name_Dept"


$OUInfo1 = Get-ADOrganizationalUnit "OU=Users,OU=AdminSV,DC=campusad,DC=msu,DC=edu"
$OUInfo2 = Get-ADOrganizationalUnit "OU=Resources,OU=EVPA,DC=campusad,DC=msu,DC=edu"
$ADUsers = Get-ADUser -SearchBase $OUInfo1 -Filter * -Properties ProxyAddresses,mail,Department,displayName
$Department = "Office of the Executive Vice President for Administration"

Foreach ($ADUser in $ADUsers)
{


    #Setting variable for correcting the Common Name so that the Distinguished Name will reflect changes
    $CorrectedName = $ADUser.Name.Replace($OU1,$OU2)


    #Setting to variable for removing old OU name from UserPrincipalName
    $CorrectedSamAccountName = $ADUser.SamAccountName.Replace($OU1,$OU2)

    #Setting to variable for removing old OU name from UserPrincipalName
    $CorrectedDisplayName = $ADUser.DisplayName.Replace($OU1,$OU2)

    #Set new email address
    $CorrectEmailAddress = $ADUser.mail.Replace($OU1,$Ou2)
   
    #Rename the AD User
    Set-ADUser -Identity $ADUser -DisplayName $CorrectedDisplayName -SamAccountName $CorrectedSamAccountName -EmailAddress $CorrectEmailAddress -add @{ProxyAddresses="smtp:$CorrectEmailAddress"} -Department $Department

    #Removing from the account for the Common Name
    $NewName = $ADUser | Rename-ADObject -NewName $CorrectedName -PassThru

    #Note of accounts being modified
    $OutputCorrectedAccounts += $NewName.Name

    Start-Sleep -Second 1

    #Move AD User Object
    Move-ADObject -Identity $NewName -TargetPath $OUInfo2

}

