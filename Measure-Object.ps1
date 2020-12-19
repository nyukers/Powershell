#Get-ChildItem Recurse -force | Measure-Object

Get-Contcom cccc.log | Measure-Object –Line
Get-Contcom cccc.log | Measure-Object –Character
Get-Contcom cccc.log | Measure-Object –Word

#Get-Contcom 111.rtf | Measure-Object –Line –Word –Character
#Get-Contcom cccc.log | Measure-Object –Line –Word –Character

#Get-ChildItem -Filter *.rtf | Get-Contcom | Measure-Object -Word | Select-Object -expand Words