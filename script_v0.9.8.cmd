REM ------------------------------------------------------
REM Agilimo Service Script
REM V 0.9.8, 2019-10-02
REM Author: Thorsten Zieleit
REM
REM Licensend under CC BY-SA 4.0 
REM https://creativecommons.org/licenses/by-sa/4.0/
REM Means: Keep this header and mark your changes. Thanks!
REM ------------------------------------------------------

@ECHO off
:start
CLS
set keytool="%JAVA_HOME%"\bin\keytool.exe
set version=V0.9.8 (beta!)
set ass=Agilimo-Service-Skript Version %version%
ECHO Herzlichen Willkommen beim Agilimo-Service-Skript
ECHO %version% von Thorsten Zieleit
ECHO.
ECHO Mithilfe dieses Skripts koennen folgende Taetigkeiten durchgefuehrt werden:
ECHO ---------------------------------------------------------------------------
ECHO 1. Anlegen der Agilimo-Ordner-Struktur
ECHO 2. Alle UEM-Dienste start/stop
ECHO 3. Alle UEM-Dienste auf manuell
ECHO 4. Alle UEM-Dienste auf automatisch
ECHO 5. BEMS Dienst (start/stop/restart)
ECHO 6. BEMS CSR/Keystore-Erzeugung
ECHO 7. VERY BETA! BEMS Zertifikatsinstallation (bemsnew.pfx, JAVA-cacerts)
ECHO 8. Verbindungstest BB NOC
ECHO 9. Abbrechen
ECHO ---------------------------------------------------------------------------
ECHO.
SET /p action=Welche Aktion moechtest Du durchfuehren (1-9)?
IF %action% == 1 GOTO ordner
IF %action% == 2 GOTO uemstartstop
IF %action% == 3 GOTO uemman
IF %action% == 4 GOTO uemauto
IF %action% == 5 GOTO bemsre
REM Bei der bemsdir Deklaration gibt es noch einen Fehler. rootDir wird nicht übernommen!
IF %action% == 6 SET /p rootDirectory=Bitte gib nun das Laufwerk an, in dem die Ordner-Struktur liegt (z.B. C:): && set bemsdir=%rootDirectory%\_BB_Install\Certificates\bems && GOTO bemscsr
IF %action% == 7 SET /p rootDirectory=Bitte gib nun das Laufwerk an, in dem die Ordner-Struktur liegt (z.B. C:): && set bemsdir=%rootDirectory%\_BB_Install\Certificates\bems && GOTO bemscert
IF %action% == 8 SET /p rootDirectory=Bitte gib nun das Laufwerk an, in dem die Ordner-Struktur liegt (z.B. C:): && set bemsdir=%rootDirectory%\_BB_Install\Certificates\bems && GOTO connection
IF %action% == 9 EXIT
ECHO Fehlerhafte Auswahl.
ECHO.
PAUSE
GOTO start

:ordner
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO Gut! Legen wir die Agilimo-Ordnerstruktur an.
ECHO.
SET /p rootDirectory=Auf welchem Laufwerk soll die Ordner-Struktur angelegt werden (z.B. C:, q fuer Abbruch)?
IF "%rootDirectory%" == "q" GOTO start
ECHO.
ECHO OK, demnach legen wir %rootDirectory%\_BB_Install mit den enstprechenden Unterordnern an.
SET /p yesno=Ist das richtig (j/n)?
IF "%yesno%" == "n" GOTO ordner
REM Danke Dennis! ;-)
if not exist %rootDirectory%\_BB_Install mkdir %rootDirectory%\_BB_Install
if not exist %rootDirectory%\_BB_Install\Install_files mkdir %rootDirectory%\_BB_Install\Install_files
if not exist %rootDirectory%\_BB_Install\Scripts mkdir %rootDirectory%\_BB_Install\Scripts
if not exist %rootDirectory%\_BB_Install\Documentation mkdir %rootDirectory%\_BB_Install\Documentation
if not exist %rootDirectory%\_BB_Install\Certificates mkdir %rootDirectory%\_BB_Install\Certificates
ECHO *** Done ***
ECHO.
PAUSE
GOTO start

