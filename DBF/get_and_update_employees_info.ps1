<#
script to export users informations from Data Base File(DBF) and update users accounts in AD
#>
Import-Module ActiveDirectory
$tab = @()
$tempcsv = "C:\temp\users_list.csv"
$dbfloc = "C:\temp\DB.DBF"
$email = "@email.com"
if (test-path $tempcsv) {
    Remove-Item –path $tempcsv -Force
}
cmd /c 'C:\temp\DBF2CSV.exe '$dbfloc' '$tempcsv' /P /E Windows-1250'
import-csv $tempcsv -Encoding OEM | foreach {
    if (!($_.nazwisko -like ".*") -and !($_.nazwisko -like ",*")) {
        $ourObject = [PSCustomObject]@{
            Nazwisko = $_.nazwisko.trim()
            Imie = $_.imie.trim()
            Miejscowosc = $_.miejsc.trim()
            Ulica = $_.ul.trim()
            Poczta = $_.kodpo.trim()
        }
        $tab += $ourObject
    }
}
#save a copy
$tab | export-csv C:\temp\users.csv -NoTypeInformation -Delimiter ";" -Encoding UTF8
$tab | foreach {
    $i = $_.imie
    $n = $_.nazwisko
    $checkuser = get-aduser -Filter{GivenName -eq $i -and Surname -eq $n} -Properties *
    if ($checkuser) {
        Write-Host "exist"
        $city = $_.Miejscowosc
        $ulica = $_.ulica
        $poczta = $_.poczta
        if($checkuser.EmailAddress -eq $null) {
            $newemail = ""
            $newemail = $checkuser.GivenName +"."+ $checkuser.Surname +"$email"
            $newemail
            get-aduser -Filter{GivenName -eq $i -and Surname -eq $n} |Set-ADUser -City $city -StreetAddress $ulica -POBox $poczta -EmailAddress $newemail
        } else {
            get-aduser -Filter{GivenName -eq $i -and Surname -eq $n} |Set-ADUser -City $city -StreetAddress $ulica -POBox $poczta
        }
    }
}