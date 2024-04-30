@echo off
setlocal enabledelayedexpansion

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: modes = war dm dom koth sab sd arena dd ctf oneflag gtnw		    	::
:: maps = mp_afghan		mp_cross_fire		mp_alpha	    	::
::	  mp_derail		mp_cargoship		mp_bravo  		::
::	  mp_estate		mp_killhouse		mp_dome			::
::	  mp_favela		mp_bog_sh		mp_hardhat		::
::        mp_highrise		mp_shipment		mp_paris		::
::        mp_invasion		mp_bloc			mp_plaza2		::
::        mp_checkpoint		mp_farm			mp_seatown		::
::        mp_quarry		mp_backlot		mp_underground		::
::        mp_rundown		mp_pipeline		mp_village		::
::        mp_rust		mp_countdown					::
::        mp_boneyard		mp_carentan		mp_nuked		::
::        mp_nightshift 	mp_broadcast		mp_firingrange		::
::        mp_subbase 	  	mp_showdown					::
::        mp_terminal 		mp_convoy		mp_shipment_long	::
::        mp_underpass 		mp_citystreets		mp_rust_long		::
::        mp_brecourt 								::
::        mp_complex 		mp_cargoship_sh		oilrig			::
::        mp_crash 		mp_bloc_sh		co_hunted		::
::        mp_overgrown 		mp_storm_spring		iw4_credits		::
::        mp_compact 		mp_fav_tropical					::
::        mp_storm 		mp_estate_tropical				::
::        mp_abandon		mp_crash_tropical				::
::        mp_fuel2								::
::        mp_strike								::
::        mp_trailerpark							::
::        mp_vacant								::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Set maps and modes to combine
set modes=sab dd
set maps=mp_afghan mp_derail mp_estate mp_favela mp_highrise mp_invasion mp_checkpoint mp_quarry mp_rundown mp_rust mp_boneyard mp_nightshift mp_subbase mp_terminal mp_underpass mp_brecourt mp_complex mp_crash mp_overgrown mp_compact mp_storm mp_abandon mp_fuel2 mp_strike mp_trailerpark mp_vacant
  
:: Set combos to avoid
set exclude=dd_mp_rust sab_mp_estate sab_mp_derail sab_mp_fuel2

:: Set special combos to include
set include=war_mp_shipment war_mp_rust war_mp_nuked sab_mp_cross_fire

:: Clears any temporary playlist files before generating
if exist tempplaylist.txt del tempplaylist.txt
if exist playlist.txt del playlist.txt

:: Generate all possible combinations into a temporary file
for %%m in (%maps%) do (
    for %%d in (%modes%) do (
        set "combo=%%d_%%m"
        set "addcombo=true"
        
        :: Check if the combination is in the exclude list
        for %%x in (%exclude%) do (
            if "!combo!"=="%%x" set "addcombo=false"
        )
        
        :: Add the combination if it's not in the exclude list
        if !addcombo! equ true (
            echo addGametype %%d addMap %%m >> tempplaylist.txt
        )
    )
)

:: Add the special combos
for %%i in (%include%) do (
    set "combo=%%i"
    :: Replace the first underscore with 'addMap'
    for /f "tokens=1* delims=_" %%a in ("!combo!") do (
        set "combo=addGametype %%a addMap %%b"
    )
    echo !combo! >> tempplaylist.txt
)

:: Shuffle lines
for /f "delims=" %%a in (tempplaylist.txt) do call set "$$%%random%%=%%a"
(for /f "tokens=1,* delims==" %%a in ('set $$') do echo(%%b)>tempplaylist.txt

:: Process each line in the input file
for /f "tokens=1,2,3,* delims= " %%a in (tempplaylist.txt) do (
    echo %%a %%b >> playlist.txt
    echo %%c %%d >> playlist.txt
)

:: Delete temp playlist file
if exist tempplaylist.txt del tempplaylist.txt

:: Set the source file name and backup folder
set "source=playlist.txt"
set "backupFolder=previous_playlists"

:: Create a backup folder if it doesn't exist
if not exist "%backupFolder%" mkdir "%backupFolder%"

:: Format the date as YYYY_MM_DD and set as the target file name
set "dateString=%date:~-4,4%_%date:~-7,2%_%date:~-10,2%.txt"
set "target=%backupFolder%\%dateString%"

:: Copy the file to the backup folder with the new name
copy "%source%" "%target%"
echo File copied and renamed to %target%

:: Set the server file name
copy "server.cfg" "server_backup.cfg"

:: Keep the first 521 lines of server.cfg, including empty lines
set "lineCount=0"
>server_new.cfg (
    for /F "delims=" %%i in ('findstr /n "^" server.cfg') do (
        set "line=%%i"
        set "line=!line:*:=!"
        set /a "lineCount+=1"
        if !lineCount! leq 521 (
            echo(!line!
        )
    )
)

:: Append input.txt to the new output file
type playlist.txt >> server_new.cfg

:: Replace the old output.txt with the new file
move /y server_new.cfg server.cfg

:: Delete leftover playlist file
if exist playlist.txt del playlist.txt

endlocal