:uemstartstop
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO Alle Dienste starten oder stoppen! Let's go...
ECHO 1. UEM Dienste starten
ECHO 2. UEM Dienste stoppen
ECHO 3. Abbrechen
ECHO.
set /p action=Was willst Du tun (1-3)?
ECHO.
IF %action% == 1 GOTO uemstart
IF %action% == 2 GOTO uemstop
IF %action% == 3 GOTO start
ECHO Fehlerhafte Auswahl.
ECHO.
PAUSE
GOTO start

:uemstart
ECHO Alle UEM Dienste starten. Machen wir... Hier erstmal die Uebersicht:
ECHO.
ECHO BlackBerry Affinity Manager
sc query "BES12 - BlackBerry Affinity Manager" | findstr STATE
ECHO BlackBerry Dispatcher
sc query "BES12 - BlackBerry Dispatcher" | findstr STATE
ECHO BlackBerry Gatekeeping Service
sc query "BES - BlackBerry Gatekeeping Service" | findstr STATE
ECHO BlackBerry MDS Connection Service
sc query "BES12 - BlackBerry MDS Connection Service" | findstr STATE
ECHO BlackBerry Proxy Service
sc query "BesGPS" | findstr STATE
ECHO BlackBerry Secure Gateway
sc query "BESNG-ASP" | findstr STATE
ECHO UEM Core
sc query "BESNG-Core" | findstr STATE
ECHO BlackBerry Secure Connect Plus
sc query "BESNG-P2E" | findstr STATE
ECHO Management Console
sc query "BESNG-UI" | findstr STATE
ECHO.
SET /p yesno=Kann's losgehen (j/n)?
IF "%yesno%" == "n" GOTO start

net start "BlackBerry UEM - BlackBerry Gatekeeping Service" 2>nul
net start "BlackBerry UEM - BlackBerry Affinity Manager" 2>nul
net start "BlackBerry UEM - BlackBerry Dispatcher" 2>nul
net start "BlackBerry UEM - BlackBerry MDS Connection Service" 2>nul
net start "BlackBerry UEM - BlackBerry Proxy Service" 2>nul
net start "BlackBerry UEM - BlackBerry Secure Gateway" 2>nul
net start "BlackBerry UEM - UEM Core" 2>nul
net start "BlackBerry UEM - BlackBerry Secure Connect Plus" 2>nul
net start "BlackBerry UEM - Management console" 2>nul
ECHO.
ECHO Alle UEM Dienste gestartet!
ECHO.
PAUSE
GOTO start

:uemstop
ECHO Alle UEM Dienste stoppen. Machen wir... Hier erstmal die Übersicht:
ECHO.
ECHO BlackBerry Affinity Manager
sc query "BES12 - BlackBerry Affinity Manager" | findstr STATE
ECHO BlackBerry Dispatcher
sc query "BES12 - BlackBerry Dispatcher" | findstr STATE
ECHO BlackBerry Gatekeeping Service
sc query "BES - BlackBerry Gatekeeping Service" | findstr STATE
ECHO BlackBerry MDS Connection Service
sc query "BES12 - BlackBerry MDS Connection Service" | findstr STATE
ECHO BlackBerry Proxy Service
sc query "BesGPS" | findstr STATE
ECHO BlackBerry Secure Gateway
sc query "BESNG-ASP" | findstr STATE
ECHO UEM Core
sc query "BESNG-Core" | findstr STATE
ECHO BlackBerry Secure Connect Plus
sc query "BESNG-P2E" | findstr STATE
ECHO Management Console
sc query "BESNG-UI" | findstr STATE

SET /p yesno=Kann's losgehen (j/n)?
IF "%yesno%" == "n" GOTO start

net stop "BlackBerry UEM - BlackBerry Gatekeeping Service" 2>nul
net stop "BlackBerry UEM - BlackBerry Affinity Manager" 2>nul
net stop "BlackBerry UEM - BlackBerry Dispatcher" 2>nul
net stop "BlackBerry UEM - BlackBerry MDS Connection Service" 2>nul
net stop "BlackBerry UEM - BlackBerry Proxy Service" 2>nul
net stop "BlackBerry UEM - BlackBerry Secure Gateway" 2>nul
net stop "BlackBerry UEM - UEM Core" 2>nul
net stop "BlackBerry UEM - BlackBerry Secure Connect Plus" 2>nul
net stop "BlackBerry UEM - Management console" 2>nul
ECHO.
ECHO Alle UEM Dienste gestoppt!
ECHO.
PAUSE
GOTO start

