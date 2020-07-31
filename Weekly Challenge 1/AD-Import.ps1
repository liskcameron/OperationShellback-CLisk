Import-Module ActiveDirectory
$csv = Import-CSV -Path C:\CSVs\Users.csv
$OU='OU=Users,OU=WoW Users,DC=worldofwarcraft,DC=com'

foreach($UserParam in $csv){
    
    $newUserID=@{
        GivenName               =$UserParam.firstname
        surName                 =$UserParam.lastname
        Name                    =$UserParam.firstname + " " + $UserParam.lastname
        Initials                =$UserParam.MiddleInitial
        DisplayName             =$UserParam.DisplayName
        Department              =$UserParam.Department
        Title                   =$UserParam.Title
        SamAccountName          =$UserParam.SamAccountName
        #UserPrincipalName       ="$($UserParam.)@worldofwarcraft.com"
        Path                    =$OU
        Enabled                 =$true
        ChangePasswordAtLogon   =$false
        AccountPassword         =(ConvertTo-SecureString $UserParam.Password -AsPlainText -Force)
    }
    Try{
        New-ADUser @newUserID -ErrorAction Stop 
        Write-Host "User $($UserParam.SamAccountName) created!" -ForegroundColor green
       }
    Catch{
        Write-Host "Could not create AD User $($UserParam.SamAccountName)." -ForegroundColor Red
    }
}