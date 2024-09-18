Import-Module ActiveDirectory


$groups = Import-Csv C:\Users\Administrator\Documents\security_group.csv

    foreach ($group in $groups) {

    $groupProps = @{

      Name          = $group.name
      Path          = $group.path
      GroupScope    = $group.scope
      GroupCategory = $group.category
      Description   = $group.description

      }

    New-ADGroup @groupProps
    
}