:uemman
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO OK, wir wollen die UEM-Dienste auf manuell setzen. Welche haben wir denn laufen:
ECHO.
net start | find /I "BlackBerry"
ECHO.
SET /p yesno=Sollen wir anfangen (j/n)?
IF "%yesno%" == "n" GOTO start

REM Ab hier müsste man das mal mit for /f machen. So ist das unschön.
ECHO Setze die UEM-Dienste auf manuell...
sc config "BES12 - BlackBerry Affinity Manager" start= demand
sc config "BES12 - BlackBerry Dispatcher" start= demand
sc config "BES - BlackBerry Gatekeeping Service" start= demand
sc config "BES12 - BlackBerry MDS Connection Service" start= demand
sc config "BesGPS" start= demand
sc config "BESNG-ASP" start= demand
sc config "BESNG-Core" start= demand
sc config "BESNG-P2E" start= demand
sc config "BESNG-UI" start= demand
ECHO.
ECHO Fertig! Alle UEM DIenste sind jetzt auf manuell.
ECHO.
PAUSE
GOTO start

:uemauto
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO Schoen, wir wollen die UEM-Dienste auf automatisch setzen. Welche haben wir denn laufen:
ECHO.
net start | find /I "BlackBerry"
ECHO.
SET /p yesno=Sollen wir anfangen (j/n)?
IF "%yesno%" == "n" GOTO start

REM Ab hier müsste man das mal mit for /f machen. So ist das unschön.
ECHO Setze die UEM-Dienste auf automatisch...
sc config "BES12 - BlackBerry Affinity Manager" start= auto
sc config "BES12 - BlackBerry Dispatcher" start= auto
sc config "BES - BlackBerry Gatekeeping Service" start= auto
sc config "BES12 - BlackBerry MDS Connection Service" start= auto
sc config "BesGPS" start= auto
sc config "BESNG-ASP" start= auto
sc config "BESNG-Core" start= auto
sc config "BESNG-P2E" start= auto
sc config "BESNG-UI" start= auto
ECHO.
ECHO Fertig! Alle UEM Dienste sind jetzt auf automatisch.
ECHO.
PAUSE
GOTO start

:bemsre
REM nochmal überprüfen, evtl. auch weitere Dienste (Presence) hinzufügen!
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO BEMS Dienst "Good Technologies Common Services"
ECHO.
ECHO Status:
sc query "GoodServerDistribution" | findstr STATE
ECHO.
ECHO Was moechtest Du tun?
ECHO ---------------------
ECHO.
ECHO 1. Dienst starten
ECHO 2. Dienst stoppen
ECHO 3. Dienst neustarten
ECHO 4. Abbrechen
ECHO.
set /p action=Deine Auswahl (1-4)?
IF %action% == 1 net start "Good Technology Common Services" 2>nul
IF %action% == 2 net stop "Good Technology Common Services" 2>nul
IF %action% == 3 net stop "Good Technology Common Services" 2>nul & net start "Good Technology Common Services" 2>nul
IF %action% == 4 GOTO start
ECHO.
ECHO OK! Neuer Status:
sc query "GoodServerDistribution" | findstr STATE
ECHO.
PAUSE
GOTO start

:bemscsr
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO BEMS Certificate Service
ECHO.
ECHO Wir erzeugen einen neuen Keystore bemsnew.pfx und einen CSR, der dann von der Kunden CA signiert werden muss.
ECHO.
ECHO DEBUG: %bemsdir%
set /p yesno=Moechtest Du fortfahren (j/n)?
IF "%yesno%" == "n" GOTO start
ECHO.
ECHO Wir benoetigen einige Daten:
ECHO ----------------------------
ECHO.
set /p hostname=Bitte den hostname eingeben (z.B. BEMSHOST1):
set /p dns=Bitte DNS Suffix eingeben (z.B. example.com):
set /p org=Bitte DN Organisation eingeben (z.B. Firmenname):
set /p country=Bitte DN Country eingeben (z.B. DE):
set d=%date:~-4%%date:~3,2%%date:~0,2%
ECHO Arbeitsordner: %bemsdir% wird angelegt.
mkdir %bemsdir%
set /p yesno=Moechtest Du fortfahren (j/n)?
IF "%yesno%" == "n" GOTO start

