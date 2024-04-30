# IW4X Playlist Generator

The batch file should be pretty self-explanatory when you open and edit it but here are further instructions:

1. Download [playlist_generator.bat](playlist_generator.bat) and put it in the same folder as your `server.cfg`

2. Edit the batch file (with Notepad or anything) to your liking with the modes and maps you want
   
4. Check the line number in your `server.cfg` where you want to append your generated playlist

e.g. your `server.cfg` will look something like this:

```
Line 1 ...
Line 2 ...
...
Line 521 set sv_maprotation "" // keep sv_maprotation empty as we will use the generated playlist instead
```

so you want to add the playlist after Line 521 so in `playlist_generator.bat` you would be editing this line:

```
if !lineCount! leq 521 (
```

4. Schedule for `playlist_generator.bat` to be run daily assuming. Assuming your server restarts daily also, each day the playlist should remain the same but in a different order.

## Backups

Although this script is not fully tested and should not cause any problems, please ensure you keep backups of important files before using it. It should only modify `server.cfg`, and the first part of the script creates a backup `server_backup.cfg` that you can revert to if there are any issues.

It also creates a folder `previous_playlists` and keeps a copy of the playlist rotations it creates, one per day.

## Example

```
set modes=war dm dom
set maps=mp_nuked mp_boneyard mp_carentan mp_shipment_long
```

Make sure to leave a space in between each map or mode and that it's spelled correctly. It will generate every possible combination out of what you have selected. 

If there are specific combinations you know you want removed then you can set that in the next part:

```
set exclude=dom_mp_nuked dom_mp_shipment_long
```

If there are specific combinations you want to include you can use the next part:

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

Which would get shuffled and added to the end of your `server.cfg`.
