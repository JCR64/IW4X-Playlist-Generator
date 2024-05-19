@echo off
setlocal enabledelayedexpansion

:: Set the name of the server configuration file you want to generate a playlist for
set "serverConfigFile=server.cfg"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: modes = war dm dom koth sab sd arena dd ctf oneflag gtnw conf gun infect     ::
:: maps = mp_afghan             mp_cross_fire           mp_alpha                ::
::        mp_derail             mp_cargoship            mp_bravo                ::
::        mp_estate             mp_killhouse            mp_dome                 ::
::        mp_favela             mp_bog_sh               mp_hardhat              ::
::        mp_highrise           mp_shipment             mp_paris                ::
::        mp_invasion           mp_bloc                 mp_plaza2               ::
::        mp_checkpoint         mp_farm                 mp_seatown              ::
::        mp_quarry             mp_backlot              mp_underground          ::
::        mp_rundown            mp_pipeline             mp_village              ::
::        mp_rust               mp_countdown                                    ::
::        mp_boneyard           mp_carentan             mp_nuked                ::
::        mp_nightshift         mp_broadcast            mp_firingrange          ::
::        mp_subbase            mp_showdown                                     ::
::        mp_terminal           mp_convoy               mp_shipment_long        ::
::        mp_underpass          mp_citystreets          mp_rust_long            ::
::        mp_brecourt                                                           ::
::        mp_complex            mp_cargoship_sh         oilrig                  ::
::        mp_crash              mp_bloc_sh              co_hunted               ::
::        mp_overgrown          mp_storm_spring         iw4_credits             ::
::        mp_compact            mp_fav_tropical                                 ::
::        mp_storm              mp_estate_tropical                              ::
::        mp_abandon            mp_crash_tropical                               ::
::        mp_fuel2              mp_crash_snow                                   ::
::        mp_strike                                                             ::
::        mp_trailerpark                                                        ::
::        mp_vacant                                                             ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Set maps and modes to combine
set modes=war dm sab
set maps=mp_afghan mp_derail mp_estate mp_favela mp_highrise mp_invasion mp_checkpoint mp_quarry mp_rundown mp_rust mp_boneyard mp_nightshift mp_subbase mp_terminal mp_underpass mp_brecourt

:: Set combos to avoid
set exclude=dm_mp_rust sab_mp_rust

:: Set special combos to include
set include=dd_mp_afghan dd_mp_derail dd_mp_estate dd_mp_favela dd_mp_highrise

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                                              ::
::                         NO NEED TO EDIT ANYTHING BELOW                       ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

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

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                                              ::
::        DELETE/UNCOMMENT BELOW IF YOU WANT TO MANUALLY ADD PLAYLIST.TXT       ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Set the source file name and backup folder
set "source=playlist.txt"
set "backupFolder=previous_playlists"

:: Create a backup folder if it doesn't exist
if not exist "%backupFolder%" mkdir "%backupFolder%"

:: Check if server.cfg exists in the previous_playlists folder and make a copy if it doesn't
if not exist "%backupFolder%\%serverConfigFile%" (
    copy "%serverConfigFile%" "%backupFolder%\%serverConfigFile%"
    echo Backup of %serverConfigFile% created in %backupFolder%.
) else (
    echo Backup of %serverConfigFile% already exists in %backupFolder%.
)

:: Extract the file name without the extension from serverConfigFile
for %%i in ("%serverConfigFile%") do set "configName=%%~ni"

:: Format the date as YYYY_MM_DD and set as the target file name
set "dateString=%date:~-4,4%_%date:~-7,2%_%date:~-10,2%_%configName%.txt"
set "target=%backupFolder%\%dateString%"

:: Copy the file to the backup folder with the new name
copy "%source%" "%target%"
echo File copied and renamed to %target%

:: Find the line number of set "sv_maprotation "in the server configuration file
for /f "delims=:" %%a in ('findstr /n /c:"set sv_maprotation " "%serverConfigFile%"') do set "lineNum=%%a"

:: Copy lines up to "set sv_maprotation " into a new temporary file, including empty lines
set "count=0"
>temp_server.cfg (
    for /f "tokens=1* delims=:" %%a in ('findstr /n /r /c:".*" "%serverConfigFile%"') do (
        set "line=%%b"
        if not defined line set "line="
        set /a "count+=1"
        if !count! lss !lineNum! (
            echo(!line!
        ) else if !count! equ !lineNum! (
            echo(set sv_maprotation ^"^")
        )
    )
)
:: Append a blank line to the temporary server configuration file
echo. >> temp_server.cfg

:: Append the playlist to the temporary server configuration file
type playlist.txt >> temp_server.cfg

:: Replace the original server configuration file with the new temporary file
move /y temp_server.cfg "%serverConfigFile%"

:: Delete leftover playlist file
if exist playlist.txt del playlist.txt

endlocal