:certalldata
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO BEMS Certificate Service
ECHO.
ECHO Zusammenfassung:
ECHO ----------------
ECHO.
ECHO Hostname: %hostname%
ECHO DNS Suffix: %dns%
ECHO Demnach FQDN: %hostname%.%dns%
REM ECHO Es gibt insgesamt %countca% Zertifikate in der key chain. Diese heissen:
REM ECHO Root CA: %rootca%
REM IF %countca% == 2 ECHO 1. Intermediate Zertifikat: %interca1%
REM IF %countca% == 3 ECHO 1. Intermediate Zertifikat: %interca1% & ECHO. & ECHO 2. Intermediate Zertifikat: %interca2%
REM IF %countca% == 4 ECHO 1. Intermediate Zertifikat: %interca1% & ECHO. & ECHO 2. Intermediate Zertifikat: %interca2% & ECHO. & ECHO 3. Intermediate Zertifikat: %interca3%
ECHO Die Organisation: %org%
ECHO Das Land: %country%
ECHO Datum Suffix: %d%
ECHO JAVA_HOME: %JAVA_HOME%
ECHO Der Arbeitsordner: %bemsdir%
ECHO.
set /p yesno=Ist das alles korrekt (j/n)?
IF "%yesno%" == "n" GOTO certkorr
GOTO certcreate
EXIT

:certcreate
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO BEMS Certificate Service
ECHO.
ECHO Arbeitsordner: %bemsdir%
ECHO Das Zertifikat wird folgende Daten enthalten: CN=%hostname%.%dns%, O=%org%, C=%country% und SAN=%hostname%.%dns% und %hostname%
%keytool% -genkeypair -noprompt -alias serverkey -keyalg RSA -keystore "%bemsdir%\bemsnew.pfx" -keysize 2048 -dname "CN=%hostname%.%dns%, O=%org%, C=%country%" -ext SAN=DNS:%hostname%.%dns%,DNS:%hostname% -validity 730 -storepass changeit
%keytool% -certreq -noprompt -alias serverkey -file "%bemsdir%\%hostname%_%d%.csr" -keystore "%bemsdir%\bemsnew.pfx" -storepass changeit -keypass changeit -ext SAN=DNS:%hostname%.%dns%,DNS:%hostname%
%keytool% -list -v -keystore "%bemsdir%\bemsnew.pfx" -storepass changeit > %bemsdir%\keystore_check.txt
%keytool% -printcertreq -file "%bemsdir%\%hostname%_%d%.csr" -v > %bemsdir%\CSR_check.txt
PAUSE
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO BEMS Certificate Service
ECHO.
ECHO Der Keystore wurde angelegt und ein CSR in der Datei %hostname%_%d%.csr erstellt.
ECHO Bitte pruefe Keystore und CSR in den Dateien keystore_check.txt und CSR_check.txt! Beide findest Du im Ordner %bemsdir%.
ECHO.
echo Als naechstes bitte den CSR vom Kunden signieren lassen und dann die Zertifikate importieren.
ECHO.
set /p yesno=Ist alles ok (j/n)?
IF "%yesno%" == "n" GOTO bemscsr
GOTO start
PAUSE
GOTO start
EXIT

:certkorr
ECHO.
ECHO Welche Daten moechtest Du korrigieren?
ECHO --------------------------------------
ECHO.
ECHO 1. Hostname: %hostname%
ECHO 2. DNS Suffix: %dns%
ECHO 3. Die Organisation: %org%
ECHO 4. Das Land: %country%
ECHO 5. Abbrechen
ECHO (JAVA_HOME bitte im System anpassen sysdm.cpl)
ECHO.
set /p action=Deine Auswahl (1-5)?
ECHO.
IF %action% == 1 set /p hostname=Bitte den hostname eingeben (z.B. BEMSHOST1):
IF %action% == 2 set /p dns=Bitte DNS Suffix eingeben (z.B. example.com):
IF %action% == 3 set /p org=Bitte DN Organisation eingeben (z.B. Firmenname):
IF %action% == 4 set /p country=Bitte DN Country eingeben (z.B. DE):
IF %action% == 5 GOTO start
GOTO certalldata
EXIT

