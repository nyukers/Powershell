@'
# Bad.ps1
# Файл демонстрации Script Analyzer
#

### Применяем псевдоним
$Procs = gps

### Пользуемся позиционными параметрами
$Services = Get-Service 'foo' 21

### Применяется плохой заголовок функции
Function foo {"Foo"}

### Функция повторно определяет вложение в команде
Function Get-ChildItem {"Sorry Dave I cannot do that"}

### Команда применяет жёстко заданное название компьютера
Test-Connection -ComputerName DC1

### Строка, которая обладает идущими в её конце пробелами
$foobar ="foobar"
### Строка применяет глобальную переменную
$Global:foo
'@ | Out-File -FilePath "C:\Foo\Bad.ps1"