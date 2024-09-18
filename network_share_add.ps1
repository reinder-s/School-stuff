$NetworkShare = Import-csv C:\Users\Administrator\Documents\network_share.csv

$NetworkShare | ForEach-Object {
	$Group = $_.'GroupName'
	
	New-SmbShare -Name $Group -Path D:\Data\$Group -FullAccess "Users"
	
	$acl = Get-Acl \\DC01.powershell.dc\$Group\
	$acl.SetAccessRuleProtection($true,$false)
	$acl | Set-Acl \\DC01.powershell.dc\$Group\
	
	$acl = Get-Acl \\DC01.powershell.dc\$Group\
	$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","FullControl","Allow")
	$acl.RemoveAccessRule($AccessRule)
	$acl | Set-Acl \\DC01.powershell.dc\$Group\
	
	$acl = Get-Acl \\DC01.powershell.dc\$Group\
	$usersid = New-Object System.Security.Principal.Ntaccount ("Users")
	$acl.PurgeAccessRules($usersid)
	$acl | Set-Acl \\DC01.powershell.dc\$Group\
	
	$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$Group","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
	$acl.SetAccessRule($AccessRule)
	$acl | Set-Acl \\DC01.powershell.dc\$Group\
	
	Grant-SmbShareAccess -Name $Group -AccountName "Users" -AccessRight Change

}