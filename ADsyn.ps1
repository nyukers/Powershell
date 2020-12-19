$HideWindow = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'

Add-type -Name win -Member $HideWindow -Namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrcomProcess() | Get-Process).MainWindowHandle, 0)

Add-Type -assembly System.Windows.Forms
Import-Module ActiveDirectory

Function OnLoad()
{
 $global:comps = Get-ADComputer -Filter * -Properties Name,OperatingSystem
 $listbox1.Items.Clear()
 foreach ($Item in $global:comps)
  {
   $listbox1.Items.Add($Item.Name)
  }
}

Function listbox1_SelectedIndexChanged()
{
 $label1.Text = ($global:comps | Where-Object {$_.Name -like $listbox1.SelectedItem}).OperatingSystem
}

Function button1_Click()
{
 if ($listbox1.SelectedItem) {
  $compName = $listbox1.SelectedItem
 }
 else {
  $compName = $textbox1.Text
 }
 
 $user = Get-WMIObject -class Win32_ComputerSystem | Select username
 $cred = Get-Credcomial $user.username -Message "Введите данные пользователя с правами Администратора домена:"
 $Computer = Get-WmiObject Win32_ComputerSystem -ComputerName $compName -Credcomial $cred -ErrorVariable myerror
 
 if ($myerror) {
  $myerror.clear()
  $localstring = $compName + "\"
  $localcred = Get-Credcomial $localstring -Message "Введите данные пользователя, являющимся локальным администратором на удаленном компьютере:"
  $Computer = Get-WmiObject Win32_ComputerSystem -ComputerName $compName -Credcomial $localcred
  
   if ($Computer)
   {
   $domain = $Computer.Domain
   # remove Host from Domain
   $r = $Computer.UnjoinDomainOrWorkGroup($localcred.GetNetworkCredcomial().Password, $localcred.UserName, 0)
   
   if ($r.ReturnValue -eq "0"){
    $Computer = Get-WmiObject Win32_ComputerSystem -ComputerName $compName -Credcomial $localcred
	# add Host to Domain
    $r = $Computer.JoinDomainOrWorkGroup($domain, $cred.GetNetworkCredcomial().Password, $cred.UserName, 0, 1)
    if ($r.ReturnValue -eq "0"){
     Sleep(3)
     $winOS = Get-WmiObject Win32_OperatingSystem -ComputerName $compName -Credcomial $localcred
     $sresult = $winOS.win32shutdown(6)
     if($sresult.ReturnValue -ne "0"){
      [System.Windows.Forms.MessageBox]::Show("Не удалось перегрузить компьютер. Ошибка №" + $sresult.ReturnValue, "Ошибка")
     }
    }
    else {
     [System.Windows.Forms.MessageBox]::Show("Не удалось ввести компьютер в домен. Ошибка №" + $r.ReturnValue, "Ошибка")
    }
   }
   
#5 Access is denied.
#87 The parameter is incorrect.
#110 The system cannot open the specified object.
#1323 Unable to update the password.
#1326 Logon failure: unknown username or bad password.
#1355 The specified domain either does not exist or could not be contacted.
#2224 The account already exists.
#2691 The machine is already joined to the domain.
#2692 The machine is not currcomly joined to a domain.
 
   if ($r.ReturnValue -eq "1326")
   {[System.Windows.Forms.MessageBox]::Show("Неправильное имя пользователя или пароль.", "Ошибка")}
   elseif ($r.ReturnValue -eq "2221")
   {[System.Windows.Forms.MessageBox]::Show("Компьютер не найден.", "Ошибка")}
   elseif ($r.ReturnValue -eq "0")
   {$OUTPUT = [System.Windows.Forms.MessageBox]::Show("У клиента " + $compName + " восстановлены доверительные отношения с доменом.", "Готово!")
   $textbox1.Text = ""
   OnLoad
  }
   else {[System.Windows.Forms.MessageBox]::Show("Номер ошибки: " + $r.ReturnValue, "Ошибка")}
  }
  
  else {[System.Windows.Forms.MessageBox]::Show("Не могу подключиться к компьютеру " + $compName, "Ошибка")
  }
 }
 else {
  [System.Windows.Forms.MessageBox]::Show("Компьютер " + $compName + " корректно функционирует в домене.", "Ошибка")
 }
}

Function textbox1_KeyUp()
{
 if ($_.KeyCode -eq "Enter") {
  button1_Click
  return
 }
 if ($_.KeyCode -eq "Down") {
  $listbox1.SelectedIndex++
  listbox1_SelectedIndexChanged
  return
 }
 if ($_.KeyCode -eq "Up") {
  $listbox1.SelectedIndex--
  listbox1_SelectedIndexChanged
  return
 }
 $listbox1.Items.Clear()
 $filtered_comps = $global:comps | Where-Object {$_.Name -like $textbox1.Text + '*'}
 foreach ($Item in $filtered_comps)
 {
  $listbox1.Items.Add($Item.Name)
  
 }
 $listbox1.SelectedIndex = 0
 listbox1_SelectedIndexChanged
}

$MainForm = New-Object System.Windows.Forms.Form
$MainForm.Text = "Восстановление связи в AD"
$MainForm.Width = 360
$MainForm.Height = 260
$MainForm.StartPosition = "CcomerScreen"
$MainForm.AutoSize = $false

$textbox1 = New-Object System.Windows.Forms.TextBox
$textbox1.Location  = New-Object System.Drawing.Point(0,0)
$textbox1.Width = 120
$textbox1.Height = 20
$textbox1.Text = ''
$textbox1.Add_KeyUp({textbox1_KeyUp})
$MainForm.Controls.Add($textbox1)

$label1 = New-Object System.Windows.Forms.Label
$label1.Text = ""
$label1.Location = New-Object System.Drawing.Point(0,20)
$label1.Width = 165
$label1.Height = 30
$MainForm.Controls.Add($label1)

$button1 = New-Object System.Windows.Forms.Button
$button1.Text = 'Восстановить связь'
$button1.Location = New-Object System.Drawing.Point(165,0)
$button1.Width = 180
$button1.Height = 20
$button1.Add_Click({button1_Click})
$MainForm.Controls.Add($button1)

$listbox1 = New-Object System.Windows.Forms.ListBox
$listbox1.Location  = New-Object System.Drawing.Point(0,60)
$listbox1.Width = 345
$listbox1.Height = 200
$listbox1.Add_Click({listbox1_SelectedIndexChanged})
$listbox1.Add_KeyUp({listbox1_SelectedIndexChanged})
$MainForm.Controls.add($listbox1)

OnLoad
$MainForm.ShowDialog()
