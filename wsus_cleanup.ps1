$data =[datetime]::Today.ToString('MM-dd-yyyy')
$wsus = get-wsusserver | Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates
#log location:
$wsus | Out-File c:\wsus_cleanup\$data.txt -Force