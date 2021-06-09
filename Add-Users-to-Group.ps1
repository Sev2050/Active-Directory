#Import CSV
$Users = Import-Csv  -Path "C:\Users\sec.whitet10\Desktop\LandscapeServices-40001052-User.csv"

Foreach ($User in $Users)
  {
      #Get Group
      $ADGroupName = Get-ADGroup -Identity MSU.SG.SDM.ArcGISEnterprise.Org.IPF.CS.LS.Users

     #Get User
     $ADUser = Get-ADUser -Identity $User.Username

     #Get list of members from old AD groups, apply those users to the new groups associated with them
     Add-ADGroupMember -Identity $ADGroupName -Members $ADUser
}
