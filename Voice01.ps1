
Add-Type -AssemblyName System.Speech
$voice = New-Object System.Speech.Synthesis.SpeechSynthesizer
$voice.GetInstalledVoices().VoiceInfo

$voice.Speak("Рио-де-Жанейро — хрустальная мечта моего детства, не трогайте ее руками!")