Add-Type -assembly System.Windows.Forms

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='CmRcViewer GUI'
$main_form.Width = 300
$main_form.Height = 200
$main_form.AutoSize = $true

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Hostname or IP:"
$Label.Location  = New-Object System.Drawing.Point(0,10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

$button = New-Object System.Windows.Forms.Button
$button.Text = 'Go'
$button.Location = New-Object System.Drawing.Point(160,70)
$main_form.Controls.Add($button)

$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Location  = New-Object System.Drawing.Point(160,10)
$TextBox.Text = ''
$main_form.Controls.Add($TextBox)

$button.Add_Click({
if($TextBox.Text){
    $compName = ($textBox.Text).Trim()
    $Label1 = New-Object System.Windows.Forms.Label
    $Label1.Text = $compName
    $Label1.Location  = New-Object System.Drawing.Point(10,30)
    $Label1.AutoSize = $true
    $main_form.Controls.Add($Label1)
                }
})

$main_form.ShowDialog()

##################

$FormComboBox = New-Object System.Windows.Forms.ComboBox
$FormComboBox.Width = 250
$Users = Get-ADUser -filter * -Properties SamAccountName

Foreach ($User in $Users)
{
$FormComboBox.Items.Add($User.SamAccountName);
}
$FormComboBox.Location = New-Object System.Drawing.Point(60,10)
$window_form.Controls.Add($FormComboBox)

$FormButton.Add_Click(
{
$FormLabel3.Text = [datetime]::FromFileTime((Get-ADUser -identity $FormComboBox.selectedItem -Properties pwdLastSet).pwdLastSet).ToString('dd mm yy : hh ss')
}
)