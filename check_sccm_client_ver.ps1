$SCCMver=(Get-WMIObject -Namespace root\ccm -Class SMS_Clicom).ClicomVersion
if ( $SCCMver -eq "5.00.8853.1006")
{
exit
} # if
else 
{
\\forza.com\SysVol\forza.com\Policies\'{94C5637A-E4D2-4EE3-9FBA-27D659261622}'\Machine\Scripts\Startup\Clicom\ccmsetup.exe SMSSITECODE=UE2
}#else
