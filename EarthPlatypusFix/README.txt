CHAOS ON DEPONIA - EARTH PLATYPUS MINIGAME FIX (v2)

INSTALL
1. Close the game.
2. In Steam, right-click Chaos on Deponia > Manage > Browse local files.
3. Extract this ZIP and copy the entire EarthPlatypusFix folder into that
   game folder, beside deponia2.exe and data.vis.
4. Open EarthPlatypusFix and double-click Install.cmd.
5. Wait for "Installed: Earth Platypus minigame fix", then start the game
   through Steam, load your save, and play the puzzle normally.

No Python, downloads, or extra runtime installation required. Uses built-in
Windows PowerShell and .NET. Administrator access is normally unnecessary;
the game folder must be writable. If the package is elsewhere, the installer
asks you to paste the game folder path.

WHAT THIS FIXES
Missing Earth Platypus egg/platypus, disappearing stones, and inactive hole
hotspots caused by missing saved puzzle tables or a stale puzzle lock.
It restores the original puzzle coordinate/sprite constants. If the egg's
position was lost, it restarts only this puzzle's layout. It does not skip
the puzzle, mark it solved, or edit your saved games.

Only the minigame repair is included. No FPS limiter, SDL DLL replacement,
resolution changes, personal saves, or full game archive is included.
This is the version 2 repair previously confirmed working by the player.
It does not fix every possible high-refresh-rate input issue.

COMPATIBILITY
Windows game build 3.3.2351 / Visionaire player 4.2, with an exact archive
checksum match. Only the specific archive listed in manifest.json has been
tested. Other versions, languages with different archives, and modified
archives are refused without changing game or save files.

BACKUPS
Before installation, the original archive and any existing save/profile
files are copied into EarthPlatypusFixBackup in the game folder and verified
with SHA-256. Current saves are never overwritten by install or uninstall.
Keep this backup folder if you want to uninstall later.

UNINSTALL
Close the game and double-click Uninstall.cmd. The installer restores the
verified original archive and keeps your current saves and all backups.
It refuses to overwrite an archive changed by another mod or a game update.
Steam file verification or an update may remove the patch.

VALIDATION
The binary delta reconstructs exactly the known version 2 archive. Only
three puzzle script strings differ from the supported original; the other
2,628 archive resources are unchanged. The saved-state repair was tested
under Lua 5.1 and the player confirmed the puzzle worked in-game.

This is an unofficial local repair, not a Daedalic release. The ZIP contains
the binary delta, readable installer source, and install/uninstall launchers.
manifest.json records the original, fixed, and delta checksums.
