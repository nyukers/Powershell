$ollamaUrl = "http://192.168.1.162:11434"
$logFile = "C:\TMP\Ollama_Chat.txt"
$history = @()

# Функція отримання списку доступних моделей
function Get-Models {
    try {
        $modelsResponse = Invoke-RestMethod -Uri "$ollamaUrl/api/tags" -Method Get
        return $modelsResponse.models.name
    }
    catch {
        Write-Host "Помилка отримання списку моделей: $_"
        return @()
    }
}

# Функція вибору моделі
function Select-Model {
    $models = Get-Models
    if ($models.Count -eq 0) {
        Write-Host "Немає доступних моделей."
        exit
    }

    Write-Host "`nДоступні моделі Ollama:"
    for ($i = 0; $i -lt $models.Count; $i++) {
        Write-Host "$($i + 1). $($models[$i])"
    }

    do {
        $choice = Read-Host "Введіть номер моделі"
        if ($choice -match "^\d+$" -and [int]$choice -ge 1 -and [int]$choice -le $models.Count) {
            return $models[[int]$choice - 1]
        }
        Write-Host "Некоректний вибір, спробуйте ще раз."
    } while ($true)
}

# Вибір початкової моделі
$model = Select-Model
Write-Host "`nВибрано модель: $model"

Write-Host "`nВведіть 'exit' для завершення діалогу або 'change' для вибору іншої моделі."

do {
    $userInput = Read-Host "QUERY"

    if ($userInput -eq "exit") {
        Write-Host "`nДіалог завершено. Історію збережено у $logFile"
        break
    }

    if ($userInput -eq "change") {
        $model = Select-Model
        Write-Host "`nМодель змінено на: $model"
        continue
    }

    # Додаємо введене користувачем повідомлення у історію
    $history += @{role="QUERY"; message=$userInput}
    
    $body = @{
    model = $model
    prompt = $userInput
    temperature = 0.7
    max_tokens = 250
    stream = $false
} | ConvertTo-Json -Depth 10
     

    try {

    $response = Invoke-RestMethod -Uri "$ollamaUrl/api/generate" -Method Post -Body $body -ContentType "application/json"

# Перевірка на порожність
if ($response.Content) {
    $responseJson = $response.Content | ConvertFrom-Json
    Write-Host "`n---- Повна відповідь сервера ----"
    Write-Host ($responseJson | ConvertTo-Json -Depth 10)
    Write-Host "----------------------------"
    $responseJson
} else {
    Write-Host "Відповідь сервера порожня."
}


        # Додаємо відповідь Ollama у історію
        $history += @{role="ANSWER"; message=$response.response}

        # Виводимо діалог
        Write-Host "`n----- Історія діалогу -----"
        foreach ($msg in $history) {
            Write-Host "$($msg.role): $($msg.message)`n"
        }
    }
    catch {
        Write-Host "Помилка запиту: $_"
    }
} while ($true)

# Збереження історії у файл
$historyText = ""
foreach ($msg in $history) {
    $historyText += "$($msg.role): $($msg.message)`r`n"
}

# Якщо файл існує, завантажуємо історію з нього
if (Test-Path $logFile) {
    $history = Get-Content $logFile -Encoding UTF8
} else {
    $history = @()  # Якщо файл не існує, ініціалізуємо порожній масив
}
# Отримуємо поточну дату та час
$currentDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$history += $currentDate,":" 
$history += $historyText
$history | Out-File -FilePath $logFile -Encoding UTF8
