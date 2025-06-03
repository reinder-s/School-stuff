New-SmbShare -Name "HomeFolders$" -Path "E:\Data\HomeFolders" -FullAccess "Domain Users"
				#change
$acl = Get-Acl \\DC01.powershell.dc\HomeFolders$
$acl.SetAccessRuleProtection($true,$false)
				#change
$acl | Set-Acl \\DC01.powershell.dc\HomeFolders$

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("CREATOR OWNER","FullControl", "ContainerInherit, ObjectInherit", "InheritOnly", "Allow")
$acl.SetAccessRule($AccessRule)

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.SetAccessRule($AccessRule)

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.SetAccessRule($AccessRule)

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","CreateFiles, AppendData, ReadAndExecute, Synchronize", "None", "None", "Allow")
$acl.RemoveAccessRule($AccessRule)
$usersid = New-Object System.Security.Principal.Ntaccount ("Users")
$acl.PurgeAccessRules($usersid)


$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone","Traverse, ListDirectory, ReadData, ReadAttributes, CreateDirectories, AppendData", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.SetAccessRule($AccessRule)
				#change
$acl | Set-Acl \\DC01.powershell.dc\HomeFolders$

