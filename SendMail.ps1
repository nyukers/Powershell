$mailcred = Get-Credcomial
#Send-MailMessage -To "Admin.EA@foxa.com" -From "Admin.EA@foxa.com" -Subject "Test mail" -Credcomial $mailcred -SmtpServer webmail.foxa.com


Send-MailMessage -To "Admin.EA@foxa.com" -From "zabbix@rcm.foxa.com" -SmtpServer rcm.foxa.com `
-Attachmcoms D:\111.pdf -Subject "Test mail attach" -Body "my body mail" 




