#schemas to backup
$db = @("schema1","schema2")
#mysql server ip/dns
$server = "mysqlserver"
#backup location
$storeloc= "c:\MySql_dumps\"
#mysqldump.exe location
$exe = "mysqldump.exe"
#how long keep previous dumps
$days = "-7"
$cdate = (get-date).tostring("yyyy-MM-dd")

$deldate = (get-date $cdate).AddDays($days).ToString("yyyy-MM-dd")
foreach ($d in $db) {
    $d
    $out = $cdate+"-"+$d
    $delfile = $deldate+"-"+$d
	#provide port, login and password
	#there is no space between switch "-p" and password
    cmd /c "$exe --host $server -P 3306 -u mysqllogin -pMyPassword $d > $storeloc\$out.sql"
    Remove-Item "$storeloc\$delfile.sql"
}