:intermediate
ECHO.
set /p countca=Wie viele Zertifikate gibt es in der key chain (z.B. root CA, Policy CA, Issuing CA) (1-4)?
IF %countca% == 2 set /p interca1=Bitte CA Intermediate Name 1 eingeben:
IF %countca% == 3 set /p interca2=Bitte CA Intermediate Name 2 eingeben:
IF %countca% == 4 set /p interca3=Bitte CA Intermediate Name 3 eingeben:
GOTO certalldata
EXIT


:bemscert
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO BEMS Certificate Service
ECHO.
ECHO -------------------------------------------------------------------------------------------------
ECHO *!BETA ALARM!* Bitte Ergebnisse genau ueberpruefen! Fehler bitte reporten (tz@agilimo.de)! Danke!
ECHO -------------------------------------------------------------------------------------------------
ECHO.
ECHO Wir fuegen die Zertifikate den keystores bemsnew.pfx und JAVA cacerts hinzu.
ECHO Hierzu benoetigen wir alle Zertfikate der key chain und das vom Kunden signierte neue Zertifikat.
ECHO.
set /p yesno=Moechtest Du fortfahren (j/n)?
IF "%yesno%" == "n" GOTO start
ECHO.
ECHO Wir benoetigen einige Daten:
ECHO ----------------------------
ECHO.
set /p countca=Wie viele Zertifikate gibt es in der key chain (z.B. root CA, Policy CA, Issuing CA) (1-4)?
set /p rootca=Bitte CA Root Name eingeben (z.B. Company Root CA):
IF %countca% == 2 set /p interca1=Bitte CA Intermediate Name 1 eingeben:
IF %countca% == 3 set /p interca1=Bitte CA Intermediate Name 1 eingeben: & set /p interca2=Bitte CA Intermediate Name 2 eingeben:
IF %countca% == 4 set /p interca1=Bitte CA Intermediate Name 1 eingeben: & set /p interca2=Bitte CA Intermediate Name 2 eingeben: & set /p interca3=Bitte CA Intermediate Name 3 eingeben:
ECHO.
ECHO Diese Zertifikate und das neue Zertifikat (vom Kunden signiert) bitte im Ordner %rootDirectory%\_BB_Install\Certificates\bems ablegen.
ECHO.
ECHO Bitte die vollstaendigen Dateinamen der Zertifikate angeben!
set /p rootcert=Dateiname %rootca%:
IF %countca% == 2 set /p cert1=Dateiname %interca1%:
IF %countca% == 3 set /p cert1=Dateiname %interca1%: & set /p cert2=Dateiname %interca2%:
IF %countca% == 4 set /p cert1=Dateiname %interca1%: & set /p cert2=Dateiname %interca2%: & set /p cert3=Dateiname %interca3%:
set /p newcert=Dateiname des neuen Zertifikats:
ECHO.
set /p yesno=Liegen diese Zertifikate nun im Ordner %rootDirectory%\_BB_Install\Certificates\bems (j/n)?
IF "%yesno%" == "n" GOTO bemscert
ECHO.
ECHO Gut, wir schauen uns das noch einmal an:
ECHO ----------------------------------------
ECHO.
ECHO %rootca% Dateiname: %rootcert%
IF %countca% == 2 ECHO %interca1% Dateiname: %cert1%
IF %countca% == 3 ECHO %interca1% Dateiname: %cert1% & ECHO %interca2% Dateiname: %cert2%
IF %countca% == 4 ECHO %interca1% Dateiname: %cert1% & ECHO %interca2% Dateiname: %cert2% & ECHO %interca3% Dateiname: %cert3%
ECHO Neues Zertifikat Dateiname: %newcert%
ECHO.
set /p yesno=Alles korrekt (j/n)?
IF "%yesno%" == "n" GOTO bemscert
ECHO.
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO BEMS Certificate Service
ECHO.
ECHO Import startet...
ECHO.
ECHO Backup von "%JAVA_HOME%"\lib\security\cacerts nach cacerts_orig...
copy "%JAVA_HOME%"\lib\security\cacerts "%JAVA_HOME%"\lib\security\cacerts_orig
ECHO Import in "%JAVA_HOME%"\lib\security\cacerts
%keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%rootcert%" -alias "%rootca%" -keystore "%JAVA_HOME%\lib\security\cacerts"
IF %countca% == 2 %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert1%" -alias "%interca1%" -keystore "%JAVA_HOME%\lib\security\cacerts"
IF %countca% == 3 %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert1%" -alias "%interca1%" -keystore "%JAVA_HOME%\lib\security\cacerts" & %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert2%" -alias "%interca2%" -keystore "%JAVA_HOME%\lib\security\cacerts"
IF %countca% == 4 %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert1%" -alias "%interca1%" -keystore "%JAVA_HOME%\lib\security\cacerts" & %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert2%" -alias "%interca2%" -keystore "%JAVA_HOME%\lib\security\cacerts" & %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert3%" -alias "%interca3%" -keystore "%JAVA_HOME%\lib\security\cacerts"
ECHO Import in cacerts beendet.
ECHO.
ECHO Backup von %bemsdir%\bemsnew.pfx nach bemsnew_orig.pfx...
copy %bemsdir%\bemsnew.pfx %bemsdir%\bemsnew_orig.pfx
ECHO Import in %bemsdir%\bemsnew.pfx
%keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%rootcert%" -alias "%rootca%" -keystore "%bemsdir%\bemsnew.pfx"
IF %countca% == 2 %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert1%" -alias "%interca1%" -keystore "%bemsdir%\bemsnew.pfx"
IF %countca% == 3 %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert1%" -alias "%interca1%" -keystore "%bemsdir%\bemsnew.pfx" & %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert2%" -alias "%interca2%" -keystore "%bemsdir%\bemsnew.pfx"
IF %countca% == 4 %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert1%" -alias "%interca1%" -keystore "%bemsdir%\bemsnew.pfx" & %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert2%" -alias "%interca2%" -keystore "%bemsdir%\bemsnew.pfx" & %keytool% -import -noprompt -trustcacerts -file "%bemsdir%\%cert3%" -alias "%interca3%" -keystore "%bemsdir%\bemsnew.pfx"
%keytool% -importcert -noprompt -keystore "%bemsdir%\bemsnew.pfx" -storepass changeit -file "%bemsdir%\%newcert%" -alias serverkey
REM Hier noch einmal keystores auslesen und in Dateien schreiben.
ECHO Import in bemsnew.pfx beendet. Bitte nun noch die jetty.xml anpassen!
PAUSE
GOTO start
EXIT

