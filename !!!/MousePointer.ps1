# Load necessary assembly for SendKeys
Add-Type -AssemblyName System.Windows.Forms

# Function to get the current mouse position
function Get-MousePosition {
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class Win32 {
            [StructLayout(LayoutKind.Sequential)]
            public struct POINT {
                public int X;
                public int Y;
            }
            [DllImport("user32.dll")]
            public static extern bool GetCursorPos(out POINT pt);
        }
"@
    $pt = New-Object Win32+POINT
    [Win32]::GetCursorPos([ref]$pt)
    return $pt
}

# Initial mouse position
$previousPosition = Get-MousePosition
$lastMovementTime = Get-Date

while ($true) {
    Start-Sleep -Milliseconds 100  # Polling interval (adjust as needed)
    $currentPosition = Get-MousePosition

    if ($currentPosition.X -ne $previousPosition.X -or $currentPosition.Y -ne $previousPosition.Y) {
        # Mouse has moved
        if (((Get-Date) - $lastMovementTime).TotalSeconds -ge 10) {
            # Send SPACE only once
            [System.Windows.Forms.SendKeys]::SendWait("+")
        }
        # Update the last movement time to current time
        $lastMovementTime = Get-Date
    }

    # Update the previous position
    $previousPosition = $currentPosition
}



 7676 767 86ллоо 
 оллол олоол