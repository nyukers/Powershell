$Date = Get-Date
$Date | Select *

$Date | Get-Member -MemberType Method

Get-Date -Year 2017 -Month 12 -Day 06 -Hour 18 -Minute 55 -Second 0

$param = @{
'Year'=2017;
'Month'=12;
'Day'=6;
'Hour'=18;
'Minute'=55;
'Second'=0
}
Get-Date @param

[CultureInfo]::CurrcomCulture
[CultureInfo]::GetCultureInfo('en-US')

(Get-Date) -lt (Get-Date).AddSeconds(1)

 1..3 | % {[DateTime]::new(2017, 12, 06, 18, 55, $_)} | Sort-Object -Descending

$TimeSpan =  (Get-Date) - (Get-Date).AddDays(-3)
$TimeSpan.GetType()

(Get-Date) + $TimeSpan

(Get-Date).ToString('ddd, dd.MM.yyyy')

#How many days in this month?
[DateTime]::DaysInMonth(2019,11)

#Is it leap year?
[DateTime]::IsLeapYear(2020)

