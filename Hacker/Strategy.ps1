﻿Изобретение стратегии

Прежде чем запускать в этом сервере хотя бы одну команду, чтобы избежать множества расставленных вокруг нас ловушек, благодаря различным представленным Microsoft в WMF 5 (встроенным в Windows 10 и Windows Server 2016) 
для противодействия взрыва атак на основе сценариев новым методам, нам необходимо разработать рабочую стратегию. Эти методы включают в себя:

- Constrained Language mode (Режим с Ограничением языка) Запрещает ряд специальных типов и объектов и функций .NET, как мы это наблюдали выше: Add-Type, New-Object, таких классов .NET [console] и многого иного.

- System-wide transcript (Стенограмма по всей системе) Регистрирует вводимый в консоли PowerShell текст, а также вывод команд. Это практика, которая должна быть за плечами синей команды.

- Script Block Logging (Регистрация Блоков сценариев) Регистрирует все команды или сценарии PowerShell в не зашифрованном, не запутанном формате в диспетчере событий с идентификатором события 4101. 
Это устраняет классический обход, основанный на полезных нагрузках в кодировке base64, с применением флага -EncodedCommand PowerShell. Такие журналы, среди прочего, вероятно, подпитывают механизм обнаружения QRadar.

- Antimalware Scan Interface (AMSI) filter (Фильтр интерфейса санирования защиты от вредоносного ПО) Перехватывает все команды или файлы, исполняемые при помощи обычных обработчиков сценариев, таких как JavaScript, 
PowerShell и VBScript. Антивирус может подключаться к AMSI и принимать решение блокировать команду или нет. Это переносит антивирусные программы в область сканирования или защиты памяти, 
поскольку AMSI работает на уровне ядра вне зависимости от происхождения такой команды, причём будь то сценарий на диске или команда в памяти.