:connection
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
REM Existiert Script in workdir?
ECHO Verbindungstest zum BlackBerry NOC (Ports 3101, 443)
ECHO.
ECHO Hinweise:
ECHO ---------
ECHO.
ECHO - Im Verzeichnis Scripts muss das PS-Skript connnection.ps1 vorhanden sein.
ECHO - Fuer BEMS ist nur gdweb.good.com:443 notwendig
ECHO.
if not exist %rootDirectory%\_BB_Install\Scripts\connection.ps1 ECHO Das Skript connections.ps1 ist nicht vorhanden! Kopiere JETZT das Skript und wähle dann "j".
set /p yesno=Moechtest Du fortfahren (j/n)?
IF "%yesno%" == "n" GOTO start
REM Berechtigung prüfen
:conrighttest
ECHO.
ECHO Berechtigungstest
ECHO.
ECHO Status der Berechtigung zur Skriptausfuehrung in PowerShell:
FOR /f "tokens=*" %%i in ('powershell Get-ExecutionPolicy -List ^| findstr "CurrentUser"') DO set psstate=%%i
ECHO %psstate%
ECHO Der Wert fuer CurrentUser muss "Bypass" lauten.
ECHO %psstate%|findstr "Bypass">nul && GOTO contest

:conrightchange
ECHO.
ECHO Die Berechtigung muss geaendert werden!
set /p var=Soll dies in Absprache mit dem Kunden (!) geschehen (j/n)?
IF %var% == "n" GOTO start
ECHO.
ECHO OK, wir aendern die Berechtigung...
powershell Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
ECHO Berechtigung jetzt:
powershell Get-ExecutionPolicy -List | findstr CurrentUser
set /p var=Wir testen jetzt die Verbindungen zum BlackBerry NOC auf Port 3101 und 443, ok (j/n)?
IF %var% == "n" GOTO start

:contest
CLS
ECHO %ass%
ECHO ----------------------------------------------
ECHO.
ECHO Verbindungstest...
ECHO.
powershell -f %rootDirectory%\_BB_Install\Scripts\connection.ps1
set /p var=Soll die Berechtigung wieder zurueckgesetzt werden (undefind) (j/n)?
IF %var% == "n" GOTO start
powershell Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
GOTO start