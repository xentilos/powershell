<#
execute: mysql_query.ps1 -Query "select * from table"
#>
Param(
  [Parameter(
  Mandatory = $true,
  ParameterSetName = '',
  ValueFromPipeline = $true)]
  [string]$Query
  )
$MySQLAdminUserName = 'login'
$MySQLAdminPassword = 'pwd'
$MySQLDatabase = 'schema'
$MySQLHost = 'server'
$ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $MySQLAdminPassword + ";database="+$MySQLDatabase + ";SslMode=none;Convert Zero Datetime=True"
Try {
  [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
  $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
  $Connection.ConnectionString = $ConnectionString
  $Connection.Open()
  $Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
  $DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
  $DataSet = New-Object System.Data.DataSet
  $RecordCount = $dataAdapter.Fill($dataSet, "data")
  $DataSet.Tables[0]
  }
Catch {
  Write-Host "ERROR : Unable to run query : $query `n$Error[0]"
 }
Finally {
  $Connection.Close()
  }

  $error.clear()