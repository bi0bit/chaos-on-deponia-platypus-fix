# Chaos on Deponia: Earth Platypus Minigame Fix

A Windows patch for the Earth Platypus puzzle's corrupted
saved-state problem: a missing egg/platypus, disappearing stones, or
unclickable holes caused by missing puzzle tables or a stale puzzle lock.

**[Download EarthPlatypusFix-v2.zip](https://github.com/bi0bit/chaos-on-deponia-platypus-fix/releases/download/v2/EarthPlatypusFix-v2.zip)**
([release notes](https://github.com/bi0bit/chaos-on-deponia-platypus-fix/releases/tag/v2))

## Requirements

- Windows version of Chaos on Deponia, supported build **3.3.2351 /
  Visionaire player 4.2**, with the supported original game archive.
- Windows PowerShell 5.1 and .NET; no Python or additional runtime installation
  is required.
- A writable game folder and space for original archive and save backups.

The version label alone is insufficient: other editions, languages with a
different archive, and modified game archives are safely refused.

## Install

1. Close the game and extract the downloaded ZIP.
2. In Steam, right-click **Chaos on Deponia > Manage > Browse local files**.
3. Copy the entire **EarthPlatypusFix** folder beside `deponia2.exe` and `data.vis`.
4. Open that folder and double-click **Install.cmd**.
5. Wait for the success message, start through Steam, and load your save.
6. Play the puzzle normally and save in a new slot after confirming it works.

Use the named release asset above. GitHub's automatically generated
**Source code (zip)** is a separate repository download.

The installer backs up the original archive and existing saves
in **EarthPlatypusFixBackup** inside the game folder. Saves are never edited.

## Uninstall

Close the game and double-click **Uninstall.cmd**. It restores the
original archive, retaining current saves and all backups. Keep the backup
folder; uninstall refuses to overwrite an archive changed by a mod or update.

## Behavior and scope

The repair restores missing coordinate and sprite constants and clears the
stale lock only while the unsolved puzzle is active. If the egg's position
has been lost, only this puzzle's layout is restarted. Valid positions are
retained, and the puzzle is not automatically completed.

This release contains the minigame repair only. It includes no FPS limiter,
resolution changes, personal saves, or full game archive. It does not fix
every possible high-refresh-rate input issue.

Readable installer source and the binary delta are in [EarthPlatypusFix](EarthPlatypusFix).
