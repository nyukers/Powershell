# Отправляем HTTP запросы скриптом
# нам нужно отправить POST запрос на веб сайт в формате JSON.

#В качестве модели данных делаем новый класс
class DataModel {
    $Data
    $TimeStamp
}
 
#Создаем экземляр класса
$i = [DataModel]::new()
 
#Заполняем данные
$i.Data = "My Message in string"
$i.TimeStamp = Get-Date

# Так выглядит экземпляр класса после заполнения:

$i
 
# Потом этот экземпляр можно конвертировать в XML или JSON или даже SQL запрос. Остановимся на JSON:

#Конвертируем данные в JSON
$Request = $i | ConvertTo-Json

# Так выглядит JSON после его конвертации:

$Request
{
  "Data": "My Message in string",
  "TimeStamp": "2020-07-30T05:51:56.6588729+03:00"
}

# И отправляем:

#Отправляем JSON
Invoke-WebRequest localhost -Body $Request -Method Post -UseBasicParsing

# В случае если нужно отправлять один и тот же JSON файл 24/7, можно сохранить его как файл и отправлять уже из файла. К примеру, возьмем этот же самый $Request.

#Сохраняем данные конвертированные ранее в JSON в файл
$Request | Set-Content F:\YourRequest.json
 
#Отправляем ранее сохраненный в файл JSON
Invoke-WebRequest localhost -Body (Get-Content F:\YourRequest.json) -Method Post -UseBasicParsing


# Получаем HTTP запросы

#Создаем новый экземпляр класса
$http = [System.Net.HttpListener]::new()
 
#Добавляем HTTP префиксы. Их может быть сколько угодно
$http.Prefixes.Add("http://localhost/")
$http.Prefixes.Add("http://127.0.0.1/")


#Запускаем веб листенер
$http.Start()
 
if ($http.IsListening) {
    Write-Host "Скрипт запущен"
}
 
while ($http.IsListening) {
 
    #GetContext нужен для получения сырых данных из HttpListener
    $context = $http.GetContext()
 
    #Определяем тип запроса с помощью Request.HttpMethod 
    if ($context.Request.HttpMethod -eq 'POST') {
 
        #Читаем сырые данные из GetContext
        #Для каждого отдельного запроса создаем свой конвейер
        [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd() | ForEach-Object {
            
            #С помощью System.Web.HttpUtility делаем urlDecore, иначе кириллица превращается в руны
            $DecodedContent = [System.Web.HttpUtility]::UrlDecode($_)
 
            #Конвертируем прилетевшие данные в нужный нам формат
            $ConvertedForm = $DecodedContent | ConvertFrom-Json -ErrorAction SilentlyContinue
 
            #Cконвертированные данные отображаем таблицей
            $ConvertedForm | Format-Table
           
        }
 
        #Отвечаем клиенту 200 OK и закрываем стрим.
        $context.Response.Headers.Add("Content-Type", "text/plain")
        $context.Response.StatusCode = 200
        $ResponseBuffer = [System.Text.Encoding]::UTF8.GetBytes("")
        $context.Response.ContentLength64 = $ResponseBuffer.Length
        $context.Response.OutputStream.Write($ResponseBuffer, 0, $ResponseBuffer.Length)
        $context.Response.Close()
 
    }
    #Cконвертированные данные отображаем таблицей
    $http.Close()
    break
}