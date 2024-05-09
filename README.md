# IW4X Playlist Generator

The batch file should be pretty self-explanatory when you open and edit it but here are further instructions:

1. Download [playlist_generator.bat](playlist_generator.bat) and put it in the same folder as the server configuration file you want to generate a playlist for. The default name it will look for is `server.cfg` which can be changed at the beginning of the script here:
```
set "serverConfigFile=server.cfg"
```
2. Set the maps and modes you want it to generate here:
```
set modes=
set maps=
set exclude= 
set include=
```
3. If you have multiple server configuration files, make a copy of the batch file for each one and follow steps 1 and 2 again.

4. Run the batch file when required. I recommend scheduling it once per day with a server restart.

## Example
```
set modes=war dm dom
set maps=mp_nuked mp_boneyard mp_carentan mp_shipment_long
```
Make sure to leave a space in between each map or mode and that it's spelled correctly. It will generate every possible combination out of what you have selected. 

If there are specific combinations that will be generated that you know you want removed then you can set that in the next part:
```
set exclude=dom_mp_nuked dom_mp_shipment_long
```
If there are specific combinations that you would like to include outside of what is generated you can set that in the next part:
```
set include=sd_mp_crash
```
Make sure to include a `_` between the mode and map for exclude and include.

The output of this example will be:
```
addGametype war 
addMap mp_nuked 
addGametype war 
addMap mp_boneyard
addGametype war 
addMap mp_carentan 
addGametype war 
addMap mp_shipment_long 
addGametype dm 
addMap mp_nuked 
addGametype dm
addMap mp_boneyard
addGametype dm 
addMap mp_carentan 
addGametype dm
addMap mp_shipment_long
addGametype dom 
addMap mp_boneyard
addGametype dom 
addMap mp_carentan 
addGametype sd
addMap mp_crash
```
This ouput gets shuffled and added to the end of your server configuration file to make up the map rotation for your server.

## Backup

I have tested this on Windows and found it quite effective but in case something goes wrong, the script creates a directory named `previous_playlists` where it first makes a backup of your server configuration file. Here you will also find a record of the playlists generated, limited to one per day. 

Please keep your own backups of important files as well.

The script assumes `set sv_maprotation` is the last line of your server configuration file. Make sure `set sv_maprotation ""` is your last line, also you can remove anything within `""` as you will use what is generated as your map rotation instead. Anything after `set sv_maprotation ""` will be discarded when running the script - you shouldn't have anything here anyway but if you do, move it to be on lines before `set sv_maprotation`.

## Plans

1. GUI for selecting map/mode combos
2. Test Linux compatibility
3. Turn into a GSC Script (and possibly incorporate advanced map rotation by Muhlex or Xerxes)
