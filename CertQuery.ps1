#[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("cp866")

function ConvertTo-Encoding ([string]$From, [string]$To){
	Begin{
		$encFrom = [System.Text.Encoding]::GetEncoding($from)
		$encTo = [System.Text.Encoding]::GetEncoding($to)
	}
	Process{
		$bytes = $encTo.GetBytes($_)
		$bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
		$encTo.GetString($bytes)
	}
}


(Get-ChildItem -Path cert: -Recurse -ExpiringInDays 100).subject | ConvertTo-Encoding cp866 windows-1251