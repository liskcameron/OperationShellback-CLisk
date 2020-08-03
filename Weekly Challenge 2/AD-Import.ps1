#Active Directory PowerShell module needed to run AD cmdlets.
Import-Module ActiveDirectory

#Specify path of csv.
$csv = Import-CSV -Path C:\CSVs\Users.csv

#Specify OU.
$OU='OU=Users,OU=WoW Users,DC=worldofwarcraft,DC=com'

#For each param defined for "New-ADUSER" cmdlet
foreach($UserParam in $csv){
    
    $newUser=@{
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

    #Trys to execute New-ADUser with the above parameters.
    Try{
        New-ADUser @newUser -ErrorAction Stop 
        Write-Host "User $($UserParam.SamAccountName) created!" -ForegroundColor green
       }

    #If the New-ADUser cmdlets fails this catch block will tell you.
    Catch{
        Write-Host "Could not create AD User $($UserParam.SamAccountName)." -ForegroundColor Red
    }
}