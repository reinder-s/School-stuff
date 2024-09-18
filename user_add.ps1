Import-Module activedirectory

$Users = Import-csv C:\Users\Administrator\Documents\users.csv

foreach ($User in $Users) {
    
		$userProps = @{
            SamAccountName			= $User.SamAccountName                   
            Path					= $User.path
            GivenName				= $User.GivenName 
            Surname					= $User.Surname
            Name					= $User.Name
            DisplayName				= $User.DisplayName 
            AccountPassword			= (ConvertTo-SecureString $User.Password -AsPlainText -Force) 
            Enabled					= $true
            ChangePasswordAtLogon	= $false
			HomeDirectory			= "\\DC01.powershell.dc\Home$\{0}" -f $User.SamAccountName
			HomeDrive				= "Z:"
        }   

         New-ADUser @userProps

    }
	
$Users | ForEach-Object {
	$GroupName = $_.'GroupName'
	Add-ADGroupMember -Identity $GroupName -Members $_.'SamAccountName'
}

$Users | ForEach-Object {
	$Drive = "\\DC01.powershell.dc\Home$\{0}" -f $_.'SamAccountName'
	$ID = $_.'SamAccountName'
	New-Item -ItemType directory -Path $Drive
	
	$acl = Get-Acl $Drive
	
	$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$ID","FullControl","Allow")
	$acl.SetAccessRule($AccessRule)
	
	$acl | set-acl ($Drive)
}