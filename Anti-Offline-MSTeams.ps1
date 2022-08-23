Add-Type -AssemblyName System.Windows.Forms

function setLayout() {
	
	$pshost = get-host
	$pswindow = $pshost.ui.rawui

	$newsize = $pswindow.buffersize
	$newsize.height = 20
	$newsize.width = 37
	$pswindow.buffersize = $newsize

	$newsize = $pswindow.windowsize
	$newsize.height = 5
	$newsize.width = 37
	$pswindow.windowsize = $newsize
}

function checkForKeyPresses($output) {

	if([Console]::KeyAvailable){
			
		$key = $Host.UI.RawUI.ReadKey()
		
		if ($key.Character -eq 'S') {
			
			break
		}elseif($key.Character -eq 'P') {
			
			Clear-Host
			
			Write-Output $output
			
			timeout /t -1
		}
	}
}

function printMessages($output) {
	
	Clear-Host
	
	Write-Output "Press 'S' to skip the timer"
	Write-Output "Press 'P' to pause the timer"
	Write-Output "Press 'Strg + C' to quit"
	Write-Output $output
}

function moveMouse() {
	
	$Pos = [System.Windows.Forms.Cursor]::Position
	$x = ($pos.X % 50) + 10
	$y = ($pos.Y % 50) + 10
	[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
}

function makeThings {
	
	setLayout
	
	$userInput = Read-Host -Prompt "Enter duration in minutes"
	$autoShutdown = Read-Host -Prompt "Autoshutdown after timer? [y/n]"

	$durationInSeconds = [double] $userInput * 60

	while ($counter -ne $durationInSeconds) {
		
		checkForKeyPresses($output)
		
		Write-Output $keyInfo

		[double] $seconds = $durationInSeconds - $counter
		$hours = $seconds / 3600
		$seconds = $seconds % 3600
		$minutes = $seconds / 60
		$seconds = $seconds % 60
		
		$output = "{0}:{1}:{2}" -f [math]::floor($hours), [math]::floor($minutes), [math]::floor($seconds)
		
		printMessages($output)
		
		moveMouse
		
		Start-Sleep -Seconds 1

		$counter++
	}

	if($autoShutdown -eq "y") {
		
		Stop-Computer -ComputerName localhost
	}else{
		
		Clear-Host
		
		makeThings
	}
}

makeThings
