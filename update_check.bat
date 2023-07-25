@echo off
echo SUMMER UPDATES CHECKER MADE BY JAMES HENDERSON 2023
::check if a folder contains text "backup"
echo -----------------
dir C:\Users /B /O-D | find /i "backup" > nul
if errorlevel 1 (
	color c
	SET "backedup=false"
	echo is not backed up %backedup% 
)
dir C:\Users /B /O-D | find /i "backup" > nul
if not errorlevel 1 (
	SET "backedup=true"
	echo is backed up %backedup%
)

echo -----------------

::check if windows verison is 19045
::ver | findstr /I "19045"
ver | find /i "19045" > nul
if not errorlevel 1 (
	SET "updated=true"
   	echo 22H2
	control update
)

ver | find /i "19044" > nul
if not errorlevel 1 (
	color c
	SET "updated=false"
   	echo Not 22H2
	start U:\.Updates\Laptop_UpdateScript.bat
)

echo -----------------

::check for FortiClient VPN
dir "C:\Program Files" /B /O-D | find /i "Fortinet" > nul
if errorlevel 1 (
	color c
	SET "vpn=false"
	echo Fortinet is not installed 
)
dir "C:\Program Files" /B /O-D | find /i "Fortinet" > nul
if not errorlevel 1 (
	SET "vpn=true"
	echo Fortinet is installed
	cd /D C:/
	::cd C:\Program Files\Fortinet\FortiClient
	cd "C:\Program Files\Fortinet\FortiClient" & FortiClientConsole.exe > nul
)

echo -----------------

::check for FortiClient VPN
dir "C:\Program Files\Google" /B /O-D | find /i "Drive File Stream" > nul
if errorlevel 1 (
	color c
	SET "gdrive=false"
	echo Gdrive is not installed 
	cd /D U:\ > nul
	start GoogleDriveSetup.exe
	::xcopy "%cd%\Creative_Cloud_Set-Up.exe" "C:\Users\badmin\Downloads" > nul
	::start C:\Users\badmin\Downloads\Creative_Cloud_Set-Up.exe

)
dir "C:\Program Files\Google" /B /O-D | find /i "Drive File Stream" > nul
if not errorlevel 1 (
	SET "gdrive=true"
	echo Gdrive is installed
)


echo -----------------

::check for Adobe CC
dir "C:\Program Files\Adobe" /B /O-D | find /i "Adobe Creative Cloud Experience" > nul
if errorlevel 1 (

	color c
	SET "cc=false"
	echo Adobe Creative Cloud is not installed
	cd /D U:\ > nul
	start creative_cloud_script.bat
	::xcopy "%cd%\Creative_Cloud_Set-Up.exe" "C:\Users\badmin\Downloads" > nul
	::start C:\Users\badmin\Downloads\Creative_Cloud_Set-Up.exe
)
dir "C:\Program Files\Adobe" /B /O-D | find /i "Adobe Creative Cloud Experience" > nul
if not errorlevel 1 (
	SET "cc=true"
	echo Adobe Creative Cloud is installed
	appwiz.cpl  > nul
)

echo -----------------

if %backedup%==true if %updated%==true if %vpn%==true if %cc%==true if %gdrive%==true (
color a
cmd /c "wmic computersystem get name > U:\.Updates\2023completed\%computername%.txt"
cmd /c "wmic bios get serialnumber >> U:\.Updates\2023completed\%computername%.txt"
cmd /c "wmic csproduct get vendor, version >> U:\.Updates\2023completed\%computername%.txt"
echo SUCCESS
)
pause