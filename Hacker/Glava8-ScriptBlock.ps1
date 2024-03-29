﻿ScriptBlock объявляется как общедоступный класс, а потому мы можем напрямую ссылаться на него при помощи объекта [ScriptBlock]. Тем не менее, само содержащее перечень подозрительных строк поле signatures является частным, поэтому мы снова прибегаем к отражению при помощи методов GetField и GetValue (Листинг 8.1).

 
Листинг 8.1. Просмотр строк, определённых в свойстве signatures нашего класса ScriptBlock


PS C:\> [ScriptBlock].GetField('signatures','NonPublic,Static').GetValue($null)

Add-Type
DllImport
DefineDynamicAssembly
DefineDynamicModule
DefineType
--snip--
 	   
Именно эти ключевые слова используются WMF для маркировки опасных команд. Поскольку он проверяет эти подозрительные слова простым сравнением строк, 
мы можем обойти это при помощи некоторых хитроумных приёмов, затрудняющих понимание кода. Исследователь безопасности Дэниел Боханнон проделал потрясающую работу по данному конкретному вопросу, создав инструмент Invoke-Obfuscation для автоматизации запутывания строк — поистине устрашающую демонстрацию творчества и тяжёлой работы.
Мы позаимствуем некоторые из его методов, представленных в его выступлении на конференции Microsoft по безопасности BlueHat Israel 2017.